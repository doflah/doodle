import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Button {
    width: parent.width
    onClicked: {
        main.bgColor = text === "" ? color : "transparent";
        PopupUtils.close(bgPickerDlg)
    }
}
