import QtQuick
import "./Widgets"

Item {
    id: root
    property string widgetId: ""
    property var widgetData: ({})
    property var bar: null

    Loader {
        anchors.fill: parent
        active: root.widgetId === "omarchyPlugins"
        sourceComponent: OmarchyPlugins {}
    }
}
