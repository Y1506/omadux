import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.ClipboardButton {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "ClipboardButton", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
