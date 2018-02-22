import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import SortFilterProxyModel 0.2
import Qt.labs.platform 1.0
import "."
import "fa"
import "components"

MushaDynPage {
    id: root
    enabled: stackView.busy === false

    property string activeGroupFilter: ""
    property var characterListModel: []
    //property alias characterList: characterList

    property var initialize: function() {
        if ( dataModel ) {
            dataModel.character = ""
        }
    }

    header: ToolBar {
        background: Rectangle { color: "#000"; implicitHeight: 64 }

        Item {
            anchors.fill: parent

            ToolButton {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                contentItem: TextIcon {
                    icon: icons.fa_bars
                    pointSize: 18
                    color: "#fff"
                }

                onClicked: drawer.visible ? drawer.close() : drawer.open()
            }

            Label {
                text: qsTr("Characters")
                font.family: Style.uiBoldFont.name
                font.pixelSize: 20
                font.bold: true
                color: "#fff"
                anchors.centerIn: parent
            }
        }
    }

    Drawer {
        id: drawer
        y: header.height
        width: root.width * 0.6
        height: root.height - header.height
        //opacity: drawer.availableWidth / drawer.width
        //dragMargin: 20

        background: Rectangle {
            color: Style.primaryBgColor
        }

        ListView {
            id: groupList
            model: ["Tutti", "PC", "PNG", "Minions", "Boss", "Altri"]

            anchors.fill: parent
            anchors.margins: 12
            spacing: 6

            delegate: ItemDelegate {

                height: text.implicitHeight + 30
                width: groupList.width - groupList.leftMargin - groupList.rightMargin

                background: Rectangle {
                    color: Qt.lighter(Style.primaryBgColor)
                }

                Text {
                    id: text
                    text: modelData
                    color: Style.primaryFgColor
                    font.bold: false
                    font.family: Style.uiFont.name
                    font.pointSize: 16

                    anchors.centerIn: parent
                }

                onClicked: {
                    if ( index === 0 )
                        activeGroupFilter = ""
                    else
                        activeGroupFilter = modelData
                }
            }
        }
    }

    SortFilterProxyModel {
        id: characterListProxyModel
        sourceModel: dataModel
        filterRoleName: "group"
        filterPattern: activeGroupFilter

        onFilterPatternChanged: {
            console.log('filter pattern:', activeGroupFilter)
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

        //cacheBuffer: 100 * 80

        ScrollIndicator.vertical: ScrollIndicator { }

        model: characterListProxyModel
        delegate: ItemDelegate {
            id: delegate

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
                visible: !delegate.removing && !delegate.removed

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
                        id: txCharName
                        text: name
                        font.family: Style.uiBoldFont.name
                        font.pointSize: 12
                        font.bold: true
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
                    //visible: delegate.swipe.position >= 0.0

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

    MessageDialog {
        id: confirmDlg
        text: qsTr("This action will overwrite the cloud save.")
        informativeText: qsTr("Do you want to continue?")
        buttons: MessageDialog.Ok | MessageDialog.Cancel

        onAccepted: {
            var success = gdrive.syncAll(false);

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
            icon: icons.fa_cloud
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

    RoundButton {
        id: btSyncGdriveOverride

        contentItem: TextIcon {
            icon: icons.fa_cloud_upload
            color: "red"
            pointSize: 14

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        width: 40; height: 40

        highlighted: false

        ToolTip.text: qsTr("Push onto Google Drive")
        ToolTip.visible: down

        anchors.right: btSyncGdrive.left
        anchors.bottom: fab.bottom
        anchors.margins: 12

        onClicked: {

            if ( Qt.platform.os == "android" ) {
                confirmDlg.open()
            } else {
                gdrive.syncAll(false)
            }

        }
    }
}
