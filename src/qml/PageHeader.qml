import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "fa"
import "fa/fontawesome.js" as FA

ToolBar {
    id: pageHeader

    property string title: ""
    property string backIcon: FA.Icons.fa_home

    property bool showPdf: false
    property bool showGame: false

    signal backClicked
    signal pdfClicked
    signal gameClicked

    RowLayout {
        spacing: 2
        anchors.fill: parent

        ToolButton {
            contentItem: TextIcon {
                icon: backIcon
                pointSize: 14
                color: "#fff"
            }

            Layout.leftMargin: 8

            //anchors.left: parent.left
            //anchors.leftMargin: 10
            //anchors.verticalCenter: parent.verticalCenter
            onClicked: pageHeader.backClicked()
        }

        Label {
            text: title
            font.pixelSize: 18
            elide: Label.ElideRight
            //anchors.centerIn: parent

            horizontalAlignment: Label.Center
            Layout.fillWidth: true
            //Layout.preferredWidth: 120
        }

        ToolButton {
            contentItem: TextIcon {
                icon: icons.fa_gamepad
                pointSize: 14
                color: "#fff"
            }

            onClicked: pageHeader.gameClicked()
            visible: showGame
        }

        ToolButton {
            contentItem: TextIcon {
                icon: icons.fa_file_pdf_o
                pointSize: 14
                color: "#fff"
            }

            onClicked: pageHeader.pdfClicked()
            visible: showPdf
        }
    }
}
