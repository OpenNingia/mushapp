import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Page {
    id: root

    /*QtObject {
        id: charModelTest
        property string name
        property string title
        // caratteristiche
        property int speed
        property int attack
        property int defence
        property int balance
        property int willpower
        // mosse
        property var moves
        property var superMoves
        // aura
        property int auraLvl
        property int auraPoints
    }*/

    property string activeCharacterName
    property var characterModel

    property var initialize: function() {
        if ( dataModel ) {
            dataModel.character = activeCharacterName
            characterModel = JSON.parse(dataModel.characterData)
            pgInfo.initialize()

            console.log(dataModel.characterData)
            /*
            charModelTest.name = o.name
            charModelTest.title = o.title
            charModelTest.speed = o.speed
            charModelTest.attack = o.attack
            charModelTest.defence = o.defence
            */
        }
    }

    property var finalize: function() {
        // finalize on exit
        if (swipeView.currentItem && swipeView.currentItem.finalize)
            swipeView.currentItem.finalize()

        //dataModel.characterData = JSON.stringify(characterModel)
    }


    header: PageHeader {
        title: activeCharacterName
        onBackClicked: root.StackView.view.pop()
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

        onCurrentItemChanged: {
            if (__oldItem && __oldItem.finalize) {
                __oldItem.finalize()
            }

            if (currentItem && currentItem.initialize) {
                currentItem.initialize()
            }

            __oldItem = currentItem
        }
    }

    /*
    PageIndicator {
        id: indicator

        count: swipeView.count
        currentIndex: swipeView.currentIndex

        anchors.bottom: swipeView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }*/

    /*
    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Info")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("Special")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("Super")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("Aura")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("Sheet")
            width: implicitWidth
        }
    }*/
}
