import QtQuick
import "../../Common"

DModal {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankModal", "DModal", "qs.Modals.Common")
}
