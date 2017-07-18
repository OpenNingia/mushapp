import QtQuick 2.7

GridView {
    id: container
    property var symbols
    property int preferredHeight: 24

    //orientation: ListView.Horizontal

    cellHeight: 22
    cellWidth: 22

    //height: parent.height

    model: symbols
    delegate: Image {
        source: "qrc:/img/%1.png".arg(modelData)
        height: 22
        width: 22
    }

    //Component.onCompleted: {
    //    preferredHeight = calcPreferredHeight()
    //}

    onWidthChanged: {
        preferredHeight = calcPreferredHeight()
    }

    function calcPreferredHeight() {
        var symbols_per_row = container.width/24
        var rows = Math.ceil(symbols.length/symbols_per_row)
        return  24 * rows
    }
}
