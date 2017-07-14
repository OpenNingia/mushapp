import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "fa"
import "business/exp.js" as Exp

Page {
    id: root
    //property string activeCharacterName
    //property int activeCharacterIndex
    property int charExperience
    property var charModel

    property var initialize: function() {
        updateExp()
    }

    property var finalize: function() {

    }

    property var save: function() {
        if ( charModel ) {
            console.log('CharacterInfoPage: saving...')
            dataModel.characterData = JSON.stringify(charModel)

            // update experience
            updateExp()
        }
    }

    property var updateExp: function() {        
        charExperience = charModel ? Exp.calcExp(charModel) : 0
        console.log('new experience: %1'.arg(charExperience))
    }

    /*header: PageHeader {
        title: activeCharacterName
        onBackClicked: root.StackView.view.pop()
    }*/

    // TITOLO O DESCRIZIONE
    ColumnLayout {

        anchors.fill: parent
        anchors.margins: 12
        //spacing: 3

        ColumnLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("Title")
                font.bold: true
            }
            TextField {
                id: txTitle
                text: root.charModel ? root.charModel.title : ""
                Layout.fillWidth: true
                onTextChanged: root.charModel.title = text
            }
        }

        // PUNTI ESPERIENZA
        ColumnLayout {
            Layout.fillWidth: true
            //anchors.margins: 2
            spacing: 2

            Label {
                text: qsTr("Experience")
                font.bold: true
            }

            ToolButton {
                id: txExp
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                topPadding: 12
                text: charExperience
                font.pointSize: 14

                ToolTip {
                    parent: txExp
                    visible: txExp.down
                    width: 180
                    height: 80
                    contentItem: ExpDetails { id: expDtl; charModel: root.charModel }
                }
                onDownChanged: {
                    expDtl.charModel = root.charModel
                }
            }
        }

        Rectangle {
            height: 1
            Layout.minimumHeight: 1
            Layout.fillWidth: true
            color: "#3F51B5"
        }

        // RAPIDITA'
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Speed")
                font.bold: true
            }

            RoundPicker6 {
                id: veSpeed
                rating: root.charModel ? root.charModel.speed : 0
                onValueChanged: {
                    root.charModel.speed = rating
                    save()
                }
            }
        }

        // ATTACCO
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Attack")
                font.bold: true
            }

            RoundPicker6 {
                id: veAttack
                rating: root.charModel ? root.charModel.attack : 0
                onValueChanged: {
                    root.charModel.attack = rating
                    save()
                }
            }
        }

        // DIFESA
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Defense")
                font.bold: true
            }

            RoundPicker6 {
                //Layout.alignment: Qt.AlignRight | Qt.AlignBaseline
                id: veDefense
                rating: root.charModel ? root.charModel.defence : 0
                onValueChanged: {
                    root.charModel.defence = rating
                    save()
                }
            }
        }

        Rectangle {
            height: 1
            Layout.minimumHeight: 1
            Layout.fillWidth: true
            color: "#3F51B5"
        }

        // EQUILIBRIO
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Balance")
                font.bold: true
            }

            RoundPicker5 {
                id: vaBalance
                rating: root.charModel ? root.charModel.balance : 0
                onValueChanged: {
                    root.charModel.balance = rating
                    save()
                }
            }
        }

        // VOLONTA'
        RowLayout {
            Layout.fillWidth: true
            anchors.margins: 2
            spacing: 24

            Label {
                Layout.preferredWidth: 60
                text: qsTr("Willpower")
                font.bold: true
            }

            RoundPicker5 {
                id: vaWillPower
                rating: root.charModel ? root.charModel.willpower : 0
                onValueChanged: {
                    root.charModel.willpower = rating
                    save()
                }
            }
        }
    }

    /*
    footer: ToolBar {
        id: tabBar
        RowLayout {
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
            }

            ToolButton {
                text: qsTr("Special")
                onClicked: {
                    root.StackView.view.push(
                                "qrc:/CharacterMovesPage.qml",
                                { charModel: charModel, superMoves: false })
                }
            }
            ToolButton {
                text: qsTr("Super")
                onClicked: {
                    root.StackView.view.push(
                                "qrc:/CharacterMovesPage.qml",
                                { charModel: charModel, superMoves: true })
                }
            }

            ToolSeparator {}

            ToolButton {
                text: qsTr("Aura")
            }
            ToolButton {
                text: qsTr("Equip")
                onClicked: {
                    root.StackView.view.push(
                                "qrc:/WebCharacterSheet.qml",
                                { charModel: charModel })
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }*/
}
