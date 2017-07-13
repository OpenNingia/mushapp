import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2

Page {
    id: root

    header: PageHeader {
        title: qsTr("Aura")
        onBackClicked: root.StackView.view.pop()
    }
}
