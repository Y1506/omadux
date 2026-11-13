import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.FocusedWindowContextMenu {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "FocusedWindowContextMenu", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
