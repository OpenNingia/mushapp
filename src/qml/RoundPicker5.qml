import QtQuick 2.7
import "fa/fontawesome.js" as FA

Item {
    id: container
    property int rating: 0
    signal valueChanged

    height: 24
    width: 24*5

    Row {
        ValuePicker {
            icon: FA.Icons.fa_square
            rating: 1
            onClicked: {
                container.rating = container.rating == 1 ? 0 : rating
                container.valueChanged()
            }
            on: container.rating >= rating
        }
        ValuePicker {
            icon: FA.Icons.fa_square
            rating: 2
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            icon: FA.Icons.fa_square
            rating: 3
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            icon: FA.Icons.fa_square
            rating: 4
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            icon: FA.Icons.fa_square
            rating: 5
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
    }
}
