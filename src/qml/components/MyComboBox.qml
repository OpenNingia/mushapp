import QtQuick 2.6
import QtQuick.Controls 2.2
import "../fa"
import ".."

ComboBox {

    id: control

    font.family: Style.uiFont.name
    font.pointSize: 12

    background: Rectangle { color: Style.primaryBgColor }
    padding: 12

    indicator: TextIcon {
        icon: icons.fa_angle_down
        pointSize: 12
        color: Style.primaryFgColor

        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: control.topPadding + (control.availableHeight - height) / 2
        opacity: enabled ? 1 : 0.3
    }

    contentItem: Text {
        leftPadding: !control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        rightPadding: control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        topPadding: 6 - control.padding
        bottomPadding: 6 - control.padding

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable

        font: control.font
        color: Style.primaryFgColor

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        opacity: control.enabled ? 1 : 0.3
    }
}
