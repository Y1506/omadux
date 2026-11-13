import QtQuick
import "../DCommon/Common" as DCommon

DCommon.DColorAnim {
    id: shim
    Component.onCompleted: Deprecation.type(shim, "DankColorAnim", "DColorAnim", "qs.DCommon.Common")
}
