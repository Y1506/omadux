import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.AppsDock {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "AppsDock", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
