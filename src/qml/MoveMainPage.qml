import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "."

MushaDynPage {
    id: root

    property var initialize: function() {
        pgSpecial.initialize()
        pgSuper.initialize()
    }

    property var finalize: function() {
        pgSpecial.finalize()
        pgSuper.finalize()
    }


    header: TabBar {
        id: tabBar

        width: parent.width
        currentIndex: stackLayout.currentIndex

        Repeater {
            model: [ qsTr('Special Moves'), qsTr('Super Moves') ]

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
                    color: isActive ? "#CEE2A3" : "#868583"
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

        CharacterMovesPage {
            id: pgSpecial
            charModel: root.charModel
            superMoves: false
        }
        CharacterMovesPage {
            id: pgSuper
            charModel: root.charModel
            superMoves: true
        }
    }

}
