import QtQuick 2.0

Rectangle{
    property bool isDown : false
    property string mArea: ""
    property string mDeviceID: ""


    property color backColor: "#eeeeee"
    width: parent.width
    height: listHead.height + loadItem.height

    signal deleteClick(string str);
    signal doubleClick();

    Rectangle{
        id:listHead
        width: parent.width
        height: 32

        MouseArea{
            anchors.fill: parent

            onDoubleClicked:doubleClick()


        }
        color: backColor
        Text {
            id: txt
            anchors.left: parent.left
            anchors.leftMargin: 25
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pointSize: 12
            text: qsTr(mArea)
        }


        Image {
            id: image
            width: 16
            height: 16
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            visible: false
            source: "qrc:/images/img_delete.png"

            MouseArea{
                anchors.fill: parent

                hoverEnabled: true

                onClicked:{

                    deleteClick(mDeviceID)
                }
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
