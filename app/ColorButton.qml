import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Button {
    width: parent.width
    onClicked: {
        main.brushColor = color
        PopupUtils.close(colorPickerDlg)
    }
}
