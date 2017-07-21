import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "fa"
import "fa/fontawesome.js" as FA

Page {
    id: root

    property var charModel

    header: PageHeader {
        title: charModel.name
        showPdf: false
        backIcon: FA.Icons.fa_arrow_left
        onBackClicked: root.StackView.view.pop()
    }

    FontLoader {
        id: distInkingFont
        source: "qrc:/fonts/DISTInking-Regular.otf"
    }

    FontLoader {
        id: rodekFont
        source: "qrc:/fonts/RODEK.TTF"
    }

    ColumnLayout {

        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        Flickable {
            id: myFrame

            //clip: true
            Layout.fillHeight: true
            Layout.fillWidth: true

            contentWidth: bgImage.width; contentHeight: bgImage.height

            Image {
                id: bgImage
                source: 'qrc:/img/Background_01.jpg'
                x: 0; y: 0
            }

            Text {

                TextMetrics {
                    id: charNameMetrics
                    font: txName.font
                    text: txName.text
                }

                id: txName
                text: charModel.name
                font.family: distInkingFont.name
                font.pointSize: 68
                //color: "#fff"
                x: (bgImage.width - charNameMetrics.width)/2
                y: 110
            }

            LinearGradient {
                anchors.fill: txName
                source: txName

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#ffc81a" }
                    GradientStop { position: 1.0; color: "#fe6307" }
                }
            }

            Image {
                source: 'qrc:/img/Colonna.png'
                x: 20
                y: 300
                width: 660
                height: 1530
            }

            Row {
                id: gridStats

                spacing: 4

                x: 140
                y: 460

                GridLayout {

                    columns: 2
                    rows: 3

                    // RAPIDITA'
                    Text {
                        text: "RA"
                        font.family: distInkingFont.name
                        font.pointSize: 24
                    }

                    Row {
                        spacing: 4
                        Repeater {
                            model: 6
                            TextIcon {
                                icon: modelData < charModel.speed ? icons.fa_circle : icons.fa_circle_o
                                pointSize: 24
                            }
                        }
                    }


                    // ATTACCO
                    Text {
                        text: "AT"
                        font.family: distInkingFont.name
                        font.pointSize: 24
                    }
                    Row {
                        spacing: 4
                        Repeater {
                            model: 6
                            TextIcon {
                                icon: modelData < charModel.attack ? icons.fa_circle : icons.fa_circle_o
                                pointSize: 24
                            }
                        }
                    }

                    // DIFESA
                    Text {
                        text: "DE"
                        font.family: distInkingFont.name
                        font.pointSize: 24
                        //x: 140
                        //y: 500
                    }

                    Row {
                        spacing: 4
                        Repeater {
                            model: 6
                            TextIcon {
                                icon: modelData < charModel.defence ? icons.fa_circle : icons.fa_circle_o
                                pointSize: 24
                            }
                        }
                    }

                    // EQUILIBRIO
                    Text {
                        text: "EQ"
                        font.family: distInkingFont.name
                        font.pointSize: 24
                    }

                    Row {
                        spacing: 4
                        Repeater {
                            model: 6
                            TextIcon {
                                icon: modelData < charModel.balance ? icons.fa_circle : icons.fa_circle_o
                                pointSize: 24
                            }
                        }
                    }
                    // VOLONTA'
                    Text {
                        text: "VO"
                        font.family: distInkingFont.name
                        font.pointSize: 24
                    }

                    Row {
                        spacing: 4
                        Repeater {
                            model: 6
                            TextIcon {
                                icon: modelData < charModel.willpower ? icons.fa_circle : icons.fa_circle_o
                                pointSize: 24
                            }
                        }
                    }
                }

                // VERTICAL DIVIDER
                Image {
                    source: 'qrc:/img/vdivider.png'
                    //x: 380
                    //y: 400
                }

                GridLayout {

                    //x: 420
                    //y: 460

                    columns: 2
                    rows: 2

                    Text {
                        text: "SP:"
                        font.family: distInkingFont.name
                        font.pointSize: 24
                    }

                    // SP ICON
                    Image {
                        source: 'qrc:/img/'+ charModel.spEngine + '.png'
                        Layout.preferredHeight: 32
                        Layout.preferredWidth: 32
                    }

                    Text {
                        text: "EXP:"
                        font.family: distInkingFont.name
                        font.pointSize: 24
                    }

                    Item { }
                }


            }

            // SPECIAL MOVES
            Image {
                id: specialMovesBg
                source: 'qrc:/img/pennellata1.png'
                x: 100
                //y: 620
                y: gridStats.y + 220
                width: 500; height: 100
            }

            Text {
                text: "Special Moves"
                font.family: distInkingFont.name
                font.pointSize: 40
                color: "#fff"
                x: 130
                //y: 640
                y: specialMovesBg.y + 20
            }
            //

            // LISTA TECNICHE SPECIALI
            Item {
                id: specialMovesList
                x: 130
                y: specialMovesBg.y + 120
                width: 400
                height: 500
                Column {
                    spacing: 6

                    Repeater {
                        model: charModel.moves

                        GridLayout {
                            columns: 2
                            rows: 3
                            Text {
                                Layout.columnSpan: 2
                                text: modelData.name
                                font.family: distInkingFont.name
                                font.pointSize: 22
                                color: "#666"
                            }
                            Text {
                                text: modelData.cost + ' PA'
                                font.family: rodekFont.name
                                font.pointSize: 20
                                color: "#666"
                            }
                            Row {
                                spacing: 6
                                Repeater {
                                    model: modelData.symbols
                                    Image {
                                        source: 'qrc:/img/' + modelData + '.png'
                                        width: 32; height: 32
                                    }
                                }
                            }

                            Image {
                                Layout.preferredWidth: specialMovesList.width
                                Layout.preferredHeight: 3
                                Layout.minimumHeight: 3
                                Layout.columnSpan: 2
                                source: 'qrc:/img/hdivider.png'
                            }
                        }
                    }
                }
            }

            // SUPER MOVES
            Image {
                id: superMovesBg
                source: 'qrc:/img/pennellata1.png'
                x: 100
                y: specialMovesBg.y + 650
                width: 500; height: 100
            }

            Text {
                text: "Super Moves"
                font.family: distInkingFont.name
                font.pointSize: 40
                color: "#fff"
                x: 130
                y: superMovesBg.y + 20
            }

            // LISTA SUPER TECNICHE
            Item {
                id: superlMovesList
                x: 130
                y: superMovesBg.y + 120
                width: 400
                height: 500
                Column {
                    spacing: 6

                    Repeater {
                        model: charModel.superMoves

                        GridLayout {
                            columns: 2
                            rows: 3
                            Text {
                                Layout.columnSpan: 2
                                text: modelData.name
                                font.family: distInkingFont.name
                                font.pointSize: 22
                                color: "#666"
                            }
                            Text {
                                text: modelData.cost + ' PA'
                                font.family: rodekFont.name
                                font.pointSize: 20
                                color: "#666"
                            }
                            Row {
                                spacing: 6
                                Repeater {
                                    model: modelData.symbols
                                    Image {
                                        source: 'qrc:/img/' + modelData + '.png'
                                        width: 32; height: 32
                                    }
                                }
                            }

                            Image {
                                Layout.preferredWidth: specialMovesList.width
                                Layout.preferredHeight: 3
                                Layout.columnSpan: 2
                                source: 'qrc:/img/hdivider.png'
                            }
                        }
                    }
                }
            }

        }
    }

    footer: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                Layout.fillWidth: true
                text: qsTr("Save PDF")
                onClicked: {
                    var oldWidth = myFrame.width
                    var oldHeight = myFrame.height
                    myFrame.width = myFrame.contentWidth
                    myFrame.height = myFrame.contentHeight
                    myFrame.grabToImage(function(result) {
                        myFrame.width = oldWidth
                        myFrame.height = oldHeight
                        result.saveToFile("c:\\something.png");

                        pdfExporter.printPdf(charModel.name, result.image)
                    })
                }
            }
        }
    }
}

