/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.9
import QtQml.Models 2.1
import QtQuick.Controls 2.2
import QtQuick.Templates 2.2 as T
import QtGraphicalEffects 1.0

Item {
    id: root

    property alias background: background.source
    property int currentIndex: 0
    property var currentItem: null
    default property alias content: visualModel.children

    Rectangle {
        id: rect
        color: "#B7D5DD"
        width: Math.max(list.contentItem.contentWidth, parent.width)
        height: Math.max(list.contentItem.height, parent.height)

        Image {
            id: background
            fillMode: Image.TileHorizontally
            x: -list.contentItem.contentX / 6
            width: Math.max(list.contentItem.contentWidth, parent.width)
        }

        DropShadow {
            anchors.fill: background
            horizontalOffset: 40
            verticalOffset: 20
            radius: 4.0
            samples: 11
            color: "#802A3E47"
            source: background
        }
    }

    T.SwipeView {
        id: list

        /*implicitWidth: Math.max(background ? background.implicitWidth : 0,
                                contentItem.implicitWidth + leftPadding + rightPadding)
        implicitHeight: Math.max(background ? background.implicitHeight : 0,
                                 contentItem.implicitHeight + topPadding + bottomPadding)*/

        anchors.fill: parent

        currentIndex: root.currentIndex

        onCurrentIndexChanged: {
            root.currentIndex = currentIndex
            root.currentItem = list.currentItem
        }

        contentItem: ListView {
            model: ObjectModel { id: visualModel }
            interactive: list.interactive
            currentIndex: list.currentIndex

            spacing: list.spacing
            orientation: list.orientation
            snapMode: ListView.SnapOneItem
            boundsBehavior: Flickable.StopAtBounds

            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: 0
            preferredHighlightEnd: 0
            highlightMoveDuration: 250
        }
    }

    /*
    ListView {
        id: list
        anchors.fill: parent

        currentIndex: root.currentIndex

        onCurrentIndexChanged: {
            root.currentIndex = currentIndex
            root.currentItem = list.currentItem
        }

        orientation: Qt.Horizontal
        boundsBehavior: Flickable.DragOverBounds
        model: ObjectModel { id: visualModel }

        highlightRangeMode: ListView.StrictlyEnforceRange
        snapMode: ListView.SnapOneItem
    }
    */

}
