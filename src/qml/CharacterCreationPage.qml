import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import "fa"

Page {
    id: root

    Component.onCompleted: {
        inputName.forceActiveFocus()
    }

    header: PageHeader {
        title: qsTr("Character creation")
        showPdf: false
        onBackClicked: root.StackView.view.pop()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        TextField {
            id: inputName
            width: 200
            placeholderText: qsTr("Enter character name")
            focus: true
            KeyNavigation.tab: inputTitle
            validator: RegExpValidator { regExp: /[^\"\\\/':]+/ }
            Layout.fillWidth: true
        }

        TextField {
            id: inputTitle
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
                    if ( dataModel.addCharacter(inputName.text, inputTitle.text) ) {
                        console.log("add character success")
                    } else {
                        console.log("add character error")
                    }

                    root.StackView.view.pop()
                }
                KeyNavigation.tab: inputName
                enabled: inputName.text.length > 0
            }
        }
    }
}
