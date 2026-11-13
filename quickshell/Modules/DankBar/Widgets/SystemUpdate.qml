import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.SystemUpdate {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "SystemUpdate", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
