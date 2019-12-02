import QtQuick 2.0

Rectangle{



    signal sMoveLeftPressed();
    signal sMoveLeftReleased();
    signal sMoveRightPressed();
    signal sMoveRightReleased();
    signal sMoveUpPressed();
    signal sMoveUpReleased();
    signal sMoveDownPressed();
    signal sMoveDownReleased();
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
            height: 2
            color: "black"
            anchors.top: parent.top
            anchors.topMargin: 2
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
                onPressed:
                {
                    imgT.source = "qrc:/images/controlT_press.png"
                    sMoveUpPressed()
                }
                onReleased: {
                    imgT.source = "qrc:/images/controlT.png"
                    sMoveUpReleased()
                }

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
                onPressed:{

                    imgB.source = "qrc:/images/controlB_press.png";
                    sMoveDownPressed()
                }
                onReleased: {
                    sMoveDownReleased()
                    imgB.source = "qrc:/images/controlB.png"
                }
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
                onPressed:{
                    imgL.source = "qrc:/images/controlL_press.png"
                    sMoveLeftPressed()
                }
                onReleased:
                {
                    imgL.source = "qrc:/images/controlL.png"
                    sMoveLeftReleased()
                }
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
                onPressed:{
                    sMoveRightPressed()
                    imgR.source = "qrc:/images/controlR_press.png"
                }
                onReleased: {
                    sMoveRightReleased()
                    imgR.source = "qrc:/images/controlR.png"
                }

            }
        }

    }
}
