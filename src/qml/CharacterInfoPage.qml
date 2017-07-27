import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "fa"
import "business/exp.js" as Exp

Page {
    id: root
    property int charExperience
    property var charModel

    property var initialize: function() {
        updateExp()

        cbSpEngine.currentIndex = -1;

        console.log("InfoPage initialize")

        if ( charModel ) {
            console.log(charModel.spEngine)
            for(var i=0; i<cbSpEngine.count; i++) {
                if (cbSpEngine.model.get(i).tag === charModel.spEngine) {
                    cbSpEngine.currentIndex = i;
                    break;
                }
            }
        }

    }

    property var finalize: function() {
        // save on exit
        save()
    }

    property var save: function() {
        if ( charModel ) {
            console.log('CharacterInfoPage: saving...')
            dataModel.characterData = JSON.stringify(charModel)

            // update experience
            updateExp()
        }
    }

    property var updateExp: function() {
        charExperience = charModel ? Exp.calcExp(charModel) : 0
        console.log('new experience: %1'.arg(charExperience))
    }

    // SP ENGINES
    ListModel {
        id: spModel
        ListElement {
            name: qsTr("Combo")
            tag: "sp_combo"
            portrait: "qrc:/img/sp_combo.png"
        }
        ListElement {
            name: qsTr("Danni")
            tag: "sp_danni"
            portrait: "qrc:/img/sp_danni.png"
        }
        ListElement {
            name: qsTr("Difesa")
            tag: "sp_difesa"
            portrait: "qrc:/img/sp_difesa.png"
        }
        ListElement {
            name: qsTr("Ferite")
            tag: "sp_ferite"
            portrait: "qrc:/img/sp_ferite.png"
        }
        ListElement {
            name: qsTr("PA")
            tag: "sp_pa"
            portrait: "qrc:/img/sp_pa.png"
        }
    }

    // TITOLO O DESCRIZIONE
    ColumnLayout {

        anchors.fill: parent
        anchors.margins: 12
        //spacing: 3

        ColumnLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("Title")
                font.bold: true
            }
            TextField {
                id: txTitle
                text: root.charModel ? root.charModel.title : ""
                Layout.fillWidth: true
                validator: RegExpValidator { regExp: /[^\"\\\/':]+/ }
                onTextChanged: root.charModel.title = text
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("SP")
                font.bold: true
            }
            ComboBox {
                id: cbSpEngine
                model: spModel
                textRole: "name"
                Layout.fillWidth: true
                onActivated: {
                    root.charModel.spEngine = model.get(index).tag
                    save()
                }

                delegate: ItemDelegate {
                    width: cbSpEngine.width
                    //height: idImg.height + 12
                    contentItem: Row {
                        topPadding: 6
                        bottomPadding: 6
                        leftPadding: 12
                        Image {
                            source: portrait
                            height: 22
                            width: 22
                        }
                        Text {
                            height: 22
                            text: name
                            font: cbSpEngine.font
                            leftPadding: 12
                        }
                    }

                    highlighted: cbSpEngine.highlightedIndex === index
                }

                indicator: Image {
                    source: spModel.get(cbSpEngine.currentIndex).portrait
                    x: cbSpEngine.width - width - cbSpEngine.rightPadding
                    y: cbSpEngine.topPadding + (cbSpEngine.availableHeight - height) / 2
                    width: 16
                    height: 16
                    visible: cbSpEngine.currentIndex >= 0
                }

            }
        }

        // PUNTI ESPERIENZA
        ColumnLayout {
            Layout.fillWidth: true
            //anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("Experience")
                font.bold: true
            }

            RowLayout {
                //Layout.margins: 4
                ToolButton {
                    id: txExp
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    //topPadding: 12
                    text: charExperience
                    font.pointSize: 14

                    contentItem: Label {
                        text: txExp.text
                        font: txExp.font

                        color: charExperience > charModel.exp ? "#f00" : "#000"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    ToolTip {
                        parent: txExp
                        visible: txExp.down
                        width: 180
                        height: 80
                        contentItem: ExpDetails { id: expDtl; charModel: root.charModel }
                    }
                    onDownChanged: {
                        expDtl.charModel = root.charModel
                    }
                }

                Item { Layout.fillWidth: true }

                SpinBox {
                    from: 0
                    to: 1000
                    stepSize: 1
                    value: charModel.exp
                    onValueChanged: {
                        charModel.exp = value
                        charModelChanged()
                    }
                }
            }
        }

        Rectangle {
            height: 1
            Layout.minimumHeight: 1
            Layout.fillWidth: true
            color: "#3F51B5"
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
                rating: root.charModel ? root.charModel.speed : 0
                onValueChanged: {
                    root.charModel.speed = rating
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
                rating: root.charModel ? root.charModel.attack : 0
                onValueChanged: {
                    root.charModel.attack = rating
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
                rating: root.charModel ? root.charModel.defence : 0
                onValueChanged: {
                    root.charModel.defence = rating
                    save()
                }
            }
        }

        /*
        Rectangle {
            height: 1
            Layout.minimumHeight: 1
            Layout.fillWidth: true
            color: "#3F51B5"
        }*/

        // EQUILIBRIO
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Balance")
                font.bold: true
            }

            RoundPicker6 {
                id: vaBalance
                rating: root.charModel ? root.charModel.balance : 0
                onValueChanged: {
                    root.charModel.balance = rating
                    save()
                }
            }
        }

        // VOLONTA'
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Willpower")
                font.bold: true
            }

            RoundPicker6 {
                id: vaWillPower
                rating: root.charModel ? root.charModel.willpower : 0
                onValueChanged: {
                    root.charModel.willpower = rating
                    save()
                }
            }
        }
    }
}
