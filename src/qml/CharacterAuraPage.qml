import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2

Page {
    id: root

    property var charModel
    property var initialize: function() {
        cbAura.currentIndex = 0;

        if ( charModel ) {
            for(var i=0; i<auraModel.count; i++) {
                if (auraModel.get(i).tag == charModel.aura.tag) {
                    cbAura.currentIndex = i;
                    break;
                }
            }
        }
    }

    property var save: function() {
        if ( charModel ) {
            console.log('CharacterAuraPage: saving...')
            dataModel.characterData = JSON.stringify(charModel)
        }
    }

    ListModel {
        id: auraModel
        ListElement {
            name: qsTr("None")
            tag: "none"
        }
        ListElement {
            name: qsTr("White")
            tag: "white"
        }
        ListElement {
            name: qsTr("Black")
            tag: "black"
        }
        ListElement {
            name: qsTr("Red")
            tag: "red"
        }
        ListElement {
            name: qsTr("Blue")
            tag: "blue"
        }
        ListElement {
            name: qsTr("Green")
            tag: "green"
        }
    }

    ColumnLayout {

        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        ColumnLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("Color")
                font.bold: true
            }

            ComboBox {
                Layout.fillWidth: true
                id: cbAura

                currentIndex: 0

                textRole: "name"
                model: auraModel

                onActivated: {
                    charModel.aura.tag = auraModel.get(index).tag
                    save()
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("Level")
                font.bold: true
            }

            RoundPicker5 {
                Layout.fillWidth: true
                id: pkAuraLvl
                rating: charModel ? charModel.aura.level : 0

                onValueChanged: {
                    charModel.aura.level = rating
                    save()
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("Points")
                font.bold: true
            }

            RoundPicker10 {
                Layout.fillWidth: true
                id: pkAuraPoints
                rating: charModel ? charModel.aura.points : 0

                onValueChanged: {
                    charModel.aura.points = rating
                    save()
                }

            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
