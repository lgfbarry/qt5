/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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

import QtQuick 2.0
import QtTest 1.0

import QtDesktop 1.0

TestCase {
    id: testCase
    name: "Tests_Shortcut"
    when: windowShown
    width: 400
    height: 400

    property var rootObject

    // Style item to find out if we are on mac
    StyleItem {
        id: styleItem
    }

    function initTestCase() {
        var component = Qt.createComponent("shortcut/shortcuts.qml");
        compare(component.status, Component.Ready)
        rootObject =  component.createObject(testCase);
        verify(rootObject !== null, "created object is null")
        rootObject.forceActiveFocus();
    }

    function cleanupTestCase() {
        wait(100) //wait for a short while to make sure no leaked textures
    }

    function test_shortcut_data() {
        return [
            { key: Qt.Key_A, modifier: Qt.NoModifier, expected: "a pressed" },
            { key: Qt.Key_B, modifier: Qt.NoModifier, expected: "b pressed" },
            { key: Qt.Key_C, modifier: Qt.NoModifier, expected: "no key press" },
            { key: Qt.Key_C, modifier: Qt.ControlModifier, expected: "ctrl c pressed" },
            { key: Qt.Key_D, modifier: Qt.NoModifier, expected: "d pressed" },
            { key: Qt.Key_D, modifier: Qt.ControlModifier, expected: "no key press" },
            // shift d is not triggered because it is overloaded
            { key: Qt.Key_D, modifier: Qt.ShiftModifier, expected: "no key press" },
            { key: Qt.Key_D, modifier: Qt.AltModifier, expected: "alt d pressed" },
            { key: Qt.Key_T, modifier: Qt.NoModifier, expected: "no key press" },
            // on mac we don't have mnemonics
            { key: Qt.Key_T, modifier: Qt.AltModifier, expected: styleItem.style === "mac" ? "no key press" : "alt t pressed" },
        ]
    }

    function test_shortcut(data) {

        verify(rootObject != undefined);
        var text = rootObject.children[0];
        text.text = "no key press";

        keyPress(data.key, data.modifier);

        verify(text != undefined);
        compare(text.text, data.expected.toString());

    }
}



