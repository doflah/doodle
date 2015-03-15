import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Content 0.1
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
    property string brushColor: "black"

    DoodleStore { id: storage }

    Page {
        title: "Doodle"

        property var a_accept: Action {
            iconName: "ok"
            text: i18n.tr("Settings")
            onTriggered: {
                if (!main.transfer) return;
                var url = storage.appDir + "/foo.png";
                if (canvas.save(url)) {
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

        head.backAction: main.transfer !== null ? a_cancel : null
        head.actions: main.transfer !== null ? [a_accept, a_clear, a_color] : [a_clear, a_color]

        Canvas {
            id: canvas
            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                onMouseXChanged: {
                    var ctx = canvas.getContext("2d");
                    ctx.fillStyle = brushColor
                    ctx.beginPath();
                    ctx.arc(mouse.x, mouse.y, units.gu(1), 0, Math.PI * 2);
                    ctx.fill();
                    canvas.requestPaint();
                }

                onMouseYChanged: {
                    var ctx = canvas.getContext("2d");
                    ctx.fillStyle = brushColor
                    ctx.beginPath();
                    ctx.arc(mouse.x, mouse.y, units.gu(1), 0, Math.PI * 2);
                    ctx.fill();
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
            title: i18n.tr("Color")
            Column {
                ColorButton { color: "red" }
                ColorButton { color: "green" }
                ColorButton { color: "blue" }
                ColorButton { color: "yellow" }
                ColorButton { color: "black" }
            }
        }
    }

    Connections {
        target: ContentHub
        onExportRequested: main.transfer = transfer
    }
}
