import QtQuick 2.6
import QtQuick.Controls 2.2
import ".."

DelayButton {
    id: control

    /*contentItem: Image {
        source: enabled ? 'qrc:/img/bin_active.png' : 'qrc:/img/bin.png'
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }*/

    background: Rectangle {
        implicitWidth: 50
        implicitHeight: 50
        opacity: 1.0
        //color: Qt.lighter("#3C6F82")
        //color: Qt.lighter(Style.primaryBgColor)
        color: Qt.rgba(0, 0, 0, 0)
        radius: size / 2

        readonly property real size: Math.min(control.width, control.height)
        width: size
        height: size
        anchors.centerIn: parent

        Canvas {
            id: canvas
            anchors.fill: parent

            Connections {
                target: control
                onProgressChanged: canvas.requestPaint()
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.strokeStyle = Style.primaryFgColor
                ctx.globalAlpha = 0.2+control.progress
                //ctx.lineWidth = parent.size / 10
                ctx.lineWidth = 10
                ctx.beginPath()
                var startAngle = Math.PI / 5 * 3
                var endAngle = startAngle + control.progress * Math.PI / 5 * 9
                ctx.arc(width / 2, height / 2, width / 2 - ctx.lineWidth / 2 - 2, startAngle, endAngle)
                ctx.stroke()
            }
        }
    }
}
