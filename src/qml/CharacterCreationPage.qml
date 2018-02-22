import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "components"
import "fa"

MushaDynPage {
    id: root

    property bool rename: false

    Component.onCompleted: {
        inputName.forceActiveFocus()
    }

    header: PageHeader {
        title: rename ? qsTr("Edit character") : qsTr("Character creation")
        onBackClicked: root.StackView.view.pop()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        TextField {
            id: inputName
            text: charModel ? charModel.name : ""
            width: 200
            placeholderText: qsTr("Enter character name")
            focus: true
            KeyNavigation.tab: inputTitle
            validator: RegExpValidator { regExp: /[^\"\\\/':]+/ }
            Layout.fillWidth: true
        }

        TextField {
            id: inputTitle
            text: charModel ? charModel.title : ""
            width: 200
            placeholderText: qsTr("Enter character title")
            KeyNavigation.tab: inputGroup
            validator: RegExpValidator { regExp: /[^\"\\\/':]+/ }
            Layout.fillWidth: true
        }

        MyComboBox {
            id: inputGroup
            KeyNavigation.tab: btConfirm
            model: ["PC", "PNG", "Minions", "Boss", "Altri"]
            width: 200
            Layout.fillWidth: true
            currentIndex: charModel ? model.indexOf(charModel.group) : -1
        }

        Item {
            Layout.fillHeight: true
        }
    }

    footer: ToolBar {
        id: tabBar
        RowLayout {
            anchors.fill: parent

            ToolButton {
                id: btConfirm
                Layout.fillWidth: true
                text: qsTr("Confirm")
                onClicked: {

                    if ( rename ) {

                        var oldName = charModel.name

                        charModel.name = inputName.text
                        charModel.title = inputTitle.text
                        charModel.group = inputGroup.currentIndex >= 0 ? inputGroup.model[inputGroup.currentIndex] : ""

                        if ( oldName === charModel.name ) {
                            dataModel.character = oldName
                            dataModel.characterData = JSON.stringify(charModel)
                        } else {
                            if ( dataModel.importCharacter(charModel.name, JSON.stringify(charModel)) )
                                dataModel.delCharacter(oldName)
                        }

                    } else {
                        if ( dataModel.addCharacter(inputName.text, inputTitle.text) ) {
                            dataModel.character = inputName.text
                            dataModel.character.group = inputGroup.currentIndex >= 0 ? inputGroup.model.get(inputGroup.currentIndex) : ""
                            console.log("add character success")
                        } else {
                            console.log("add character error")
                        }
                    }

                    root.StackView.view.pop()
                }
                KeyNavigation.tab: inputName
                enabled: inputName.text.length > 0
            }
        }
    }
}
