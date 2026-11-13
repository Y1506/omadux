import QtQuick
import "../../Common"
import "../DDash" as New

New.DDashPopout {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankDashPopout", "DDashPopout", "qs.Modules.DDash")
}
