import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Page {
    id: root

    property var charModel: null

    //layer.enabled: true

    background: Rectangle {
        id: rect
        color: "#B7D5DD"

        Image {
            source: charModel && charModel.spEngine ? "qrc:/img/bg/" + charModel.spEngine + ".png" : ""
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignBottom
            fillMode: Image.PreserveAspectFit
            anchors.bottom: rect.bottom
            width: rect.width
            //height: 100
        }
    }
}
