import QtQuick 2.7

GridView {
    id: container

    signal itemClicked(string symbolId)

    property var symbols
    property int preferredHeight: 24

    cellHeight: 22
    cellWidth: 22

    model: symbols
    delegate: Image {
        id: img
        source: "qrc:/img/%1.png".arg(modelData)
        height: 22
        width: 22

        MouseArea {
            anchors.fill: img
            onClicked: {
                itemClicked(modelData)
            }
        }
    }

    onWidthChanged: {
        preferredHeight = calcPreferredHeight()
    }

    function calcPreferredHeight() {
        var symbols_per_row = container.width/24
        var rows = symbols ? Math.ceil(symbols.length/symbols_per_row) : 1
        return  24 * rows
    }
}
