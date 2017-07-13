import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import org.openningia.mushapp 1.0
import "fa"

Page {
    id: root
    property alias characterList: characterList

    property var initialize: function() {
        if ( dataModel )
            dataModel.character = ""
        //
        //characterList.model = null;
        //characterList.model = dataModel;
        //
        //console.log('item count: ' + dataModel.rowCount())
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

        model: dataModel
        delegate:  ItemDelegate {
            height: 48
            width: characterList.width - characterList.leftMargin - characterList.rightMargin
            leftPadding: 32
            //highlighted: ListView.isCurrentItem
            onClicked: {
                characterList.currentIndex = index
                root.StackView.view.push("qrc:/CharacterInfoPage.qml", { activeCharacterName: model.name, activeCharacterIndex: index })
            }
            /*
            Column {

                Item {
                    id: charModel
                    function parseContent(c) {
                        try {
                            return JSON.parse(c)
                        } catch(error) { return {} }
                    }

                    property var charContent: parseContent(content)
                }

                Text { text: name; font.bold: true }
                Text {                    
                    text: charModel.charContent.title
                    color: "#888"
                }
            }*/

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

                    Text { text: name; font.bold: true }
                    Text { text: charModel.charContent.title; color: "#888" }
                }

                ToolButton {
                    Layout.alignment: Qt.AlignRight
                    contentItem: TextIcon {
                        icon: icons.fa_trash_o
                        pointSize: 20
                    }
                    onClicked: {
                        dataModel.delCharacter(name)
                        //reload()
                    }
                }
            }
        }

        /*highlight: Rectangle {
            color: "#3F51B5";
            radius: 2
        }*/
        focus: true
        interactive: true
    }

    RoundButton {

        contentItem: TextIcon {
            icon: icons.fa_plus
            color: "#fff"
            pointSize: 14

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        width: 64; height: 64

        highlighted: true
        Material.accent: Material.Red

        anchors.bottom: characterList.bottom
        anchors.right: characterList.right

        onClicked: root.StackView.view.push("qrc:/CharacterCreationPage.qml")
    }
}
