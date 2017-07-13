import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import org.openningia.mushapp 1.0
import "fa"

Page {
    id: root

    Component.onCompleted: {
        inputName.forceActiveFocus()
    }

    header: PageHeader {
        title: qsTr("Character creation")
        onBackClicked: root.StackView.view.pop()
    }

    ColumnLayout {
        anchors.centerIn: parent

        TextField {
            id: inputName
            width: 200
            placeholderText: qsTr("Enter character name")
            focus: true
            KeyNavigation.tab: inputTitle
        }

        TextField {
            id: inputTitle
            width: 200
            placeholderText: qsTr("Enter character title")
            KeyNavigation.tab: btConfirm
        }

        Button {
            id: btConfirm
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
        }

    }

}
