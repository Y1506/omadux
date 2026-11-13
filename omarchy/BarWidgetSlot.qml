import QtQuick
import Quickshell

Item {
    id: root

    required property var entry
    required property var host

    property bool vertical: host ? host.vertical : false
    property string edge: host ? host.position : "top"

    readonly property string moduleName: (typeof entry === "string") ? entry : (entry && entry.id ? entry.id : "")
    readonly property var moduleSettings: (entry && typeof entry === "object") ? entry : ({})

    readonly property var registryComponent: {
        if (entry && entry.component) return entry.component;
        const reg = host ? host.barWidgetRegistry : null;
        if (!reg || !reg.widgets) return null;
        return reg.widgets[moduleName] ? reg.widgets[moduleName].component : null;
    }

    readonly property var bar: PluginBarFacade {
        id: facade
        host: root.host
        moduleName: root.moduleName
    }

    property Item activeItem: null

    implicitWidth: activeItem ? activeItem.implicitWidth : 32
    implicitHeight: activeItem ? activeItem.implicitHeight : 32

    function createItem() {
        if (activeItem) {
            activeItem.destroy();
            activeItem = null;
        }
        const comp = root.registryComponent;
        if (!comp || comp.status !== Component.Ready) return;

        try {
            const item = comp.createObject(root, {
                bar: root.bar,
                moduleName: root.moduleName,
                settings: root.moduleSettings
            });
            if (item) {
                item.anchors.centerIn = root;
                activeItem = item;
            }
        } catch (e) {
            console.warn("omadux: failed to create bar widget " + root.moduleName + ": " + e);
        }
    }

    onRegistryComponentChanged: createItem()
    Component.onCompleted: createItem()
    Component.onDestruction: {
        if (activeItem) activeItem.destroy();
    }
}
