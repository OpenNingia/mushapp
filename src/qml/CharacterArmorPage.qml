import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "fa"
import "business/exp.js" as Exp

MushaDynPage {
    id: root

    property var itemModel: null
    property bool isWeapon: false

    property var initialize: function() {
        charModelChanged()
    }

    property var finalize: function() {
        // save on exit
        //save()
    }

    property var save: function() {
        if ( charModel ) {
            console.log('CharacterArmorPage: saving...')
            dataModel.characterData = JSON.stringify(charModel)
        }
    }

    ColumnLayout {

        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        // NOME ARMATURA
        ColumnLayout {
            Layout.fillWidth: true
            //anchors.margins: 2
            spacing: 2

            Label {
                text: isWeapon ? qsTr("Weapon") : qsTr("Armatura")
                font.bold: true
            }
            TextField {
                id: txArmorName
                text: root.itemModel ? root.itemModel.name : ""
                Layout.fillWidth: true
                onTextChanged: root.itemModel.name = text
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Button {
                contentItem: TextIcon {
                    icon: icons.fa_tags
                    pointSize: 12
                }

                flat: true
                Layout.maximumWidth: 24
                Layout.maximumHeight: 24
                Layout.alignment: Qt.AlignVCenter

                //height: 16; width: 16
                onClicked: popup.open()
            }

            SymbolList {
                id: symbolList

                Layout.fillWidth: true
                Layout.minimumHeight: 24
                Layout.maximumHeight: 32

                symbols: itemModel ? itemModel.symbols : []

                MouseArea {
                    anchors.fill: symbolList
                    onClicked: {
                        itemModel.symbols.pop()
                        itemModelChanged()
                    }
                }

                //visible: itemModel.symbols.length !== 0
            }
        }

        // RAPIDITA'
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Speed")
                font.bold: true
            }

            RoundPicker6 {
                id: veSpeed
                rating: root.itemModel ? root.itemModel.speed||0 : 0
                onValueChanged: {
                    root.itemModel.speed = rating
                    save()
                }
            }
        }

        // ATTACCO
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Attack")
                font.bold: true
            }

            RoundPicker6 {
                id: veAttack
                rating: root.itemModel ? root.itemModel.attack||0 : 0
                onValueChanged: {
                    root.itemModel.attack = rating
                    save()
                }
            }
        }

        // DIFESA
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Defense")
                font.bold: true
            }

            RoundPicker6 {
                //Layout.alignment: Qt.AlignRight | Qt.AlignBaseline
                id: veDefense
                rating: root.itemModel ? root.itemModel.defence||0 : 0
                onValueChanged: {
                    root.itemModel.defence = rating
                    save()
                }
            }
        }

        Rectangle {
            height: 1
            Layout.minimumHeight: 1
            Layout.fillWidth: true
            color: "#3F51B5"
        }

        // STRUTTURA
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Build")
                font.bold: true
            }

            RoundPicker7 {
                id: vaBuild
                rating: root.itemModel ? root.itemModel.build : 0
                onValueChanged: {
                    root.itemModel.build = rating
                    save()
                }
            }
        }

        // INTEGRITA
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Integrity")
                font.bold: true
            }

            RoundPicker7 {
                id: vaIntegrity
                rating: root.itemModel ? root.itemModel.integrity : 0
                onValueChanged: {
                    root.itemModel.integrity = rating
                    save()
                }
            }
        }


        Rectangle {
            height: 1
            Layout.minimumHeight: 1
            Layout.fillWidth: true
            color: "#3F51B5"
        }

        Item { Layout.fillHeight: true }

        Drawer {
            id: popup
            edge: Qt.BottomEdge
            interactive: true

            height: parent.height * 0.55
            width: parent.width

            y: parent.height - height
            x: 0

            //modal: true
            focus: true

            //closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

            contentItem: SymbolSelector {
              anchors.fill: parent

              onSymbolActivated:  {
                  if ( itemModel.symbols )
                    itemModel.symbols.push(symbolId)
                  else
                      itemModel.symbols = [symbolId]
                  itemModelChanged()
              }
            }
        }
    }
}
