import QtQuick 2.0

Rectangle{



    signal sMoveLeft();
    signal sMoveRight();
    signal sMoveUp();
    signal sMoveDown();
    Rectangle{
        id:rectCloudControlHead
        color: "transparent"
        width: parent.width
        height: 46
        Image {
            id: imghead
            anchors.left: parent.left
            anchors.leftMargin: 19
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/cloudconsole.png"
        }

        Text {
            id: txtHead
            anchors.left: imghead.right
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 16
            color: "white"
            text: qsTr("Steering Control")
        }

        Rectangle{
            width: parent.width
            height: 1
            color: "transparent"
            anchors.top: parent.top
        }
        Rectangle{
            width: parent.width
            height: 1
            color: "transparent"
            anchors.bottom: parent.bottom
        }
    }

    Rectangle{


        width: parent.width
        height: parent.height - rectCloudControlHead.height
        anchors.top: rectCloudControlHead.bottom
        color: "transparent"
        Image {
            id: imgRadiu
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/controlRadius.png"
        }

        Rectangle{
            id:btnT
            width: imgT.width
            height: imgT.height
            color: "transparent"
            y:parent.height/2 - imgT.height/2 - 63
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: imgT
                source: "qrc:/images/controlT.png"
            }
            MouseArea{
                anchors.fill: parent
                onPressed:imgT.source = "qrc:/images/controlT_press.png"
                onReleased: imgT.source = "qrc:/images/controlT.png"
                onClicked: sMoveUp
            }
        }
        Rectangle{
            id:btnB
            width: imgB.width
            height: imgB.height
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            y:parent.height/2 - imgT.height/2 + 63
            Image {
                id: imgB
                source: "qrc:/images/controlB.png"
            }
            MouseArea{
                anchors.fill: parent
                onPressed:imgB.source = "qrc:/images/controlB_press.png"
                onReleased: imgB.source = "qrc:/images/controlB.png"
                onClicked: sMoveDown()
            }

        }
        Rectangle{
            id:btnL
            width: imgL.width
            height: imgL.height
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"
            x:parent.width/2 - imgT.width/2 - 63
            Image {
                id: imgL
                source: "qrc:/images/controlL.png"
            }
            MouseArea{
                anchors.fill: parent

                onPressed:imgL.source = "qrc:/images/controlL_press.png"
                onReleased: imgL.source = "qrc:/images/controlL.png"

                onClicked: sMoveLeft()

            }
        }
        Rectangle{
            id:btnR
            width: imgR.width
            height: imgR.height
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"
            x:parent.width/2 - imgT.width/2 + 63
            Image {
                id: imgR
                source: "qrc:/images/controlR.png"
            }
            MouseArea{
                anchors.fill: parent
                onPressed:imgR.source = "qrc:/images/controlR_press.png"
                onReleased: imgR.source = "qrc:/images/controlR.png"
                onClicked: sMoveRight()
            }
        }

    }
}
