import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import Qt.labs.platform 1.0
import "."
import "fa"
import "components"

MushaDynPage {
    id: root
    enabled: stackView.busy === false

    property alias characterList: characterList

    property var initialize: function() {
        if ( dataModel )
            dataModel.character = ""
    }

    header: ToolBar {
        background: Rectangle { color: "#000"; implicitHeight: 64 }
        Label {
            text: qsTr("Characters")
            font.family: Style.uiBoldFont.name
            font.pixelSize: 20
            font.bold: true
            color: "#fff"
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

            background: Rectangle {
                color: Style.primaryBgColor
            }

            onClicked: {
                console.log('user clicked on %1'.arg(model.name))
                characterList.currentIndex = index
                root.StackView.view.push("qrc:/CharacterMainPage.qml", { activeCharacterName: model.name })
            }

            RowLayout {
                anchors.fill: parent

                Item {
                    id: itmCharModel
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

                    Text {
                        id: txCharName;
                        text: name;
                        font.family: Style.uiBoldFont.name
                        font.pointSize: 12
                        font.bold: true;
                        color: Style.primaryFgColor
                    }
                    Text {
                        id: txCharTitle;
                        text: itmCharModel.charContent.title;
                        font.family: Style.uiFont.name
                        font.pointSize: 10
                        color: "#fff"
                    }
                }

                Row {
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 6

                    ToolButton {
                        anchors.verticalCenter: btDelete.verticalCenter
                        //background: Rectangle { color: "white"}
                        contentItem: TextIcon {
                            icon: icons.fa_edit
                            color: Style.primaryFgColor
                            font.pointSize: 12
                        }

                        onClicked: {
                            root.StackView.view.push("qrc:/CharacterCreationPage.qml", { charModel: itmCharModel.charContent, rename: true })
                        }
                    }

                    MyDelayDeleteButton {
                        id: btDelete
                        onActivated: {
                            dataModel.delCharacter(name)
                        }
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
        //Material.accent: Material.Red

        anchors.bottom: characterList.bottom
        anchors.right: characterList.right
        anchors.margins: 12

        onClicked: root.StackView.view.push("qrc:/CharacterCreationPage.qml")
    }

    MessageDialog {
        id: resultDlg
        buttons: MessageDialog.Ok
        //text: "The document has been modified."
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

    RoundButton {
        id: btSyncGdrive

        contentItem: TextIcon {
            icon: icons.fa_cloud_upload
            pointSize: 14

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        width: 40; height: 40

        highlighted: false

        ToolTip.text: qsTr("Sync with Google Drive")
        ToolTip.visible: down

        anchors.right: btImport.left
        anchors.bottom: fab.bottom
        anchors.margins: 12

        onClicked: {
            var success = gdrive.syncAll();

            if ( Qt.platform.os == "android" ) {
                if ( success ) {
                    resultDlg.text = qsTr("Syncronized with success");
                } else {
                    resultDlg.text = qsTr("Syncronization failed");
                }
                resultDlg.open();
            }
        }
    }
}
