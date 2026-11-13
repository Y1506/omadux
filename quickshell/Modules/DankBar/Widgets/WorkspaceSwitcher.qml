import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.WorkspaceSwitcher {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "WorkspaceSwitcher", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
