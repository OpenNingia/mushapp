import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 540
    height: 960
    title: qsTr("Musha Shugyo")

    StackView {
        id: stackView

        property Item __oldItem: null

        anchors.fill: parent
        initialItem: Page1 { }

        onCurrentItemChanged: {

            console.log('stackView, onCurrentItemChanged start')

            if (__oldItem && __oldItem.finalize) {
                console.log('stackView, calling old item finalize')
                __oldItem.finalize()
            }

            if (currentItem && currentItem.initialize) {
                console.log('stackView, calling new item initialize')
                currentItem.initialize()
            }

            __oldItem = currentItem
            console.log('stackView, onCurrentItemChanged end')
        }

    }
}
