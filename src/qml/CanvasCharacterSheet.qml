import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
//import QtGraphicalEffects 1.0
import "fa"
import "fa/fontawesome.js" as FA

Page {
    id: root

    property var charModel
    property var pageImg

    header: PageHeader {
        title: charModel.name
        showPdf: false
        backIcon: FA.Icons.fa_arrow_left
        onBackClicked: root.StackView.view.pop()
    }

    Component.onCompleted: {
        charSheet.grabToImage(function(result) {
            pageImg = result.image

            // fit
            charSheet.fitToScreen()
        })
    }

    FontLoader {
        id: distInkingFont
        source: "qrc:/fonts/DISTInking-Regular.otf"
    }

    FontLoader {
        id: rodekFont
        source: "qrc:/fonts/RODEK.TTF"
    }

    //ColumnLayout {

    //anchors.fill: parent
    //anchors.margins: 0
    //spacing: 0



    PinchArea {
        id: pinchArea

        property real minScale: 1.0
        property real maxScale: 3.0

        anchors.fill: parent

        pinch.target: charSheet
        pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
        pinch.maximumScale: maxScale * 1.5 // when over zoomed

        onPinchStarted: {
            console.log('on pinch started')
            flick.interactive = false
        }

        onPinchFinished: {
            flick.returnToBounds()
            if (charSheet.scale < pinchArea.minScale) {
                bounceBackAnimation.to = pinchArea.minScale
                bounceBackAnimation.start()
            }
            else if (charSheet.scale > pinchArea.maxScale) {
                bounceBackAnimation.to = pinchArea.maxScale
                bounceBackAnimation.start()
            }
            flick.interactive = true
        }
        NumberAnimation {
            id: bounceBackAnimation
            target: charSheet
            duration: 250
            property: "scale"
            from: charSheet.scale
        }


        Flickable {
            id: flick
            anchors.fill: parent

            clip: true
            contentWidth: wrapper.width; contentHeight: wrapper.height
            boundsBehavior: Flickable.StopAtBounds
            Item {
                id: wrapper
                width: Math.max(charSheet.width * charSheet.scale, flick.width)
                height: Math.max(charSheet.height * charSheet.scale, flick.height)

                CharacterSheetItem {
                    id: charSheet
                    charModel: root.charModel
                    primaryFont: distInkingFont
                    secondaryFont: rodekFont

                    property real prevScale

                    function fitToScreen() {
                        scale = Math.min(flick.width / width, flick.height / height, 1)
                        pinchArea.minScale = scale
                        prevScale = scale
                    }

                    anchors.centerIn: parent

                    onScaleChanged: {
                        if ((width * scale) > flick.width) {
                            var xoff = (flick.width / 2 + flick.contentX) * scale / prevScale;
                            flick.contentX = xoff - flick.width / 2
                        }
                        if ((height * scale) > flick.height) {
                            var yoff = (flick.height / 2 + flick.contentY) * scale / prevScale;
                            flick.contentY = yoff - flick.height / 2
                        }
                        prevScale = scale
                    }
                }
            }
        }
    }

    //}

    footer: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                Layout.fillWidth: true
                text: qsTr("Save PDF")
                onClicked: {
                    pdfExporter.printPdf(charModel.name, pageImg)
                }

                enabled: pageImg !== null
            }
        }
    }
}

