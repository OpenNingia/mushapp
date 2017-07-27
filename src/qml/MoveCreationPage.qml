import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import "fa"
import "business/moves.js" as Moves

Page {
    id: root

    property var charModel: null

    // moveIndex >= 0 means that we're editing an existing move
    property int moveIndex: -1

    property bool superMove: false    
    property bool hasName: false
    property var selectedSymbols: []
    property int paCost: Moves.calcPaCost(selectedSymbols, superMove)

    property var initialize: function() {
        inputName.forceActiveFocus()
        if ( moveIndex >= 0 ) {
            var moveObj = superMove ? charModel.superMoves[moveIndex] : charModel.moves[moveIndex]
            selectedSymbols = moveObj.symbols
            paCost = moveObj.cost
            inputName.text = moveObj.name
            hasName = true
        }
    }

    property var finalize: function() {
    }

    property var reload: function() {
        symbolList.model = 0
        symbolList.model = root.selectedSymbols
        paCost = Moves.calcPaCost(root.selectedSymbols, superMove)
    }



    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        TextField {
            Layout.fillWidth: true

            id: inputName
            width: 200
            placeholderText: qsTr("Enter move name")
            focus: true

            onTextEdited: {
                hasName = text.length > 0
            }
        }

        Label {
            id: txPaCost
            Layout.fillWidth: true
            text: qsTr("PA: %1").arg(paCost)
            font.bold: true
        }

        SymbolList {
            id: symbolList

            Layout.fillWidth: true
            height: 48
            symbols: root.selectedSymbols

            MouseArea {
                anchors.fill: symbolList
                onClicked: {
                    root.selectedSymbols.pop()
                    root.reload()
                }
            }
        }

        Rectangle {
            height: 1
            Layout.minimumHeight: 1
            Layout.fillWidth: true
            color: "#3F51B5"
        }

        SymbolSelector {
            Layout.fillWidth: true
            Layout.fillHeight: true

            onSymbolActivated:  {
                root.selectedSymbols.push(symbolId)
                root.reload()
            }
        }
    }

    footer: ToolBar {
        id: tabBar
        RowLayout {
            anchors.fill: parent

            ToolButton {
                id: btCancel
                Layout.fillWidth: true
                text: qsTr("Cancel")
                onClicked: {
                    root.StackView.view.pop()
                }
                KeyNavigation.tab: inputName
            }

            ToolButton {
                id: btConfirm
                Layout.fillWidth: true
                text: qsTr("Confirm")
                onClicked: {

                    var moveObject = {
                        name: inputName.text,
                        symbols: root.selectedSymbols,
                        cost: paCost
                    };

                    if ( charModel ) {

                        if ( moveIndex < 0 ) {
                            if ( superMove )
                                charModel.superMoves.push(moveObject)
                            else
                                charModel.moves.push(moveObject)
                        } else {
                            if ( superMove )
                                charModel.superMoves[moveIndex] = moveObject
                            else
                                charModel.moves[moveIndex] = moveObject
                        }

                        // save immediately
                        console.log('MoveCreationPage: saving...')
                        dataModel.characterData = JSON.stringify(charModel)
                    }

                    root.StackView.view.pop()
                }
                KeyNavigation.tab: btCancel
                enabled: hasName
            }
        }
    }
}
