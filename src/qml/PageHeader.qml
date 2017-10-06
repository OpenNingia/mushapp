import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "fa"
import "fa/fontawesome.js" as FA

ToolBar {
    id: pageHeader

    property string title: ""
    property string subTitle: ""
    property string backIcon: FA.Icons.fa_home

    property bool showPdf: false
    property bool showGame: false

    property var resetCallback: null

    signal backClicked
    signal pdfClicked    

    background: Rectangle { color: "black" }
    height: 64

    RowLayout {
        spacing: 2
        anchors.fill: parent

        ToolButton {
            contentItem: TextIcon {
                icon: backIcon
                pointSize: 18
                color: "#fff"
            }

            Layout.leftMargin: 8
            onClicked: pageHeader.backClicked()
        }

        Column {
            id: charName
            Layout.fillWidth: true

            Label {
                text: title
                font.pixelSize: 18
                font.bold: true
                elide: Label.ElideRight
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Label.Center
                color: "#fff"
                //Layout.preferredWidth: 120
            }

            Label {
                text: subTitle
                font.pixelSize: 12
                font.bold: true
                elide: Label.ElideRight
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Label.Center
                color: "#fff"
                //Layout.preferredWidth: 120
            }
        }

        ToolButton {
            contentItem: TextIcon {
                icon: icons.fa_refresh
                pointSize: 18
                color: "#fff"
            }

            onClicked: resetCallback()
            visible: resetCallback
        }

        ToolButton {
            contentItem: TextIcon {
                icon: icons.fa_file_pdf_o
                pointSize: 18
                color: "#fff"
            }

            onClicked: pageHeader.pdfClicked()
            visible: showPdf
        }
    }
}
