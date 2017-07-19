import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import SortFilterProxyModel 0.2

Page {
    id: root

    property var charModel
    property var availableAbilities

    property var initialize: function() {
        cbAura.currentIndex = -1;
        cbSpecial.currentIndex = -1;

        if ( charModel ) {
            for(var i=0; i<cbAura.count; i++) {
                if (cbAura.model.get(i).tag === charModel.aura.tag) {
                    cbAura.currentIndex = i;
                    break;
                }
            }

            for(var i=0; i<cbSpecial.count; i++) {
                if (cbSpecial.model.get(i).tag === charModel.aura.special) {
                    cbSpecial.currentIndex = i
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
            tag: "bianco"
        }
        ListElement {
            name: qsTr("Black")
            tag: "nero"
        }
        ListElement {
            name: qsTr("Red")
            tag: "rosso"
        }
        ListElement {
            name: qsTr("Blue")
            tag: "blu"
        }
        ListElement {
            name: qsTr("Green")
            tag: "verde"
        }
    }

    ListModel {
        id: auraSpecialModel
        ListElement {
            name: qsTr("Armatura Spirituale")
            tag: "armatura_spirituale"
            colors: "blu;bianco"
        }
        ListElement {
            name: qsTr("Aura Assassina")
            tag: "aura_assassina"
            colors: "nero"
        }
        ListElement {
            name: qsTr("Aura Guaritrice")
            tag: "aura_guaritrice"
            colors: "bianco"
        }
        ListElement {
            name: qsTr("Aura Vampiro")
            tag: "aura_vampiro"
            colors: "nero"
        }
        ListElement {
            name: qsTr("Bestiale")
            tag: "bestiale"
            colors: "verde;bianco"
        }
        ListElement {
            name: qsTr("Colpo del Vento")
            tag: "colpo_vento"
            colors: "blu"
        }
        ListElement {
            name: qsTr("Colpo Possente")
            tag: "colpo_possente"
            colors: "verde;nero"
        }
        ListElement {
            name: qsTr("Energia Interiore")
            tag: "energia_interiore"
            colors: "rosso;verde"
        }
        ListElement {
            name: qsTr("Focus")
            tag: "focus"
            colors: "blu"
        }
        ListElement {
            name: qsTr("Foglia Fluttuante")
            tag: "foglia_fluttuante"
            colors: "verde;bianco"
        }
        ListElement {
            name: qsTr("Furia")
            tag: "furia"
            colors: "rosso;nero"
        }
        ListElement {
            name: qsTr("Gatling Combo!")
            tag: "gatling"
            colors: "rosso"
        }
        ListElement {
            name: qsTr("Groovy!")
            tag: "groovy"
            colors: "rosso;verde"
        }
        ListElement {
            name: qsTr("Inarrestabile")
            tag: "inarrestabile"
            colors: "rosso"
        }
        ListElement {
            name: qsTr("Ira")
            tag: "ira"
            colors: "rosso;nero"
        }
        ListElement {
            name: qsTr("Passo del Fulmine")
            tag: "passo_fulmine"
            colors: "blu;nero"
        }
        ListElement {
            name: qsTr("Pesante")
            tag: "pesante"
            colors: "verde"
        }
        ListElement {
            name: qsTr("Presa Fulminea")
            tag: "presa_fulminea"
            colors: "blu"
        }
        ListElement {
            name: qsTr("Presa Tornado")
            tag: "presa_tornado"
            colors: "rosso"
        }
        ListElement {
            name: qsTr("Prudenza")
            tag: "prudenza"
            colors: "blu;bianco"
        }
        ListElement {
            name: qsTr("Rigenerazione")
            tag: "rigenerazione"
            colors: "bianco"
        }
        ListElement {
            name: qsTr("Ritmico")
            tag: "ritmico"
            colors: "verde"
        }
        ListElement {
            name: qsTr("Robusto")
            tag: "robusto"
            colors: "verde;bianco"
        }
        ListElement {
            name: qsTr("Sacrificio di Sangue")
            tag: "sacrificio_sangue"
            colors: "bianco"
        }
        ListElement {
            name: qsTr("Ultima Chance")
            tag: "ultima_chance"
            colors: "bianco;nero"
        }
        ListElement {
            name: qsTr("Underdog")
            tag: "underdog"
            colors: "rosso;blu"
        }
    }

    SortFilterProxyModel {
        id: auraSpecialProxyModel
        sourceModel: auraSpecialModel
        filterRoleName: "colors"
        filterPattern: charModel ? charModel.aura.tag : ""
        filterCaseSensitivity: Qt.CaseSensitive
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
                    console.log('selected aura: ' + auraModel.get(index).tag)

                    charModel.aura.tag = auraModel.get(index).tag                                       
                    charModel.aura.special = ""

                    save()

                    auraSpecialProxyModel.filterPattern = charModel.aura.tag
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

        ColumnLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("Special Ability")
                font.bold: true
            }

            ComboBox {
                Layout.fillWidth: true
                id: cbSpecial

                currentIndex: 0

                textRole: "name"
                model: auraSpecialProxyModel

                onActivated: {
                    console.log('activated: ' + cbSpecial.textAt(index))
                    charModel.aura.special = auraSpecialProxyModel.get(index).tag
                    save()
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
