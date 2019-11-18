import QtQuick 2.0

Rectangle {

    id:root


    signal selectIndex(var mindex);

    Rectangle{
        id:rectLable1
        width: parent.width - 200
        height: 48
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 41
        color: "#3A3D41"
        Text {
            id: label1
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 20
            color: "white"

            font.bold: true
            text: qsTr("Vedio")
        }
    }

    Row{
        id:veidoRow
        height: 100
        width: rectLable1.width - 100
        spacing:100
        anchors.top: rectLable1.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: rectLable1.horizontalCenter


        Rectangle{
            width: 80
            height: 86
            color: "transparent"
            Image {
                id: img1
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/images/vedioManager.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: selectIndex(0);
                }
            }
            Text {
                id: name1

                anchors.top: img1.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16

                color: "white"
                text: qsTr("video manager")
            }
        }


        Rectangle{
            width: 80
            height: 86
            color: "transparent"
            Image {
                id: img2
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/images/playback.png"

                MouseArea{
                    anchors.fill: parent
                    onClicked: selectIndex(1);
                }
            }
            Text {
                id: name2

                anchors.top: img2.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16

                color: "white"
                text: qsTr("play back")
            }
        }
    }

    Rectangle{
        id:splitline
        width: parent.width
        height: 1
        color: "black"


        anchors.verticalCenter: parent.verticalCenter

    }


    Text {
        id: label2

        anchors.top: splitline.bottom
        anchors.topMargin: 40
        anchors.left: rectLable1.left
        font.pixelSize: 20
        font.bold: true
        color: "white"
        text: qsTr("Maintain Manager")
    }


    Row{
        id:maintainRow
        height: 100

        spacing:100
        anchors.top: label2.bottom
        anchors.topMargin: 40
        anchors.left: label2.left
        anchors.leftMargin: 55


        Rectangle{
            width: 80
            height: 86
            color: "transparent"
            Image {
                id: img3
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/images/deviceManager.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: selectIndex(2);
                }
            }
            Text {
                id: name3

                anchors.top: img3.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("device manager")
            }
        }


        Rectangle{
            width: 80
            height: 86
            color: "transparent"
            Image {
                id: img4
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/images/sysConfig.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: selectIndex(3);
                }
            }
            Text {
                id: name4

                anchors.top: img4.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16

                color: "white"
                text: qsTr("system config")
            }
        }
    }

}
