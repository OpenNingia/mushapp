import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import ".."

Pane {
    id: panel

    property alias text: label.text
    property alias value: spinbox.value
    property alias from: spinbox.from
    property alias to: spinbox.to
    property alias stepSize: spinbox.stepSize

    signal valueModified

    background: Rectangle { color: Style.primaryBgColor }

    Label {
        id: label
        font.family: Style.uiBoldFont.name
        font.bold: true
        font.pointSize: 12
        color: "#fff"

        width: parent.width / 2
        height: parent.height

        verticalAlignment: Label.AlignVCenter
    }

    SpinBox {
        id: spinbox
        editable: false

        anchors.left: label.right
        //anchors.margins: 12

        width: parent.width / 2
        height: parent.height

        font.family: Style.uiBoldFont.name
        font.pointSize: 14
        font.bold: true

        contentItem: TextInput {
            z: 2
            text: spinbox.textFromValue(spinbox.value, spinbox.locale)

            font: spinbox.font

            color: Style.primaryFgColor
            selectionColor: Style.primaryFgColor
            selectedTextColor: "#ffffff"
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter

            readOnly: !spinbox.editable
            validator: spinbox.validator
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        up.indicator: Rectangle {
            x: spinbox.mirrored ? 0 : parent.width - width
            height: parent.height
            implicitWidth: 32
            implicitHeight: 32
            color: Style.primaryBgColor

            Text {
                text: "+"
                font: spinbox.font

                color: Style.primaryFgColor
                anchors.fill: parent
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        down.indicator: Rectangle {
            x: spinbox.mirrored ? parent.width - width : 0
            height: parent.height
            implicitWidth: 32
            implicitHeight: 32
            color: Style.primaryBgColor

            Text {
                text: "-"
                font: spinbox.font

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

        onValueModified: valueModified()
    }

}
