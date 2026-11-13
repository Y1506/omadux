pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var enabledPlugins: []
    property var widgetComponents: ({})

    readonly property string enabledPath: Quickshell.env("HOME") + "/.config/omarchy/plugins/enabled.json"
    readonly property string pluginsDir: Quickshell.env("HOME") + "/.config/omarchy/plugins"

    function refresh() {
        reader.running = true;
    }

    Process {
        id: reader
        command: ["bash", "-c", "if [[ -f \"" + root.enabledPath + "\" ]]; then cat \"" + root.enabledPath + "\"; else echo '[]'; fi"]
        stdout: SplitParser {
            onRead: line => {
                try {
                    const parsed = JSON.parse(String(line));
                    if (Array.isArray(parsed)) {
                        root.enabledPlugins = parsed;
                    }
                } catch (e) {}
            }
        }
    }

    FileView {
        path: root.enabledPath
        watchChanges: true
        printErrors: false
        onFileChanged: root.refresh()
    }

    Component.onCompleted: refresh()
}
