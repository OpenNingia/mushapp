import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "fa"

Page {
    id: root
    enabled: stackView.busy === false

    property string activeCharacterName
    property var characterModel

    property var initialize: function() {
        if ( dataModel ) {
            dataModel.character = activeCharacterName
            characterModel = JSON.parse(dataModel.characterData)
            pgInfo.initialize()

            //console.log(dataModel.characterData)
        }
    }

    property var finalize: function() {
        // finalize on exit
        if (swipeView.currentItem && swipeView.currentItem.finalize)
            swipeView.currentItem.finalize()

        //dataModel.characterData = JSON.stringify(characterModel)
    }


    header: PageHeader {
        id: pageTitle
        title: activeCharacterName
        onBackClicked: root.StackView.view.pop()
        onPdfClicked: {
            root.StackView.view.push("qrc:/CanvasCharacterSheet.qml", { charModel: characterModel })
        }
    }

    SwipeView {
        id: swipeView

        property Item __oldItem: null

        anchors.fill: parent
        //currentIndex: indicator.currentIndex

        CharacterInfoPage {
            id: pgInfo
            charModel: characterModel
        }

        CharacterMovesPage {
            id: pgSpecial
            charModel: characterModel
            superMoves: false
        }
        CharacterMovesPage {
            id: pgSuper
            charModel: characterModel
            superMoves: true
        }

        CharacterAuraPage {
            id: pgAura
            charModel: characterModel
        }

        CharacterArmorPage {
            id: pgArmor
            charModel: characterModel
            itemModel: characterModel.armor
            isWeapon: false
        }

        CharacterArmorPage {
            id: pgWeapon
            charModel: characterModel
            itemModel: characterModel.weapon
            isWeapon: true
        }


        onCurrentItemChanged: {
            if (__oldItem && __oldItem.finalize) {
                __oldItem.finalize()
            }

            if (currentItem && currentItem.initialize) {
                currentItem.initialize()
            }

            __oldItem = currentItem

            if ( currentItem.getTitle )
                pageTitle.title = currentItem.getTitle()
        }
    }

    footer: RowLayout {
            Item { Layout.fillWidth: true }
            PageIndicator {
            id: control
            count: swipeView.count
            currentIndex: swipeView.currentIndex

            delegate: Rectangle {
                implicitWidth: 8
                implicitHeight: 8

                radius: width / 2
                color: "#E91E63"

                opacity: index === control.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 100
                    }
                }
            }
        }
        Item { Layout.fillWidth: true }
    }
}
