import QtQuick
import Quickshell
import "../quickshell/Common"

QtObject {
    id: facade

    required property var host
    required property string moduleName
    readonly property string pluginId: moduleName

    readonly property color foreground: typeof Theme !== "undefined" ? Theme.surfaceText : "#ffffff"
    readonly property color barForeground: typeof Theme !== "undefined" ? Theme.primary : "#42a5f5"
    readonly property color background: typeof Theme !== "undefined" ? Theme.surfaceContainer : "#1e1e1e"
    readonly property color urgent: "#ba1a1a"
    readonly property string fontFamily: typeof Theme !== "undefined" ? Theme.defaultFontFamily : "sans-serif"

    property string position: host ? host.position : "top"
    property bool vertical: host ? host.vertical : false
    readonly property int barSize: host && host.barBreadth ? host.barBreadth : 32

    readonly property bool transparent: true
    readonly property bool foregroundAnimationEnabled: true
    readonly property bool centerHoverRevealSuppressed: false
    property bool centerSectionRevealHeld: false
    readonly property bool traySectionDragActive: false
    readonly property bool traySectionPopoutOpen: false

    property var clickTargets: []
    readonly property var layoutConfig: host && host.barConfig && host.barConfig.layout ? host.barConfig.layout : ({})
    readonly property var activePopout: null
    readonly property var barWidgetRegistry: host ? host.barWidgetRegistry : null
    readonly property var barConfig: host ? host.barConfig : ({})

    function _call(name, args, fallback) {
        try {
            if (host && typeof host[name] === "function") return host[name].apply(host, args);
        } catch (e) {}
        return fallback;
    }

    function showTooltip(target, text) { _call("showTooltip", [target, String(text || "")]); }
    function hideTooltip(target) { _call("hideTooltip", [target]); }
    function requestPopout(owner) { _call("requestPluginPopout", [facade, owner]); }
    function releasePopout(owner) { _call("releasePluginPopout", [facade, owner]); }
    function registerClickTarget(target) { _call("registerPluginClickTarget", [facade, target]); }
    function unregisterClickTarget(target) { _call("unregisterPluginClickTarget", [facade, target]); }
    function switchPanelFrom(owner, direction) { return _call("switchPluginPanelFrom", [facade, owner, direction], false); }
    function targetBelongsToWindow(target, window) { return _call("targetBelongsToWindow", [target, window], false); }
    function run(command) {
        if (command) {
            Quickshell.execDetached(["sh", "-c", String(command)]);
        }
    }
    function setCenterHoverRevealSuppressed(value) {}
    function notePopoutCard(card) { _call("notePluginPopoutCard", [facade, card]); }
    function popoutCardFor(owner) { return _call("pluginPopoutCardFor", [facade, owner], null); }
    function shellQuote(value) { return "'" + String(value === undefined || value === null ? "" : value).replace(/'/g, "'\\''") + "'"; }

    function moduleWidgets(id) {
        return String(id || "") === facade.moduleName ? _call("moduleWidgets", [facade.moduleName], []) : [];
    }
}
