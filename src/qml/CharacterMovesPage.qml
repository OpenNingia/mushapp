import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Page {
    id: root

    property var charModel
    property bool superMoves

    property var initialize: function() {
        if ( charModel ) {
            pgList.charModel = root.charModel
            pgList.superMoves = root.superMoves
            pgList.initialize()
            //stackView.initialItem = pgList;
        }
    }

    property var finalize: function() {

    }


    StackView {
        id: stackView

        property Item __oldItem: null

        anchors.fill: parent
        initialItem: CharacterMoveListPage {
            id: pgList
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
}
