import QtQuick 2.7

Item {
    id: container
    property int rating: 0
    signal valueChanged

    height: 24
    width: 24*10

    Row {
        ValuePicker {
            rating: 1
            onClicked: {
                container.rating = container.rating == 1 ? 0 : rating
                container.valueChanged()
            }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 2
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 3
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 4
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 5
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 6
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 7
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 8
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 9
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
        ValuePicker {
            rating: 10
            onClicked: { container.rating = rating; container.valueChanged() }
            on: container.rating >= rating
        }
    }
}
