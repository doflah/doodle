import QtQuick 2.0

import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Content 0.1

import U1db 1.0 as U1db

import Doodle 1.0

MainView {
    id: main
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "doodle.doflah"

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(100)
    height: units.gu(76)

    property var transfer: null
    property string fgColor: "black"
    property string bgColor: "transparent"

    DoodleStore { id: storage }

    Page {
        title: "Doodle"

        property var a_accept: Action {
            iconName: "ok"
            text: i18n.tr("Settings")
            onTriggered: {
                if (!main.transfer) return;
                var url = storage.appDir + "/foo.png";
                var ctx = dummy.getContext("2d");
                ctx.fillStyle = bgColor;
                ctx.fillRect(0, 0, dummy.width, dummy.height)
                ctx.drawImage(canvas, 0, 0);
                if (dummy.save(url)) {
                    main.transfer.items = [
                        contentItemComponent.createObject(main.transfer, {"url": url})
                    ];
                    main.transfer.state = ContentTransfer.Charged;
                } else {
                    main.transfer.state = ContentTransfer.Aborted;
                }

                main.transfer = null;
            }
        }
        property var a_cancel: Action {
            iconName: "back"
            text: i18n.tr("Cancel")
            onTriggered: {
                if (main.transfer) {
                    main.transfer.state = ContentTransfer.Aborted
                    main.transfer = null;
                }
            }
        }

        property var a_clear: Action {
            iconName: "delete"
            text: i18n.tr("Clear");
            onTriggered: {
                canvas.getContext("2d").clearRect(0, 0, canvas.width, canvas.height);
                canvas.requestPaint();
            }
        }
        property var a_color: Action {
            iconName: "compose"
            text: i18n.tr("Color");
            onTriggered: PopupUtils.open(colorPicker)
        }
        property var a_bg: Action {
            iconName: "browser-tabs"
            text: i18n.tr("Background");
            onTriggered: PopupUtils.open(bgPicker)
        }

        head.backAction: main.transfer !== null ? a_cancel : null
        head.actions: main.transfer !== null ? [a_accept, a_clear, a_color, a_bg] : [a_clear, a_color, a_bg]

        Rectangle {
            color: bgColor
            anchors.fill: parent
        }

        Canvas {
            id: dummy
            visible: false
            anchors.fill: parent
        }

        Canvas {
            id: canvas
            anchors.fill: parent

            MouseArea {
                property int radius: units.gu(1)

                anchors.fill: parent
                onMouseXChanged: draw(mouse)
                onMouseYChanged: draw(mouse)

                function draw(mouse) {
                    var ctx = canvas.getContext("2d");
                    if (fgColor === "transparent") {
                        ctx.clearRect(mouse.x - radius, mouse.y - radius, radius * 2, radius * 2);
                    } else {
                        ctx.fillStyle = fgColor
                        ctx.beginPath();
                        ctx.arc(mouse.x, mouse.y, radius, 0, Math.PI * 2);
                        ctx.fill();
                    }
                    canvas.requestPaint();
                }
            }
        }
    }

    Component {
        id: contentItemComponent
        ContentItem { }
    }

    Component {
        id: colorPicker

        Dialog {
            id: colorPickerDlg
            title: i18n.tr("Pen Color")
            Column {
                ColorButton { color: "red" }
                ColorButton { color: "green" }
                ColorButton { color: "blue" }
                ColorButton { color: "yellow" }
                ColorButton { color: "black" }
                ColorButton { text: "Eraser" }
            }
        }
    }

    Component {
        id: bgPicker

        Dialog {
            id: bgPickerDlg
            title: i18n.tr("Background Color")
            Column {
                BackgroundButton { color: "red" }
                BackgroundButton { color: "green" }
                BackgroundButton { color: "blue" }
                BackgroundButton { color: "yellow" }
                BackgroundButton { color: "black" }
                BackgroundButton { text: "None" }
            }
        }
    }

    Connections {
        target: ContentHub
        onExportRequested: main.transfer = transfer
    }

    U1db.Database {
        id: doodledb
        path: "doodledb"
    }

    U1db.Document {
        id: colorDoc
        database: doodledb
        docId: 'colors'
        create: true
        defaults: { "fgColor": fgColor, "bgColor": bgColor }
    }

    onFgColorChanged: colorDoc.contents = {fgColor: fgColor, bgColor: bgColor}
    onBgColorChanged: colorDoc.contents = {fgColor: fgColor, bgColor: bgColor}

    Component.onCompleted: {
        // pull the contents out - otherwise bgColor gets overwritten when we restore fgColor
        var settings = colorDoc.contents;
        fgColor = settings.fgColor;
        bgColor = settings.bgColor;
    }
}
