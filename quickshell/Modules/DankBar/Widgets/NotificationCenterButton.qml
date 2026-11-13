import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.NotificationCenterButton {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "NotificationCenterButton", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
