import QtQuick 2.7
import QtQuick.Controls 2.1
import "fa"
import "fa/fontawesome.js" as FA

ToolBar {
    id: pageHeader

    property string title: ""
    property string backIcon: FA.Icons.fa_home

    property bool showPdf: true

    signal backClicked
    signal pdfClicked

    ToolButton {
        contentItem: TextIcon {
            icon: backIcon
            pointSize: 14
            color: "#fff"
        }

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        onClicked: pageHeader.backClicked()
    }

    Label {
        text: title
        font.pixelSize: 20
        anchors.centerIn: parent
    }


    ToolButton {
        contentItem: TextIcon {
            icon: icons.fa_file_pdf_o
            pointSize: 14
            color: "#fff"
        }

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        onClicked: pageHeader.pdfClicked()

        visible: showPdf
    }
}
