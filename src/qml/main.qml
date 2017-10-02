import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
// import QtQuick.Controls.Material 2.1

ApplicationWindow {
    visible: true
    width: 300
    height: 520
    title: qsTr("Musha Shugyo")

    //Material.theme: Material.Light
    //Material.accent: Material.Purple

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
