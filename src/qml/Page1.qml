import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Qt.labs.platform 1.0
import "fa"

Page {
    id: root
    enabled: stackView.busy === false

    property alias characterList: characterList

    property var initialize: function() {
        if ( dataModel )
            dataModel.character = ""
    }

    header: ToolBar {
        Label {
            text: qsTr("Characters")
            font.pixelSize: 20
            anchors.centerIn: parent
        }
    }

    ListView {
        id: characterList

        anchors.fill: parent

        topMargin: 12
        leftMargin: 12
        bottomMargin: 12
        rightMargin: 12
        spacing: 12

        ScrollIndicator.vertical: ScrollIndicator { }

        model: dataModel
        delegate:  ItemDelegate {
            height: txCharName.implicitHeight + txCharTitle.implicitHeight + 30
            width: characterList.width - characterList.leftMargin - characterList.rightMargin

            leftPadding: 12
            rightPadding: 12

            onClicked: {
                characterList.currentIndex = index
                //root.StackView.view.push("qrc:/CharacterInfoPage.qml", { activeCharacterName: model.name })
                root.StackView.view.push("qrc:/CharacterMainPage.qml", { activeCharacterName: model.name })
            }

            RowLayout {
                anchors.fill: parent

                Item {
                    id: charModel
                    function parseContent(c) {
                        try {
                            return JSON.parse(c)
                        } catch(error) { return {} }
                    }

                    property var charContent: parseContent(content)
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Text { id: txCharName; text: name; font.bold: true }
                    Text { id: txCharTitle; text: charModel.charContent.title; color: "#888" }
                }

                DelayButton {
                    delay: 1200
                    Layout.alignment: Qt.AlignRight
                    contentItem: TextIcon {
                        icon: icons.fa_trash_o
                        pointSize: 20
                    }
                    onActivated: {
                        dataModel.delCharacter(name)
                    }
                }
            }
        }

        focus: true
        interactive: true
    }

    RoundButton {
        id: fab

        contentItem: TextIcon {
            icon: icons.fa_plus
            color: "#fff"
            pointSize: 18

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        width: 80; height: 80

        highlighted: true
        Material.accent: Material.Red

        anchors.bottom: characterList.bottom
        anchors.right: characterList.right
        anchors.margins: 12

        onClicked: root.StackView.view.push("qrc:/CharacterCreationPage.qml")
    }

    RoundButton {
        id: btExport

        contentItem: TextIcon {
            icon: icons.fa_download
            pointSize: 14

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        width: 40; height: 40

        highlighted: false
        //Material.accent: Material.Red

        ToolTip.text: qsTr("Export")
        ToolTip.visible: down

        anchors.right: fab.left
        anchors.bottom: fab.bottom
        //anchors.right: characterList.right
        anchors.margins: 12

        MessageDialog {
            id: resultDlg
            buttons: MessageDialog.Ok
            //text: "The document has been modified."
        }

        onClicked: {
            var success = dataModel.exportAll();

            if ( Qt.platform.os == "android" ) {
                if ( success ) {
                    resultDlg.text = qsTr("Exported with success");
                } else {
                    resultDlg.text = qsTr("Export failed");
                }
                resultDlg.open();
            }
        }
    }

    RoundButton {
        id: btImport

        contentItem: TextIcon {
            icon: icons.fa_upload
            pointSize: 14

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        width: 40; height: 40

        highlighted: false
        //Material.accent: Material.Red

        ToolTip.text: qsTr("Import")
        ToolTip.visible: down

        anchors.right: btExport.left
        anchors.bottom: fab.bottom
        //anchors.right: characterList.right
        anchors.margins: 12

        onClicked: {
            var success = dataModel.importAll();

            if ( Qt.platform.os == "android" ) {
                if ( success ) {
                    resultDlg.text = qsTr("Imported with success");
                } else {
                    resultDlg.text = qsTr("Import failed");
                }
                resultDlg.open();
            }
        }
    }
}
