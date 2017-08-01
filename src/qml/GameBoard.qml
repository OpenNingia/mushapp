import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "fa"
import "fa/fontawesome.js" as FA

Page {
    id: root
    property var charModel

    QtObject {
        id: gameObject

        property var reset: function() {
            sbPa.value = 0
            sbSp.value = 0
            sbHp.value = 30
            itmWillpower.value = 0
            itmBalance.value = 0

            // armor
            haSpeed.value = 0
            haAttack.value = 0
            haDefence.value = 0

            // weapon
            hwSpeed.value = 0
            hwAttack.value = 0
            hwDefence.value = 0

            // aura
            itmAura.value = 0
        }

        property var turn: function() {
            sbPa.value += charModel.speed
            if ( auraSwitch.checked )
                itmAura.value = Math.min(10, itmAura.value + 1)
        }
    }

    header: PageHeader {
        title: qsTr("Game Board")
        backIcon: FA.Icons.fa_arrow_left
        onBackClicked: root.StackView.view.pop()
    }

    ScrollView {
        clip: false
        anchors.fill: parent
        anchors.margins: 12

        ColumnLayout {

            // PUNTI VITA
            RowLayout {
                Layout.fillWidth: true
                anchors.margins: 2
                spacing: 12

                Label {
                    Layout.preferredWidth: 60
                    text: qsTr("Hit Points")
                    font.bold: true
                }

                SpinBox {
                    id: sbHp
                    from: 0
                    to: 1000
                    stepSize: 1
                    value: 30
                }
            }

            // SP
            RowLayout {
                Layout.fillWidth: true
                anchors.margins: 2
                spacing: 12

                Label {
                    Layout.preferredWidth: 60
                    text: qsTr("SP")
                    font.bold: true
                }

                SpinBox {
                    id: sbSp
                    from: 0
                    to: 9
                    stepSize: 1
                    value: 0
                }
            }

            // PA
            RowLayout {
                Layout.fillWidth: true
                anchors.margins: 2
                spacing: 12

                Label {
                    Layout.preferredWidth: 60
                    text: qsTr("PA")
                    font.bold: true
                }

                SpinBox {
                    id: sbPa
                    from: 0
                    to: 100
                    stepSize: 1
                    value: 0
                }
            }

            // WILLPOWER
            RowLayout {
                Layout.fillWidth: true
                anchors.margins: 2
                spacing: 24

                visible: charModel.willpower > 0

                Label {
                    Layout.preferredWidth: 60
                    text: qsTr("Willpower")
                    font.bold: true
                }

                FlaggablePicker {
                    id: itmWillpower
                    value: 0
                    size: charModel.willpower
                }
            }

            RowLayout {                
                Layout.fillWidth: true
                anchors.margins: 2
                spacing: 24

                visible: charModel.balance > 0

                Label {
                    Layout.preferredWidth: 60
                    text: qsTr("Balance")
                    font.bold: true
                }

                FlaggablePicker {
                    id: itmBalance
                    value: 0
                    size: charModel.balance
                }
            }

            // AURA
            ColumnLayout {
                Layout.fillWidth: true
                anchors.margins: 2
                spacing: 2

                visible: charModel.aura.level > 0

                Switch {
                    id: auraSwitch
                    text: qsTr("Burn Aura")
                    //font.bold: true
                }

                FlaggablePicker {
                    id: itmAura
                    value: 0
                    size: 10
                    visible: auraSwitch.checked
                }
            }

            // HYPER ARMOR
            ColumnLayout {
                Layout.fillWidth: true

                visible: charModel.armor.name !== ""

                Switch {
                    id: haSwitch
                    text: charModel.armor.name
                }

                ColumnLayout {
                    id: hyperArmor
                    visible: haSwitch.checked
                    Layout.fillWidth: true                    

                    // SPEED
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel.armor.speed > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Speed")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: haSpeed
                            value: 0
                            size: charModel.armor.speed
                        }
                    }
                    // SPEED

                    // ATTACK
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel.armor.attack > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Attack")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: haAttack
                            value: 0
                            size: charModel.armor.attack
                        }
                    }
                    // ATTACK

                    // DEFENCE
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel.armor.defence > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Defence")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: haDefence
                            value: 0
                            size: charModel.armor.defence
                        }
                    } // DEFENCE
                }
            } // HYPER ARMOR

            // HYPER WEAPON
            ColumnLayout {
                Layout.fillWidth: true

                visible: charModel.weapon.name !== ""

                Switch {
                    id: hwSwitch
                    text: charModel.weapon.name
                }

                ColumnLayout {
                    id: hyperWeapon
                    visible: hwSwitch.checked
                    Layout.fillWidth: true

                    // SPEED
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel.weapon.speed > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Speed")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: hwSpeed
                            value: 0
                            size: charModel.weapon.speed
                        }
                    }
                    // SPEED

                    // ATTACK
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel.weapon.attack > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Attack")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: hwAttack
                            value: 0
                            size: charModel.weapon.attack
                        }
                    }
                    // ATTACK

                    // DEFENCE
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel.weapon.defence > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Defence")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: hwDefence
                            value: 0
                            size: charModel.weapon.defence
                        }
                    } // DEFENCE
                }
            } // HYPER WEAPON


            Item {
                Layout.fillHeight: true
            }
        }
    }

    footer: ToolBar {
        id: tabBar
        RowLayout {
            anchors.fill: parent

            ToolButton {
                id: btReset
                Layout.fillWidth: true
                text: qsTr("Reset")
                onClicked: {
                    gameObject.reset()
                }
            }

            ToolButton {
                id: btSwitchTurn
                Layout.fillWidth: true
                text: qsTr("New turn")
                onClicked: {
                    gameObject.turn()
                }
            }

        }
    }
}
