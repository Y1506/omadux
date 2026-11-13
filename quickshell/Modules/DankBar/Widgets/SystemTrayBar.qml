import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.SystemTrayBar {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "SystemTrayBar", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
