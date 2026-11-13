import QtQuick
import "../../../Common"
import "../../DBar/Widgets" as New

New.CapsLockIndicator {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "CapsLockIndicator", "qs.Modules.DankBar.Widgets", "qs.Modules.DBar.Widgets")
}
