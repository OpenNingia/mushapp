import QtQuick 2.7
import "fa/fontawesome.js" as FA

Item {
    id: container
    property int size: 0
    property int value: 0
    property string color: "#fff"
    property int pointSize: 12

    height: 24
    width: 24*container.size

    Row {
        Repeater {
            id: block
            model: container.size
            FlaggableValue {

                pointSize: container.pointSize
                color: container.color
                icon: FA.Icons.fa_square
                value: modelData+1
                onClicked: {
                    container.value = container.value === value ? value-1 : value
                }
                flagged: container.value >= value
            }
        }
    }
}
