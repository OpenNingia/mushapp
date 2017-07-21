import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import "fa"
import "business/moves.js" as Moves

Page {
    id: root

    property var charModel: null
    property bool superMove: false
    property bool hasName: false
    property var selectedSymbols: []
    property int paCost: Moves.calcPaCost(selectedSymbols, superMove)

    property var initialize: function() {
        inputName.forceActiveFocus()
    }

    property var finalize: function() {
    }

    property var reload: function() {
        symbolList.model = 0
        symbolList.model = root.selectedSymbols
        paCost = Moves.calcPaCost(root.selectedSymbols, superMove)
    }

    /*Component.onCompleted: {

    }*/

    /*
    header: PageHeader {
        title: charModel.name
        onBackClicked: root.StackView.view.pop()
    }*/

    ListModel {
        id: symbolsModel
        ListElement {
            name: qsTr("2xCombo")
            tag: "combo"
            isChecked: false
            portrait: "qrc:/img/combo.png"
        }
        ListElement {
            name: qsTr("Assorbe")
            tag: "assorbimento"
            isChecked: false
            portrait: "qrc:/img/assorbimento.png"
        }
        ListElement {
            name: qsTr("Blitz")
            tag: "blitz"
            isChecked: false
            portrait: "qrc:/img/blitz.png"
        }
        ListElement {
            name: qsTr("Crolla")
            tag: "crolla"
            isChecked: false
            portrait: "qrc:/img/crolla.png"
        }
        ListElement {
            name: qsTr("Cade")
            tag: "cade"
            isChecked: false
            portrait: "qrc:/img/cade.png"
        }
        ListElement {
            name: qsTr("Conclude")
            tag: "conclusiva"
            isChecked: false
            portrait: "qrc:/img/conclusiva.png"
        }
        ListElement {
            name: qsTr("Congela")
            tag: "congela"
            isChecked: false
            portrait: "qrc:/img/congela.png"
        }
        ListElement {
            name: qsTr("Danno continuato")
            tag: "danno_continuato"
            isChecked: false
            portrait: "qrc:/img/danno_continuato.png"
        }
        ListElement {
            name: qsTr("Danno relativo")
            tag: "danno_relativo"
            isChecked: false
            portrait: "qrc:/img/danno_relativo.png"
        }
        ListElement {
            name: qsTr("Distanza")
            tag: "distanza"
            isChecked: false
            portrait: "qrc:/img/distanza.png"
        }
        ListElement {
            name: qsTr("Guarigione")
            tag: "guarigione"
            isChecked: false
            portrait: "qrc:/img/guarigione.png"
        }
        ListElement {
            name: qsTr("Multi")
            tag: "multi"
            isChecked: false
            portrait: "qrc:/img/multi.png"
        }
        ListElement {
            name: qsTr("Possente")
            tag: "possente"
            isChecked: false
            portrait: "qrc:/img/possente.png"
        }
        ListElement {
            name: qsTr("Riflette")
            tag: "riflette"
            isChecked: false
            portrait: "qrc:/img/riflette.png"
        }
        ListElement {
            name: qsTr("Salto OK")
            tag: "saltook"
            isChecked: false
            portrait: "qrc:/img/saltook.png"
        }
        ListElement {
            name: qsTr("Scaglia")
            tag: "scaglia"
            isChecked: false
            portrait: "qrc:/img/scaglia.png"
        }
        ListElement {
            name: qsTr("Schianta")
            tag: "schianta"
            isChecked: false
            portrait: "qrc:/img/schianta.png"
        }
        ListElement {
            name: qsTr("Sforzo estremo")
            tag: "sforzo_estremo"
            isChecked: false
            portrait: "qrc:/img/sforzo_estremo.png"
        }
        ListElement {
            name: qsTr("Spinge")
            tag: "spinge"
            isChecked: false
            portrait: "qrc:/img/spinge.png"
        }
        ListElement {
            name: qsTr("Stordisce")
            tag: "stordente"
            isChecked: false
            portrait: "qrc:/img/stordente.png"
        }
        ListElement {
            name: qsTr("Trasla")
            tag: "trasla"
            isChecked: false
            portrait: "qrc:/img/trasla.png"
        }
        ListElement {
            name: qsTr("Tutto per tutto")
            tag: "tutto_per_tutto"
            isChecked: false
            portrait: "qrc:/img/tutto_per_tutto.png"
        }
        ListElement {
            name: qsTr("Ultra Agility")
            tag: "uagility"
            isChecked: false
            portrait: "qrc:/img/uagility.png"
        }
        ListElement {
            name: qsTr("Ultra Durezza")
            tag: "udurezza"
            isChecked: false
            portrait: "qrc:/img/udurezza.png"
        }
        ListElement {
            name: qsTr("Vampirizza")
            tag: "vampirico"
            isChecked: false
            portrait: "qrc:/img/vampirico.png"
        }
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

        /*
        ColumnLayout {
            //anchors.fill: parent
            //anchors.margins: 10
            spacing: 10

            Layout.fillWidth: true

            Label {
                Layout.fillWidth: true
                text: qsTr("Symbols")
            }

            SymbolList {
                id: symbolList

                Layout.fillWidth: true
                height: 64
                symbols: root.selectedSymbols
            }
        }*/
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

        GridView {
            model: symbolsModel

            Layout.fillWidth: true
            Layout.fillHeight: true
            cellHeight: 50
            cellWidth: 50

            delegate: ToolButton {
                contentItem: Image {
                    source: portrait
                }
                //text: name
                height: 48; width: 48

                ToolTip.visible: down
                ToolTip.text: name

                onClicked: {
                    root.selectedSymbols.push(tag)
                    root.reload()
                }
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

                        if ( superMove )
                            charModel.superMoves.push(moveObject)
                        else
                            charModel.moves.push(moveObject)

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
