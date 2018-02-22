import QtQuick 2.7
import "fa"
import "fa/fontawesome.js" as FA

Item {
    id: container
    width: 24
    height: 24

    property alias pointSize: icon.pointSize
    property alias color: icon.color
    property string icon: FA.Icons.fa_circle
    property int value
    property bool flagged

    signal clicked
    signal entered
    signal exited

    TextIcon {
        id: icon
        icon: container.icon
        color: "#000"
        x: 6
        y: 7
    }

    MouseArea {
        anchors.fill: container
        onClicked: { container.clicked() }
    }

    states: [
        State {
            name: "flagged"
            when: container.flagged === true
            PropertyChanges {
                target: icon
                color: "#f00"
            }
        }
    ]
    transitions: [
        Transition {
            ColorAnimation {
                properties: "color"
                //from: "#000"
                //to: "#f00"
                duration: 200
            }
        }
    ]
}
