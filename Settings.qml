import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {
    property var wnd

    Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("FanControl", "1.0", "Application Settings", 100);

        db.transaction(
                    function(tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(x INTEGER, y INTEGER)');
                        var r = tx.executeSql('SELECT * FROM Settings')
                        if(r.rows.length === 0) {
                            tx.executeSql('INSERT INTO Settings VALUES(?,?)', [wnd.x, wnd.y]);
                        }
                        else {
                            wnd.x = r.rows.item(0).x
                            wnd.y = r.rows.item(0).y
                        }
                    }
                    )
    }

    Component.onDestruction: {
        var db = LocalStorage.openDatabaseSync("FanControl", "1.0", "Application Settings", 100);

        db.transaction(
                    function(tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(x INTEGER, y INTEGER)');
                        tx.executeSql('UPDATE Settings SET x = ?, y = ?', [wnd.x, wnd.y])
                    }
                    )
    }
}
