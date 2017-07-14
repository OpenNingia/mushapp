import QtQuick 2.6

import "fontawesome.js" as FA

Text {
    id: root;

    FontLoader {
        id: faFont
        source: "qrc:/fa/fontawesome-webfont.ttf"
    }

    property var icons: FA.Icons;
    property alias icon: root.text;
    property alias pointSize: root.font.pointSize;

    font.family: faFont.name;
    style: Text.Normal;
    textFormat: Text.PlainText;
    verticalAlignment: Text.AlignVCenter;
}

