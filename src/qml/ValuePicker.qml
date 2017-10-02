import QtQuick 2.7
import "fa"
import "fa/fontawesome.js" as FA

Item {
    id: container
    width: 24
    height: 24

    property string icon: FA.Icons.fa_circle
    property string color: "#000"
    property int rating
    property bool on
    signal clicked
    signal entered
    signal exited

    /*TextIcon {
        id: starImage
        icon: container.icon
        color: container.color

        x: 6
        y: 7
        opacity: 0.4
        scale: 0.5
    }*/

    Image {
        id: starImage
        source: "qrc:/img/stat_off.png"
        height: 24
        width: 24
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
                source: "qrc:/img/stat_on.png"
            }
        }
    ]
    /*transitions: [
        Transition {
            NumberAnimation {
                properties: "opacity,scale,x,y"
                easing.type: Easing.Bezier
                duration: 50
            }
        }
    ]*/
}
