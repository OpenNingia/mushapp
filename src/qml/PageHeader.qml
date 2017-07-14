import QtQuick 2.7
import QtQuick.Controls 2.1
import "fa"

ToolBar {
    id: root

    property string title: ""
    signal backClicked

    ToolButton {

        contentItem: TextIcon {
            icon: icons.fa_home
            pointSize: 14
            color: "#fff"
        }

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        onClicked: root.backClicked()
    }

    Label {
        text: title
        font.pixelSize: 20
        anchors.centerIn: parent
    }
}
