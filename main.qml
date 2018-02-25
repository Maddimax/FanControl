import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


ApplicationWindow {
    id: appWindow
    visible: true
    width: 500
    height: 70
    //visibility: ApplicationWindow.Hidden
    //flags: Qt.Window | Qt.FramelessWindowHint
    x: 100
    y: 100

    Settings {
        wnd: appWindow
    }

    signal trayActivation()

    //onActiveChanged: {
    //    if(!active)
    //        hide();
    //}

    Connections {
        target: ShowAction
        onTriggered: {
            show()
            raise()
            requestActivate()
        }
    }

    onClosing: {
        hide()
        close.accepted = false
    }

    Item {
        focus: true

        Keys.onEscapePressed: {
            hide()
        }

        Component.onCompleted: forceActiveFocus()
    }

    ListModel {
        id: cpuSensors
        ListElement {
            sensorId: "/intelcpu/0/temperature/0"
        }
        ListElement {
            sensorId: "/intelcpu/0/temperature/1"
        }
        ListElement {
            sensorId: "/intelcpu/0/temperature/2"
        }
        ListElement {
            sensorId: "/intelcpu/0/temperature/3"
        }
        ListElement {
            sensorId: "/intelcpu/0/temperature/4"
        }
        ListElement {
            sensorId: "/intelcpu/0/temperature/5"
        }
    }

    ListModel {
        id: gpuSensors
        ListElement {
            sensorId: "/nvidiagpu/0/temperature/0"
        }
    }

    ListModel {
        id: sensorListModel
        Component.onCompleted: {
            append( {"title": "CPU", "sensors" : cpuSensors, "fanctrl" : "/lpc/it8686e/control/3"} );
            append( {"title": "GPU", "sensors" : gpuSensors, "fanctrl" : "/lpc/it8686e/control/0"} );
        }
    }

    Rectangle {
        color: "#fdfdfd"
        anchors.fill: parent
    }

    ListView {
        id: sensorList
        model: sensorListModel
        anchors.fill: parent
        anchors.margins: 2
        property int itemHeight: height / 2
        delegate: Item {
            width: appWindow.width
            height: sensorList.itemHeight

            Text {
                id: titleText
                font.pixelSize: sensorList.itemHeight - 5
                text: title
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                anchors.fill: parent
                anchors.topMargin: 2
                anchors.bottomMargin: 2
                anchors.leftMargin: titleText.implicitWidth + 5

/*                Rectangle {
                    color: "black"
                    opacity: 1.0
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    anchors.bottomMargin: 2
                    anchors.topMargin: 2
                    width: (parent.width*(sensorReader.integrated/100.0))
                }
*/

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    property real h: Math.min(0.333, Math.max(0.0, 0.333*(1.0-((sensorReader.average-20)/100.0)*2.0)));
                    color: Qt.hsla(h, 0.75, 0.5, 1.0)
                    opacity: 1.0

                    width: (parent.width*(sensorReader.average/100.0))
                }

                Marker {
                    x: (parent.width*(sensorReader.integrated/100.0)) - (width/2)
                    anchors.bottom: parent.bottom
                    width: sensorList.itemHeight / 3.1
                    height: width
                    c: "black"
                    opacity: 0.5
                }

                Marker {
                    x: (parent.width*(sensorReader.integrated/100.0)) - (width/2)
                    anchors.top: parent.top
                    rotation: 180
                    width: sensorList.itemHeight / 3.1
                    height: width
                    c: "black"
                    opacity: 0.5
                }

            }

            Text {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: sensorList.itemHeight / 10
                font.pixelSize: sensorList.itemHeight / 2 - (sensorList.itemHeight/10)
                text: parseInt(sensorReader.average*100)/100 + "°"
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: sensorList.itemHeight / 10
                font.pixelSize: sensorList.itemHeight / 2 - (sensorList.itemHeight/10)
                text: controller.status == true ? (parseInt(controller.value*100)/100 + "%") : ("FAIL")
            }

            SensorReader {
                id: sensorReader
                model: sensors
            }

            Controller {
                id: controller
                ctrlId: fanctrl
                value: sensorReader.integrated
            }
        }
    }

}
