import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
//import QtGraphicalEffects 1.0

Page {
    id: root

    property var charModel: null
    background: Rectangle { color: "#00000000" }

    //layer.enabled: true
/*
    background: Rectangle {
        id: rect
        color: "#B7D5DD"

        Image {
            id: image
            source: charModel && charModel.spEngine ? "qrc:/img/bg/" + charModel.spEngine + ".png" : ""
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignBottom
            fillMode: Image.PreserveAspectFit
            anchors.bottom: rect.bottom
            width: rect.width
            //height: 100
        }

        DropShadow {
            anchors.fill: image
            horizontalOffset: 40
            verticalOffset: 20
            radius: 4.0
            samples: 11
            color: "#802A3E47"
            source: image
        }
    }*/
}
