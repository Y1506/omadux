import QtQuick
import "../../Common"
import "../DDash" as New

New.WeatherTab {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "WeatherTab", "qs.Modules.DankDash", "qs.Modules.DDash")
}
