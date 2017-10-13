import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
// import QtQuick.Controls.Material 2.1
import "fa"
import "fa/fontawesome.js" as FA
import "business/dal.js" as Dal

MushaDynPage {
    id: root

    property var initialize: function() {
        console.log('GameBoard initialize')
        charModelChanged()
        gameObject.resume()
    }

    property var finalize: function() {
        console.log('GameBoard finalize')
        gameObject.suspend()
        save()
    }

    property var reset: function() {
        gameObject.reset()
    }

    property var save: function() {
        Dal.saveCharacter(charModel);
    }

    QtObject {
        id: gameObject

        property int turn_cnt: 1

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

            // turn counter
            turn_cnt = 1
        }

        property var turn: function() {
            sbPa.value += charModel.speed
            if ( auraSwitch.checked )
                itmAura.value = Math.min(10, itmAura.value + 1)
            turn_cnt += 1
        }

        property var resume: function() {

            if ( charModel.game ) {
                sbPa.value = charModel.game.pa
                sbSp.value = charModel.game.sp
                sbHp.value = charModel.game.hp
                itmWillpower.value = charModel.game.willpower
                itmBalance.value = charModel.game.balance

                // armor
                haSpeed.value = charModel.game.ha_speed
                haAttack.value = charModel.game.ha_attack
                haDefence.value = charModel.game.ha_defence

                // weapon
                hwSpeed.value = charModel.game.hw_speed
                hwAttack.value = charModel.game.hw_attack
                hwDefence.value = charModel.game.hw_defence

                // aura
                itmAura.value = charModel.game.aura

                // turn counter
                turn_cnt = charModel.game.turn
            }
        }

        property var suspend: function() {

            if ( !charModel.game ) {
                charModel.game = { }
            }

            charModel.game.pa = sbPa.value
            charModel.game.sp = sbSp.value
            charModel.game.hp = sbHp.value
            charModel.game.willpower = itmWillpower.value
            charModel.game.balance = itmBalance.value

            // armor
            charModel.game.ha_speed = haSpeed.value
            charModel.game.ha_attack = haAttack.value
            charModel.game.ha_defence = haDefence.value

            // weapon
            charModel.game.hw_speed = hwSpeed.value
            charModel.game.hw_attack = hwAttack.value
            charModel.game.hw_defence = hwDefence.value

            // aura
            charModel.game.aura = itmAura.value

            // turn counter
            charModel.game.turn = turn_cnt

        }
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

                visible: charModel && charModel.willpower > 0

                Label {
                    Layout.preferredWidth: 60
                    text: qsTr("Willpower")
                    font.bold: true
                }

                FlaggablePicker {
                    id: itmWillpower
                    value: 0
                    size: charModel ? charModel.willpower : 0
                }
            }

            RowLayout {                
                Layout.fillWidth: true
                anchors.margins: 2
                spacing: 24

                visible: charModel && charModel.balance > 0

                Label {
                    Layout.preferredWidth: 60
                    text: qsTr("Balance")
                    font.bold: true
                }

                FlaggablePicker {
                    id: itmBalance
                    value: 0
                    size: charModel ? charModel.balance : 0
                }
            }

            // AURA
            ColumnLayout {
                Layout.fillWidth: true
                anchors.margins: 2
                spacing: 2

                visible: charModel && charModel.aura.level > 0

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

                visible: charModel && charModel.armor.name !== ""

                Switch {
                    id: haSwitch
                    text: charModel ? charModel.armor.name : ""
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

                        visible: charModel && charModel.armor.speed > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Speed")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: haSpeed
                            value: 0
                            size: charModel ? charModel.armor.speed : 0
                        }
                    }
                    // SPEED

                    // ATTACK
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel && charModel.armor.attack > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Attack")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: haAttack
                            value: 0
                            size: charModel ? charModel.armor.attack : 0
                        }
                    }
                    // ATTACK

                    // DEFENCE
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel && charModel.armor.defence > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Defence")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: haDefence
                            value: 0
                            size: charModel ? charModel.armor.defence : 0
                        }
                    } // DEFENCE
                }
            } // HYPER ARMOR

            // HYPER WEAPON
            ColumnLayout {
                Layout.fillWidth: true

                visible: charModel && charModel.weapon.name !== ""

                Switch {
                    id: hwSwitch
                    text: charModel ? charModel.weapon.name : ""
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

                        visible: charModel && charModel.weapon.speed > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Speed")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: hwSpeed
                            value: 0
                            size: charModel ? charModel.weapon.speed : 0
                        }
                    }
                    // SPEED

                    // ATTACK
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel && charModel.weapon.attack > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Attack")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: hwAttack
                            value: 0
                            size: charModel ? charModel.weapon.attack : 0
                        }
                    }
                    // ATTACK

                    // DEFENCE
                    RowLayout {
                        Layout.fillWidth: true
                        anchors.margins: 2
                        spacing: 24

                        visible: charModel && charModel.weapon.defence > 0

                        Label {
                            Layout.preferredWidth: 60
                            text: qsTr("Defence")
                            font.bold: true
                        }

                        FlaggablePicker {
                            id: hwDefence
                            value: 0
                            size: charModel ? charModel.weapon.defence : 0
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
                id: btSwitchTurn
                Layout.fillWidth: true
                text: qsTr("New turn (%1)").arg(gameObject.turn_cnt)
                onClicked: {
                    gameObject.turn()
                }
            }

        }
    }
}
