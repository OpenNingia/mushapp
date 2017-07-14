import QtQuick 2.7
import "fa/fontawesome.js" as FA

Item {
    id: container
    property int rating: 0
    signal valueChanged

    height: 24
    width: 24*5

    Row {
        Repeater {
            model: 5
            ValuePicker {
                icon: FA.Icons.fa_square
                rating: modelData+1
                onClicked: {
                    container.rating = container.rating == rating ? rating-1 : rating
                    container.valueChanged()
                }
                on: container.rating >= rating
            }
        }
    }
}
