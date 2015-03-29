import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Button {
    width: parent.width
    onClicked: {
        main.fgColor = text === "" ? color : "transparent";
        PopupUtils.close(colorPickerDlg)
    }
}
