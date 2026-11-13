import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.LauncherButton {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "LauncherButton", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
