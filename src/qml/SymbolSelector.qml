import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

GridView {
    id: grid
    model: ListModel {
        ListElement {
            name: qsTr("2xCombo")
            tag: "combo"
            isChecked: false
            portrait: "qrc:/img/combo.png"
        }
        ListElement {
            name: qsTr("Assorbe")
            tag: "assorbimento"
            isChecked: false
            portrait: "qrc:/img/assorbimento.png"
        }
        ListElement {
            name: qsTr("Blitz")
            tag: "blitz"
            isChecked: false
            portrait: "qrc:/img/blitz.png"
        }
        ListElement {
            name: qsTr("Crolla")
            tag: "crolla"
            isChecked: false
            portrait: "qrc:/img/crolla.png"
        }
        ListElement {
            name: qsTr("Cade")
            tag: "cade"
            isChecked: false
            portrait: "qrc:/img/cade.png"
        }
        ListElement {
            name: qsTr("Conclude")
            tag: "conclusiva"
            isChecked: false
            portrait: "qrc:/img/conclusiva.png"
        }
        ListElement {
            name: qsTr("Congela")
            tag: "congela"
            isChecked: false
            portrait: "qrc:/img/congela.png"
        }
        ListElement {
            name: qsTr("Danno continuato")
            tag: "danno_continuato"
            isChecked: false
            portrait: "qrc:/img/danno_continuato.png"
        }
        ListElement {
            name: qsTr("Danno relativo")
            tag: "danno_relativo"
            isChecked: false
            portrait: "qrc:/img/danno_relativo.png"
        }
        ListElement {
            name: qsTr("Distanza")
            tag: "distanza"
            isChecked: false
            portrait: "qrc:/img/distanza.png"
        }
        ListElement {
            name: qsTr("Guarigione")
            tag: "guarigione"
            isChecked: false
            portrait: "qrc:/img/guarigione.png"
        }
        ListElement {
            name: qsTr("Multi")
            tag: "multi"
            isChecked: false
            portrait: "qrc:/img/multi.png"
        }
        ListElement {
            name: qsTr("Possente")
            tag: "possente"
            isChecked: false
            portrait: "qrc:/img/possente.png"
        }
        ListElement {
            name: qsTr("Riflette")
            tag: "riflette"
            isChecked: false
            portrait: "qrc:/img/riflette.png"
        }
        ListElement {
            name: qsTr("Salto OK")
            tag: "saltook"
            isChecked: false
            portrait: "qrc:/img/saltook.png"
        }
        ListElement {
            name: qsTr("Scaglia")
            tag: "scaglia"
            isChecked: false
            portrait: "qrc:/img/scaglia.png"
        }
        ListElement {
            name: qsTr("Schianta")
            tag: "schianta"
            isChecked: false
            portrait: "qrc:/img/schianta.png"
        }
        ListElement {
            name: qsTr("Sforzo estremo")
            tag: "sforzo_estremo"
            isChecked: false
            portrait: "qrc:/img/sforzo_estremo.png"
        }
        ListElement {
            name: qsTr("Spinge")
            tag: "spinge"
            isChecked: false
            portrait: "qrc:/img/spinge.png"
        }
        ListElement {
            name: qsTr("Stordisce")
            tag: "stordente"
            isChecked: false
            portrait: "qrc:/img/stordente.png"
        }
        ListElement {
            name: qsTr("Trasla")
            tag: "trasla"
            isChecked: false
            portrait: "qrc:/img/trasla.png"
        }
        ListElement {
            name: qsTr("Tutto per tutto")
            tag: "tutto_per_tutto"
            isChecked: false
            portrait: "qrc:/img/tutto_per_tutto.png"
        }
        ListElement {
            name: qsTr("Ultra Agility")
            tag: "uagility"
            isChecked: false
            portrait: "qrc:/img/uagility.png"
        }
        ListElement {
            name: qsTr("Ultra Durezza")
            tag: "udurezza"
            isChecked: false
            portrait: "qrc:/img/udurezza.png"
        }
        ListElement {
            name: qsTr("Vampirizza")
            tag: "vampirico"
            isChecked: false
            portrait: "qrc:/img/vampirico.png"
        }
    }

    signal symbolActivated(string symbolId)

    cellHeight: 50
    cellWidth: 50


    delegate: ToolButton {
        contentItem: Image {
            source: portrait
        }

        height: 48; width: 48

        ToolTip.visible: down
        ToolTip.text: name

        onClicked: grid.symbolActivated(tag)
    }
}

