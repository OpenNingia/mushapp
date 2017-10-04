import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "."
import "fa"

MushaDynPage {
    id: root
    enabled: stackView.busy === false


    property string activeCharacterName

    property var initialize: function() {

        console.log('MainPage initialize')

        if ( dataModel ) {
            if ( dataModel.character != activeCharacterName )
                dataModel.character = activeCharacterName
            charModel = JSON.parse(dataModel.characterData)
            pgInfo.initialize()
        }
    }

    property var finalize: function() {
        // finalize on exit
        if (swipeView.currentItem && swipeView.currentItem.finalize)
            swipeView.currentItem.finalize()
        else if (swipeView.currentItem.item && swipeView.currentItem.item.finalize)
            swipeView.currentItem.item.finalize()

        //dataModel.characterData = JSON.stringify(characterModel)
    }

    header: PageHeader {
        id: pageTitle
        title: charModel ? charModel.name : ""
        subTitle: charModel ? charModel.title : ""
        showPdf: true
        onBackClicked: {
            swipeView.visible = false
            root.StackView.view.pop()
        }
        onPdfClicked: {
            root.StackView.view.push("qrc:/CanvasCharacterSheet.qml", { charModel: charModel })
        }
    }

    SwipeView {
        id: swipeView

        Component.onCompleted: {
            pgInfo.initialize()
        }

        property var __oldItem: null

        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        CharacterInfoPage {
            id: pgInfo
            charModel: root.charModel
        }

        Loader {
            active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
            sourceComponent: MoveMainPage {
                charModel: root.charModel
            }
        }

        Loader {
            active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
            sourceComponent: CharacterAuraPage {
                charModel: root.charModel
            }
        }


        Loader {
            active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
            sourceComponent: HyperMainPage {
                charModel: root.charModel
            }
        }

        Loader {
            active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
            sourceComponent: GameBoard {
                charModel: root.charModel
            }
        }

        onCurrentItemChanged: {

            if (__oldItem && __oldItem.finalize) {
                __oldItem.finalize()
            }

            var item_ = currentItem.item
            //console.log('current item: ', item_, item_.initialize, item_.finalize, item_.url)

            if (item_ && item_.initialize) {
                item_.initialize()
            }

            __oldItem = item_

            if ( item_ && item_.getTitle )
                pageTitle.title = item_.getTitle()

            if ( item_ && item_.reset )
                pageTitle.resetCallback = item_.reset
            else
                pageTitle.resetCallback = null
        }
    }

    footer: TabBar {
        id: tabBar

        width: parent.width
        height: 40
        spacing: 2
        currentIndex: swipeView.currentIndex

        Repeater {
            model: [
                'profile',
                'moves',
                'aura',
                'hyper',
                'game',
            ]

            TabButton {
                property bool isActive: tabBar.currentItem === this
                property var activeSrc: 'qrc:/img/tab/%1_active.png'.arg(modelData)
                property var inactiveSrc: 'qrc:/img/tab/%1.png'.arg(modelData)

                background: Rectangle { color: Style.primaryBgColor }
                contentItem: Image {
                    source: isActive ? activeSrc : inactiveSrc
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                }

                width: isActive ? 100 : 64
                height: tabBar.height
            }
        }
    }
}
