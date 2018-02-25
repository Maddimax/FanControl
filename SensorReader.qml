import QtQuick 2.0

Item {
    id: reader
    property var model
    property int updateInterval: 1000

    property real average
    property real integrated: average
    property real dropoff: 0.05

    function updateAverage() {
        var v = 0.0
        for(var i=0;i<sensorRepeater.count;i++) {
            v += sensorRepeater.itemAt(i).value
        }
        v /= sensorRepeater.count
        average = v;
        integrated = integrated*(1.0-dropoff) + average*dropoff
    }



    Timer {
        id: updateTimer
        interval: reader.updateInterval
        repeat: true
        running: true

        function createUpdate(item) {
            var doc = new XMLHttpRequest();

            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.DONE) {
                    try {
                        var obj = JSON.parse(doc.responseText);
                        if(obj["result"] == "ok")
                        {
                            var v = obj["value"]
                            item.value = parseFloat(v)

                        }
                    }
                    catch(e) {
                        console.warn("Failed parsing json")
                    }
                    numUpdates++;
                }

                if(numUpdates == sensorRepeater.count)
                {
                    reader.updateAverage()
                }

            }
            doc.open("POST", "http://localhost:8085/Sensor?action=Get&id=%1".arg(item.sId));
            doc.send();
        }

        property int numUpdates: 0

        onTriggered: {
            numUpdates = 0
            for(var i=0;i<sensorRepeater.count; i++) {
                createUpdate(sensorRepeater.itemAt(i))
            }
        }
    }

    Repeater {
        id: sensorRepeater
        model: reader.model
        Item {
            id: sensor
            property real value: 0.0
            property string sId: sensorId

        }
    }




}
