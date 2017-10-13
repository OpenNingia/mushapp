import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import "."
import "fa"
import "business/moves.js" as Moves
import "business/dal.js" as Dal
import "components"

MushaDynPage {
    id: root

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
        Dal.saveCharacter(charModel);
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
                height: txMoveName.implicitHeight + 48 + 10
                width: moveList.width - moveList.leftMargin - moveList.rightMargin
                leftPadding: 0
                onClicked: {                   
                    root.StackView.view.push(
                                "qrc:/MoveCreationPage.qml",
                                { charModel: root.charModel, superMove: superMoves, moveIndex: index })
                }

                background: Rectangle {
                    //color: Qt.lighter(Style.primaryBgColor, 2)
                    color: "#fff"
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

                            font.family: Style.uiFont.name
                            font.pointSize: 10
                            font.bold: false

                            color: Style.primaryBgColor
                        }

                        SymbolList {
                            id: symbolList
                            //height: 24
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            symbols: modelData.symbols

                        }

                    }

                    MyDelayDeleteButton {
                        Layout.alignment: Qt.AlignRight
                        Layout.rightMargin: 6

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
                id: button

                font.pointSize: 12
                font.family: Style.uiFont.name

                contentItem: Text {
                    text: button.text
                    font: button.font
                    opacity: enabled ? 1.0 : 0.3
                    color: Style.primaryFgColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    color: Style.primaryBgColor
                }

                Layout.fillWidth: true
                Layout.bottomMargin: 2
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
