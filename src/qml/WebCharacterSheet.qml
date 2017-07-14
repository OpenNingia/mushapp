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
        //url: "http://www.acchiappasogni.org/msrpg/pgcreator/"
        url: "http://www.acchiappasogni.org/msrpg/pgcreator/ver2/index.php"

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

            property string change_name_js: "changeName('%1');".arg(charModel.name)

            property string update_statistics_js: "
                var chrs = [
                    document.getElementById('ra'),
                    document.getElementById('at'),
                    document.getElementById('de')]

                var values = [%1, %2, %3];
                for (var i = 0; i < chrs.length; i++) {
                    var chr = chrs[i];
                    var val = values[i];
                    var labels = chr.getElementsByTagName('label');
                    for (var j = 0; j < val; j++) {
                        labels[j].getElementsByTagName('input')[0].checked = true;
                    }
                }
            ".arg(charModel.speed).arg(charModel.attack).arg(charModel.defence)            

            //var container = document.getElementById('symbol');
            //var symbol_elements = container.getElementsByTagName('span');

            property var build_moves_js: function(model) {
                var js = "

                    function gogogo() {
                        var symbol_map = {
                            'spinge': 'image/simboliSTD/TC/Allontana.png',
                            'cade': 2,
                            'combo': 3,
                            'distanza': 4,
                            'possente': 5,
                            'riflette': 6,
                            'saltook': 7,
                            'scaglia': 8,
                            'schianta': 9,
                            'trasla': 10,
                            'udurezza': 11,
                            'uagility': 12,
                            'assorbimento': 13,
                            'blitz': 14,
                            'cadi': 15,
                            'conclusiva': 16,
                            'congela': 17,
                            'crawling': 18,
                            'stordente': 19,
                            'tutto_per_tutto': 20,
                            'danno_continuato': 21,
                            'danno_relativo': 22,
                            'sforzo_estremo': 23,
                            'vampirico': 24,
                        };

                        var t = document.getElementsByClassName('tecnica');
                        var special_m = %1;
                        var super_m = %2;

                        for (var i = 0; i < 5; i++) {
                            if ( i >= special_m.length ) { break; }

                            var n = t[i].getElementsByTagName('input')[0];
                            var p = t[i].getElementsByTagName('input')[1];
                            n.value = special_m[i].name;
                            p.value = 'PA: ' + special_m[i].cost;

                            var symbols = special_m[i].symbols;
                            for (var j = 0; j < symbols.length; j++) {
                                var symbol_img = symbol_map[symbols[j]];
                                try {
                                    var e1 = 'simbolo'+(i+1)+'_'+j+1;
                                    var e2 = 'simbolo'+(i+1)+'_'+j+2;
                                    document.getElementById(e1).getElementsByTagName('span')[0].innerHTML = '<img src=\"' + symbol_img + '\" width=\"20\" height=\"20\"/>';
                                    document.getElementById(e2).style.display = 'block';
                                } catch ( error ) { }
                            }
                        }

                        for (var i = 5; i < 7; i++) {
                            if ( (i-5) >= super_m.length ) { break; }

                            var n = t[i].getElementsByTagName('input')[0];
                            var p = t[i].getElementsByTagName('input')[1];
                            n.value = super_m[i-5].name;
                            p.value = 'PA: ' + super_m[i].cost;

                            var symbols = super_m[i-5].symbols;
                            for (var j = 0; j < symbols.length; j++) {
                                var symbol_idx = 1;
                                selectSymbol(symbol_elements[symbol_idx], i+1, j+1);
                            }
                        }
                    }

                    document.getElementById('page').classList.toggle('adv');
                    gogogo();
                ";

                return js.arg(JSON.stringify(model.moves)).arg(JSON.stringify(model.superMoves));
            }

            property string fill_moves_js: build_moves_js(charModel)
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
            },

            WebEngineScript {
              id: jsChangeMoves
              name: "jsChangeMoves"
              injectionPoint: WebEngineScript.Deferred
              sourceCode: code.fill_moves_js
              worldId: WebEngineScript.MainWorld
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
