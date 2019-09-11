import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.LocalStorage 2.0
import "storage.js" as Settings

ApplicationWindow {
    id: window
    visible: true
    title: qsTr("TensorFlow Lite & Qt")

    readonly property string tMinConfidence:   'minConfidence'
    readonly property string tNThreads:        'nThreads'
    readonly property string tShowInfTime:     'showInfTime'
    readonly property string tResolution:      'resolution'
    readonly property string tSemiTransparent: 'semiTransparent'
    readonly property string tShowBackground:   'showBackground'

    // Default values
    readonly property double defMinConfidence:   0.7
    readonly property bool   defShowInfTime:     false
    readonly property int    defNumThreads:      1
    readonly property string defResolution:      "640x480"
    readonly property bool   defSemiTransparent: true
    readonly property bool   defShowBackground:  true

    property double minConfidence:   Settings.get(tMinConfidence,defMinConfidence)
    property int    nThreads:        Settings.get(tNThreads,defNumThreads)
    property bool   showInfTime:     Settings.get(tShowInfTime,defShowInfTime) == 0 ? false : true
    property string resolution:      Settings.get(tResolution,defResolution)
    property bool   semiTransparent: Settings.get(tSemiTransparent,defSemiTransparent)
    property bool   showBackground:  Settings.get(tShowBackground,defShowBackground)

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    drawer.open()
                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.3
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Settings")
                width: parent.width
                onClicked: {
                    stackView.push(configuration)
                    drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: home
        anchors.fill: parent
    }

    Home{
        id: home
        visible: false
        minConfidence:   window.minConfidence
        nThreads:        window.nThreads
        showInfTime:     window.showInfTime
        resolution:      window.resolution
        semiTransparent: window.semiTransparent
        showBackground:  window.showBackground
    }

    Configuration{
        id: configuration
        visible: false

        minConfidence:   window.minConfidence
        nThreads:        window.nThreads
        showInfTime:     window.showInfTime
        resolution:      window.resolution
        resolutions:     home.resolutions
        semiTransparent: window.semiTransparent
        showBackground:  window.showBackground

        onMinConfidenceChanged:   {Settings.set(tMinConfidence,minConfidence); window.minConfidence = minConfidence }
        onNThreadsChanged:        {Settings.set(tNThreads,nThreads); window.nThreads = nThreads }
        onShowInfTimeChanged:     {Settings.set(tShowInfTime,showInfTime); window.showInfTime = showInfTime }
        onResolutionUpdated:      {Settings.set(tResolution,resolution); window.resolution = resolution}
        onSemiTransparentChanged: {Settings.set(tSemiTransparent,semiTransparent); window.semiTransparent = semiTransparent}
        onShowBackgroundChanged:  {Settings.set(tShowBackground,showBackground); window.showBackground = showBackground}
    }
}
