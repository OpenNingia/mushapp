import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "."

MushaDynPage {
    id: root

    property var initialize: function() {
        pgArmor.initialize()
        pgWeapon.initialize()
    }

    property var finalize: function() {
        save()
    }

    property var save: function() {
        if ( charModel ) {
            console.log('HyperMainPage: saving...')
            dataModel.characterData = JSON.stringify(charModel)
        }
    }

    header: TabBar {
        id: tabBar

        width: parent.width
        currentIndex: stackLayout.currentIndex

        Repeater {
            model: [ qsTr('Hyper Armor'), qsTr('Hyper Weapon') ]

            TabButton {
                id: tabButton
                property bool isActive: tabBar.currentItem === this

                font.pointSize: 12
                font.family: Style.uiBoldFont.name
                font.bold: true

                text: modelData
                background: Rectangle { color: Style.primaryBgColor }
                contentItem: Label {
                    text: tabButton.text
                    font: tabButton.font
                    color: isActive ? Style.primaryFgColor : "#848484"
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                }

                height: tabBar.height
            }
        }
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        CharacterArmorPage {
            id: pgArmor
            charModel: root.charModel
            itemModel: root.charModel ? root.charModel.armor : null
            isWeapon: false
        }

        CharacterArmorPage {
            id: pgWeapon
            charModel: root.charModel
            itemModel: root.charModel ? root.charModel.weapon : null
            isWeapon: true
        }
    }
}
