import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import "fa"
import "business/moves.js" as Moves

Page {
    id: root
    property var charModel
    property bool superMoves: false
    property bool canAddMoves: false

    property var initialize: function() {
        reload()
    }

    property var finalize: function() {

    }

    property var reload: function() {
        if ( charModel ) {
            moveList.model = 0
            moveList.model = superMoves ? charModel.superMoves : charModel.moves

            canAddMoves = superMoves ? charModel.superMoves.length < 2 : charModel.moves.length < 5
        }
    }

    property var save: function() {
        // save on exit
        if ( charModel ) {
            console.log('CharacterMoveListPage: saving...')
            dataModel.characterData = JSON.stringify(charModel)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        ListView {
            id: moveList

            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            ScrollIndicator.vertical: ScrollIndicator { }

            model: null
            delegate:  ItemDelegate {
                height: txMoveName.implicitHeight + 48 + 30
                width: moveList.width - moveList.leftMargin - moveList.rightMargin
                leftPadding: 0
                onClicked: {                   
                    root.StackView.view.push(
                                "qrc:/MoveCreationPage.qml",
                                { charModel: root.charModel, superMove: superMoves, moveIndex: index })
                }

                RowLayout {
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Text {
                            id: txMoveName
                            Layout.fillWidth: true
                            text: qsTr("%1 (%2 PA)").arg(modelData.name).arg(Moves.calcPaCost(modelData.symbols, root.superMoves))
                            font.bold: true
                        }
                        SymbolList {
                            id: symbolList
                            //height: 24
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            symbols: modelData.symbols
                        }
                    }

                    DelayButton {
                        delay: 1200
                        Layout.alignment: Qt.AlignRight
                        contentItem: TextIcon {
                            icon: icons.fa_trash_o
                            pointSize: 20
                        }
                        onActivated: {
                            Moves.removeOne(root.charModel, index, root.superMoves)
                            root.save()
                            root.reload()

                        }
                    }
                }
            }
        }
    }

    footer: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                Layout.fillWidth: true
                text: superMoves ? qsTr("Add new super") : qsTr("Add new move")
                onClicked: {
                    root.StackView.view.push(
                                "qrc:/MoveCreationPage.qml",
                                { charModel: root.charModel, superMove: superMoves })
                }
                enabled: canAddMoves
            }
        }
    }
}
