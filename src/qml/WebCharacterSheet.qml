import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.2
import QtWebEngine 1.4

Page {
    id: root
    property var charModel: null

    header: PageHeader {
        title: qsTr("Character sheet")
        onBackClicked: root.StackView.view.pop()
    }

    WebEngineView {
        id: webView
        anchors.fill: parent
        url: "http://www.acchiappasogni.org/msrpg/pgcreator/"

        /*settings.accelerated2dCanvasEnabled: true
        settings.allowRunningInsecureContent: false
        settings.autoLoadIconsForPage: false
        settings.hyperlinkAuditingEnabled: false
        settings.javascriptCanAccessClipboard: false
        settings.javascriptCanOpenWindows: false
        settings.javascriptEnabled: true
        settings.localStorageEnabled: false
        settings.pluginsEnabled: false
        settings.printElementBackgrounds: true
        settings.webGLEnabled: false*/

        QtObject {
            id: code
            property string update_statistics_js: "
                var chrs = document.querySelectorAll('[data-chrs]');
                var values = [%1, %2, %3];
                for (var i = 0; i < chrs.length; i++) {
                    var chr = chrs[i];
                    var val = values[i];
                    var labels = chr.getElementsByTagName('label');
                    labels[val-1].getElementsByTagName('input')[0].click();
                }
            ".arg(charModel.speed).arg(charModel.attack).arg(charModel.defence)

            property string change_name_js: "updateName('%1');".arg(charModel.name)
        }

        userScripts: [
            WebEngineScript {
              id: jsChangeName
              name: "jsChangeName"
              injectionPoint: WebEngineScript.Deferred
              sourceCode: code.change_name_js
              worldId: WebEngineScript.MainWorld
              //runOnSubframes: true
            },

            WebEngineScript {
              id: jsChangeStats
              name: "jsChangeStats"
              injectionPoint: WebEngineScript.Deferred
              sourceCode: code.update_statistics_js
              worldId: WebEngineScript.UserWorld
              //runOnSubframes: true
            }
        ]

        onLoadingChanged: {
            if ( loadRequest.status == WebEngineLoadRequest.LoadSucceededStatus ) {
                console.log("page loaded!")
            }
        }

        /*onPdfPrintingFinished: {
            console.log('printing finshed')
        }*/
    }

    footer: ToolBar {
        id: tabBar
        RowLayout {
            anchors.fill: parent

            ToolButton {
                Layout.fillWidth: true
                text: qsTr("Print")
                onClicked: {
                    webView.printToPdf("c:\\temp\\test.pdf", WebEngineView.A6)
                    console.log('stampa avviata')
                    /*webView.runJavaScript("window.print();", function() {
                        console.log('stampa avviata')
                    })*/
                }
                //enabled: webView.loading == false
            }
        }
    }
}
