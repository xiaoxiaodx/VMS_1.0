import QtQuick 2.0

Rectangle{
    property bool isDown : false
    property string mArea: ""
    property string mDeviceID: ""


    property color backColor: "#eeeeee"
    width: parent.width
    height: 42 + loadItem.height


    Rectangle{
        id:listHead
        width: parent.width
        height: 42

        color: backColor
        Text {
            id: txt
            anchors.left: parent.left
            anchors.leftMargin: 25
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 12
            text: qsTr(mArea)
        }

        Image {
            id: image
            width: 16
            height: 16
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            visible: false
            source: "qrc:/images/arrow.png"

            MouseArea{
                anchors.fill: parent

                hoverEnabled: true
                onEntered: image.source  = "qrc:/images/arrow_enter.png"
                onExited: image.source = "qrc:/images/arrow.png"

                onClicked:{
                    if (rotationAnimation.running === true)

                        return;

                    rotationAnimation.start();

                }
            }
        }


        RotationAnimation{
            id: rotationAnimation
            target: image
            from: 0
            to: 90
            duration: 100
            onStopped: {
                if (isDown === true)
                {
                    loadItem.sourceComponent = null;
                    rotationAnimation.from = 0;
                    rotationAnimation.to = 90;
                }
                else
                {
                    loadItem.sourceComponent = cptPicVideo;
                    rotationAnimation.from = 90;
                    rotationAnimation.to = 0;
                }
                isDown = !isDown;
            }
        }
    }

    Loader{
        id:loadItem
        anchors.top: listHead.bottom
        width: parent.width
        height: sourceComponent===null?0:183
        sourceComponent: null
    }

    Component{
        id:cptPicVideo

        Rectangle{
            id:cptsss
            height: picVideo.height + txt.height
            width: parent.wit
            color: backColor
            Image {
                id: picVideo
                width: 102
                height: 114
                anchors.left: parent.left
                anchors.leftMargin: 86
                anchors.top: parent.top
                anchors.topMargin: 14

                source: "qrc:/images/videoPic.png"
            }

            Rectangle{
                id:txt
                anchors.top: picVideo.bottom
                anchors.left: parent.left
                anchors.leftMargin: 25
                Text {
                    id: name1
                    text: qsTr("DeviceID:")
                }
                Text {
                    id: name2
                    anchors.left: name1.right
                    text: qsTr(mDeviceID)
                }

            }

        }
    }



}
