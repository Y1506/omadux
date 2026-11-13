import QtQuick
import "../../../Common"
import ".."

Rectangle {
    property real size: CcMetrics.statusDotSize

    width: size
    height: size
    radius: size / 2
    color: Theme.primary
}
