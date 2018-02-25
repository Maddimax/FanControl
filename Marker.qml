import QtQuick 2.0

Canvas {
    id:canvas
    property color c: Qt.rgba(1.0, 0.0, 0.0, 1.0)
    onCChanged: { requestPaint() }
    onWidthChanged: { requestPaint() }
    onPaint:{
        var ctx = canvas.getContext('2d');
        ctx.reset()
        ctx.clearRect(0,0, width, height)

        ctx.moveTo(width/2, 0)
        ctx.lineTo(0, height)
        ctx.lineTo(width, height)
        ctx.closePath()

        ctx.fillStyle = c
        ctx.fill()
    }
}
