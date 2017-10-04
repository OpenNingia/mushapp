import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

MyDelayButton {
    delay: 800

    contentItem: Image {
        source: enabled ? 'qrc:/img/bin_active.png' : 'qrc:/img/bin.png'
        fillMode: Image.Pad
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }
}
