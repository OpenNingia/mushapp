// Style.qml
pragma Singleton
import QtQuick 2.6

QtObject {

    property color primaryBgColor: "#2A3E47"
    property color primaryFgColor: "#CEE1A0"

    // FONTS
    property var uiFont: FontLoader {
        id: fntDaxMed
        source: "qrc:/fonts/DaxMedium_1.ttf"
    }
    property var uiBoldFont: FontLoader {
        id: fntDaxBold
        source: "qrc:/fonts/DaxBold_2.ttf"
    }
}

