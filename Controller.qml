import QtQuick 2.0

Item {
    id: item
    property int value
    property string ctrlId
    property bool status: true

    onValueChanged: {
        var doc = new XMLHttpRequest();

        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                try {
                    var obj = JSON.parse(doc.responseText);
                    if(obj["result"] == "ok")
                    {
                        status = true
                    }
                }
                catch(e) {
                    console.warn("Failed parsing json")
                    status = false
                }
            }
        }
        doc.open("POST", "http://localhost:8085/Sensor?action=Set&id=%1&value=%2".arg(item.ctrlId).arg(item.value));
        doc.send();
    }
}
