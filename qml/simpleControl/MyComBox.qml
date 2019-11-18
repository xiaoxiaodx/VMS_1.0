
import QtQuick 2.12
import QtQuick.Controls 2.12

ComboBox {
    id: control
    model: ["TCP", "P2P"]

    property string colorNor: "#999999"
    property string colorPressed: "#409EFF"
    property string fontColor: "#BABABA"
    property string bordColor: "#476BFD"
    property int mRadius: 2
    property int indicatorW: 12
    property int indicatorH: 8
    delegate: ItemDelegate {
        width: control.width
        contentItem: Text {
            text: modelData
            color: fontColor
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: control.highlightedIndex === index
        background: Rectangle{
            width: parent.width
            height: parent.height
            color: "#272727"
        }
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: indicatorW
        height: indicatorH
        contextType: "2d"

        Connections {
            target: control
            onPressedChanged: canvas.requestPaint()
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = control.pressed ? colorPressed :colorNor;
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 20
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: colorNor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        border.color: control.pressed ? colorPressed : colorNor
        border.width: control.visualFocus ? 2 : 1
        color: "transparent"
        radius: 2
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {

            border.color: bordColor
            radius: mRadius
        }
    }
}
