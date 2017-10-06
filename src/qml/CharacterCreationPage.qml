import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

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
            KeyNavigation.tab: btConfirm
            validator: RegExpValidator { regExp: /[^\"\\\/':]+/ }
            Layout.fillWidth: true
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

                        if ( oldName === charModel.name ) {
                            dataModel.character = oldName
                            dataModel.characterData = JSON.stringify(charModel)
                        } else {
                            if ( dataModel.importCharacter(charModel.name, JSON.stringify(charModel)) )
                                dataModel.delCharacter(oldName)
                        }

                    } else {
                        if ( dataModel.addCharacter(inputName.text, inputTitle.text) ) {
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
