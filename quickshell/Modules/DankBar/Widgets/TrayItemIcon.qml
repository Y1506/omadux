import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.TrayItemIcon {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "TrayItemIcon", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
