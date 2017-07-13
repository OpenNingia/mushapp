import QtQuick 2.7
import "fa"
import "fa/fontawesome.js" as FA

Item {
    id: container
    width: 24
    height: 24

    property string icon: FA.Icons.fa_circle
    property int rating
    property bool on
    signal clicked
    signal entered
    signal exited

    TextIcon {
        id: starImage
        icon: container.icon
        x: 6
        y: 7
        opacity: 0.4
        scale: 0.5
    }

    MouseArea {
        anchors.fill: container
        onClicked: { container.clicked() }
    }

    states: [
        State {
            name: "on"
            when: container.on == true
            PropertyChanges {
                target: starImage
                opacity: 1
                scale: 1
                //x: 1
                //y: 0
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {
                properties: "opacity,scale,x,y"
                easing.type: Easing.Bezier
                duration: 50
            }
        }
    ]
}
