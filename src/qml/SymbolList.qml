import QtQuick 2.7

ListView {
    id: container
    property var symbols

    orientation: ListView.Horizontal
    model: symbols
    delegate: Image {
        source: "qrc:/img/%1.png".arg(modelData)
        height: 22
        width: 22
    }
}
