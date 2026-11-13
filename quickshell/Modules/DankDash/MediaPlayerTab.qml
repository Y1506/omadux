import QtQuick
import "../../Common"
import "../DDash" as New

New.MediaPlayerTab {
    id: shim
    Component.onCompleted: Deprecation.module(shim, "MediaPlayerTab", "qs.Modules.DankDash", "qs.Modules.DDash")
}
