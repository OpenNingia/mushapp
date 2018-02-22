import QtQuick 2.6
import QtQuick.Controls 2.2
import ".."
import "../fa"

SwipeDelegate  {
    id: delegate
    signal itemRemoved

    property bool removing: false
    property bool removed: false
    property alias timeout: undoTimer.interval

    swipe.left: Rectangle {
        width: parent.width
        height: parent.height

        clip: true
        color: SwipeDelegate.pressed ? "#555" : "#666"

        TextIcon {
            icon: icons.fa_trash_o

            //text: delegate.swipe.complete ? "\ue805" : "\ue801" // icon-cancel-circled-1

            font.pointSize: 22

            padding: 20
            anchors.fill: parent
            horizontalAlignment: Qt.AlignRight
            verticalAlignment: Qt.AlignVCenter

            opacity: 2 * -delegate.swipe.position

            color: delegate.swipe.complete ? Style.primaryFgColor : "#848484"
            Behavior on color { ColorAnimation { } }
        }

        Label {
            text: qsTr("Removed, click to undo")
            color: "white"

            font.family: Style.uiBoldFont.name
            font.pointSize: 18
            font.bold: true

            padding: 20
            anchors.fill: parent
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter

            opacity: delegate.swipe.complete ? 1 : 0
            Behavior on opacity { NumberAnimation { } }
        }

        SwipeDelegate.onClicked: delegate.swipe.close()
        SwipeDelegate.onPressedChanged: undoTimer.stop()
    }

    Timer {
        id: undoTimer
        interval: 1800
        onTriggered: {
            delegate.removed = true
            delegate.itemRemoved()
        }
    }

    swipe.onCompleted: {
        delegate.removing = true
        delegate.removed = false
    }

    swipe.onOpened: {

        undoTimer.start()
    }

    swipe.onClosed: {
        delegate.removing = delegate.removed = false
    }

    /*swipe.onPositionChanged: {
        console.log('pos: ', delegate.position)
        delegate.removing = true
    }*/
}
