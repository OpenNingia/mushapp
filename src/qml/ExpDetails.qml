import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import "business/exp.js" as Exp

Item {
    id: root
    property var charModel

    ColumnLayout {

        anchors.fill: parent
        //anchors.centerIn: parent
        //spacing: 3

        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 8

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Skills")
                font.bold: true
            }
            Label {
                Layout.preferredWidth: 60
                horizontalAlignment: Text.AlignRight
                text: charModel ? Exp.calcSkillExp(charModel.speed, charModel.attack, charModel.defence) : 0
                Layout.fillWidth: false
            }
        }

        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 8

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Moves")
                font.bold: true
            }
            Label {
                Layout.preferredWidth: 60
                horizontalAlignment: Text.AlignRight
                text: charModel ? Exp.calcMovesExp(charModel.moves.length, charModel.superMoves.length) : 0
                Layout.fillWidth: false
            }
        }

        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 8

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Aura")
                font.bold: true
            }
            Label {
                Layout.preferredWidth: 60
                horizontalAlignment: Text.AlignRight
                text: charModel ? Exp.calcAuraExp(charModel.aura.level, charModel.aura.points) : 0
                Layout.fillWidth: false
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
