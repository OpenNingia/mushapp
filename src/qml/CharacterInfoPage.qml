import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "."
import "components"
import "business/dal.js" as Dal

MushaDynPage {
    id: root
    spacing: 0

    signal spEngineChanged

    property var initialize: function() {
        console.log("InfoPage initialize")

        cbSpEngine.currentIndex = -1;

        if ( charModel ) {
            if ( !charModel.spEngine )
                charModel.spEngine = "sp_danni"

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
        Dal.saveCharacter(charModel);
    }

    // SP ENGINES
    ListModel {
        id: spModel
        ListElement {
            name: qsTr("Combo")
            tag: "sp_combo"
            portrait: "qrc:/img/sp_combo.png"
            portrait_inactive: "qrc:/img/sp_combo_inactive.png"
        }
        ListElement {
            name: qsTr("Danni")
            tag: "sp_danni"
            portrait: "qrc:/img/sp_danni.png"
            portrait_inactive: "qrc:/img/sp_danni_inactive.png"
        }
        ListElement {
            name: qsTr("Difesa")
            tag: "sp_difesa"
            portrait: "qrc:/img/sp_difesa.png"
            portrait_inactive: "qrc:/img/sp_difesa_inactive.png"
        }
        ListElement {
            name: qsTr("Ferite")
            tag: "sp_ferite"
            portrait: "qrc:/img/sp_ferite.png"
            portrait_inactive: "qrc:/img/sp_ferite_inactive.png"
        }
        ListElement {
            name: qsTr("PA")
            tag: "sp_pa"
            portrait: "qrc:/img/sp_pa.png"
            portrait_inactive: "qrc:/img/sp_pa_inactive.png"
        }
    }

    // TITOLO O DESCRIZIONE
    ColumnLayout {

        anchors.fill: parent

        MyComboBox {
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            id: cbSpEngine
            model: spModel
            textRole: "name"

            spacing: 12

            onActivated: {
                root.charModel.spEngine = model.get(index).tag
                //root.charModelChanged()
                root.spEngineChanged()
            }

            contentItem: ItemDelegate {
                id: item
                height: cbSpEngine.height
                width: cbSpEngine.width

                Row {
                    spacing: 6
                    Label {
                        text: qsTr("SP")
                        font.family: Style.uiBoldFont.name
                        font.bold: true
                        font.pointSize: 12
                        color: "#fff"

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12

                        height: item.height
                        width: item.width / 3
                    }

                    Label {
                        text: cbSpEngine.displayText
                        font: cbSpEngine.font
                        color: Style.primaryFgColor

                        height: item.height
                        width: item.width / 2

                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            delegate: ItemDelegate {

                width: cbSpEngine.width
                background: Rectangle { color: Qt.lighter(Style.primaryBgColor) }

                contentItem: Row {
                    spacing: 12
                    anchors.right: parent.right
                    leftPadding: cbSpEngine.width - img.implicitWidth - txt.width - cbSpEngine.padding*4

                    Text {
                        id: txt
                        height: 22
                        width: 100
                        text: name
                        font: cbSpEngine.font
                        color: Style.primaryFgColor
                        verticalAlignment: Text.AlignVCenter
                    }

                    Image {
                        id: img
                        source: cbSpEngine.currentIndex === index ? portrait : portrait_inactive
                        fillMode: Image.PreserveAspectFit
                        height: 32
                        width: 32
                    }

                }

                highlighted: cbSpEngine.highlightedIndex === index
            }
        }


        Item { Layout.preferredHeight: 8 }

        // STATS
        Repeater {

            model: [
                { text: qsTr("Speed"), tag: 'speed' },
                { text: qsTr("Attack"), tag: 'attack' },
                { text: qsTr("Defence"), tag: 'defence' },
                { text: qsTr("Willpower"), tag: 'willpower' },
                { text: qsTr("Balance"), tag: 'balance' },
            ]

            Pane {

                visible: !cbSpEngine.popup.visible

                Layout.fillWidth: true
                Layout.preferredHeight: 48
                background: Rectangle { color: Style.primaryBgColor }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 24

                    Label {
                        Layout.preferredWidth: 60
                        text: modelData.text
                        font.family: Style.uiBoldFont.name
                        font.bold: true
                        font.pointSize: 12
                        color: "#fff"
                        Layout.leftMargin: 12
                    }

                    RoundPicker6 {
                        rating: root.charModel ? root.charModel[modelData.tag] : 0
                        onValueChanged: {
                            root.charModel[modelData.tag] = rating
                            save()
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }

        Pane {
            id: plExp

            Layout.fillWidth: true
            Layout.preferredHeight: 48
            Layout.bottomMargin: 2
            background: Rectangle { color: Style.primaryBgColor }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Label {
                    text: qsTr("Experience")
                    font.family: Style.uiBoldFont.name
                    font.bold: true
                    font.pointSize: 12
                    color: "#fff"
                    Layout.leftMargin: 12
                }

                SpinBox {
                    id: sbExp
                    editable: false

                    font.family: Style.uiBoldFont.name
                    font.pointSize: 14
                    font.bold: true

                    contentItem: TextInput {
                        z: 2
                        text: sbExp.textFromValue(sbExp.value, sbExp.locale)

                        font: sbExp.font

                        color: Style.primaryFgColor
                        selectionColor: Style.primaryFgColor
                        selectedTextColor: "#ffffff"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter

                        readOnly: !sbExp.editable
                        validator: sbExp.validator
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                    }

                    up.indicator: Rectangle {
                        x: sbExp.mirrored ? 0 : parent.width - width
                        height: parent.height
                        implicitWidth: 32
                        implicitHeight: 32
                        color: Style.primaryBgColor

                        Text {
                            text: "+"
                            font: sbExp.font

                            color: Style.primaryFgColor
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    down.indicator: Rectangle {
                        x: sbExp.mirrored ? parent.width - width : 0
                        height: parent.height
                        implicitWidth: 32
                        implicitHeight: 32
                        color: Style.primaryBgColor

                        Text {
                            text: "-"
                            font: sbExp.font

                            color: Style.primaryFgColor
                            anchors.fill: parent
                            fontSizeMode: Text.Fit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        implicitWidth: 120
                        color: Style.primaryBgColor
                    }

                    value: charModel && charModel.exp ? charModel.exp : 0
                    onValueModified: {
                        charModel.exp = value
                        charModelChanged()
                    }
                }
            }
        }
    }
}
