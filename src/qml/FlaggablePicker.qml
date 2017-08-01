import QtQuick 2.7
import "fa/fontawesome.js" as FA

Item {
    id: container
    property int size: 0
    property int value: 0

    height: 24
    width: 24*container.size

    /*onValueChanged: {
        console.log('FlaggablePicker, valueChanged: ' + value)
        block.model = 0
        block.model = container.size
    }*/

    Row {
        Repeater {
            id: block
            model: container.size
            FlaggableValue {
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
