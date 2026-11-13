import QtQuick
import "../../Common"
import "../DDash" as New

New.WallpaperTab {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "WallpaperTab", "qs.Modules.DankDash", "qs.Modules.DDash")
}
