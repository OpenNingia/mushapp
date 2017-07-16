import QtQuick 2.7
import QtQml.Models 2.1
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2

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

    DelegateModel {

        id: filteredAbilities


        groups: [
            DelegateModelGroup { name: "bianco" },
            DelegateModelGroup { name: "nero" },
            DelegateModelGroup { name: "blu" },
            DelegateModelGroup { name: "rosso" },
            DelegateModelGroup { name: "verde" }
        ]

        filterOnGroup: "items"

        model: ListModel {
            id: abilityModel
            ListElement {
                name: qsTr("Armatura Spirituale")
                tag: "armatura_spirituale"
                blu: true; bianco: true
                //VisualDataModel.inBlu: true
                //VisualDataModel.inBianco: true
            }
            ListElement {
                name: qsTr("Aura Assassina")
                tag: "aura_assassina"
                nero: true
                //VisualDataModel.inNero: true
            }
            ListElement {
                name: qsTr("Aura Guaritrice")
                tag: "aura_guaritrice"
                //VisualDataModel.inBianco: true
            }
            ListElement {
                name: qsTr("Aura Vampiro")
                tag: "aura_vampiro"
                //// enabledOn: [ ListElement{ key: "nero" } ]
            }
            ListElement {
                name: qsTr("Bestiale")
                tag: "bestiale"
                // enabledOn: [ ListElement{ key: "verde" }, ListElement{ key: "bianco" } ]
            }
            ListElement {
                name: qsTr("Colpo del Vento")
                tag: "colpo_vento"
                // enabledOn: [ ListElement{ key: "blu" } ]
            }
            ListElement {
                name: qsTr("Colpo Possente")
                tag: "colpo_possente"
                // enabledOn: [ ListElement{ key: "verde" }, ListElement{ key: "nero" } ]
            }
            ListElement {
                name: qsTr("Energia Interiore")
                tag: "energia_interiore"
                // enabledOn: [ ListElement{ key: "rosso" }, ListElement{ key: "verde" } ]
            }
            ListElement {
                name: qsTr("Focus")
                tag: "focus"
                // enabledOn: [ ListElement{ key: "blu" } ]
            }
            ListElement {
                name: qsTr("Foglia Fluttuante")
                tag: "focus"
                // enabledOn: [ ListElement{ key: "verde" }, ListElement{ key: "bianco" } ]
            }
            ListElement {
                name: qsTr("Furia")
                tag: "furia"
                // enabledOn: [ ListElement{ key: "rosso" }, ListElement{ key: "nero" } ]
            }
            ListElement {
                name: qsTr("Gatling Combo!")
                tag: "gatling"
                // enabledOn: [ ListElement{ key: "rosso" } ]
            }
            ListElement {
                name: qsTr("Groovy!")
                tag: "groovy"
                // enabledOn: [ ListElement{ key: "rosso" }, ListElement{ key: "verde" } ]
            }
            ListElement {
                name: qsTr("Inarrestabile")
                tag: "inarrestabile"
                // enabledOn: [ ListElement{ key: "rosso" } ]
            }
            ListElement {
                name: qsTr("Ira")
                tag: "ira"
                // enabledOn: [ ListElement{ key: "rosso" }, ListElement{ key: "nero" } ]
            }
            ListElement {
                name: qsTr("Passo del Fulmine")
                tag: "passo_fulmine"
                // enabledOn: [ ListElement{ key: "blu" }, ListElement{ key: "nero" } ]
            }
            ListElement {
                name: qsTr("Pesante")
                tag: "pesante"
                // enabledOn: [ ListElement{ key: "verde" } ]
            }
            ListElement {
                name: qsTr("Presa Fulminea")
                tag: "presa_fulminea"
                // enabledOn: [ ListElement{ key: "blu" } ]
            }
            ListElement {
                name: qsTr("Presa Tornado")
                tag: "presa_tornado"
                // enabledOn: [ ListElement{ key: "rosso" } ]
            }
            ListElement {
                name: qsTr("Prudenza")
                tag: "prudenza"
                // enabledOn: [ ListElement{ key: "blu" }, ListElement{ key: "bianco" } ]
            }
            ListElement {
                name: qsTr("Rigenerazione")
                tag: "rigenerazione"
                // enabledOn: [ ListElement{ key: "bianco" } ]
            }
            ListElement {
                name: qsTr("Ritmico")
                tag: "ritmico"
                // enabledOn: [ ListElement{ key: "verde" } ]
            }
            ListElement {
                name: qsTr("Robusto")
                tag: "robusto"
                // enabledOn: [ ListElement{ key: "verde" }, ListElement{ key: "bianco" } ]
            }
            ListElement {
                name: qsTr("Sacrificio di Sangue")
                tag: "sacrificio_sangue"
                // enabledOn: [ ListElement{ key: "bianco" } ]
            }
            ListElement {
                name: qsTr("Ultima Chance")
                tag: "ultima_chance"
                // enabledOn: [ ListElement{ key: "bianco" }, ListElement{ key: "nero" } ]
            }
            ListElement {
                name: qsTr("Underdog")
                tag: "underdog"
                // enabledOn: [ ListElement{ key: "rosso" }, ListElement{ key: "blu" } ]
            }
        }

        Component.onCompleted: {
            //var rowCount = myModel.count;
            //items.remove(0,rowCount);
            for( var i=0; i < model.count; i++ ) {
                var entry = model.get(i);
                var groups = []
                if(entry.blu)
                    groups.push("blu");
                if(entry.verde)
                    groups.push("verde");
                if(entry.rosso)
                    groups.push("rosso");
                if(entry.bianco)
                    groups.push("bianco");
                if(entry.nero)
                    groups.push("nero");
                console.log('set item ' + i + ' in groups ' + groups)
                items.setGroups(i, 1, groups);
            }
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
                    charModel.aura.special = ""
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
                model: filteredAbilities

                onActivated: {
                    charModel.aura.special = abilityModel.get(index).tag
                    save()
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
