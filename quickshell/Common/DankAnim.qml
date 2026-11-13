import QtQuick
import "../DCommon/Common" as DCommon

DCommon.DAnim {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankAnim", "DAnim", "qs.DCommon.Common")
}
