import QtQuick 2.6
import QtQuick.Controls 2.2
import ".."

Switch {
    id: control
    //text: qsTr("Switch")

    font.bold: false
    font.pointSize: 12
    font.family: Style.uiFont.name

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: control.checked ? Style.primaryFgColor : "#ffffff"
        border.color: control.checked ? Qt.darker(Style.primaryFgColor) : "#cccccc"

        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: 26
            height: 26
            radius: 13
            color: control.down ? "#cccccc" : "#ffffff"
            border.color: control.checked ? (control.down ? Qt.darker(Style.primaryFgColor) : Style.primaryFgColor) : "#999999"
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? Qt.darker(Style.primaryFgColor) : Style.primaryFgColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
