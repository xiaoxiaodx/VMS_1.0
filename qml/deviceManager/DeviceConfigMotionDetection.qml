import QtQuick 2.0

import "../simpleControl"
Rectangle {
    id:root





    property var channelModel: ["channel1", "channel1"]
    property var frameRatelModel: ["frameRate1", "frameRate2"]
    property var codeRateModel: ["codeRate1", "codeRate2"]
    property var pictureQualityModel: ["pictureQuality1", "pictureQuality2"]




    Column{
        id:contentLeft

        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 80
        Rectangle{
            id:rectsensitivity

            height: sensitivity.height
            width: 250
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtsensitivity
                anchors.right: sensitivity.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("sensitivity:")
            }

            MyComBox{
                id:sensitivity
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: channelModel
            }

        }

        Rectangle{
            id:recttime
            color: "transparent"
            width: 250
            height: time.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txttime
                anchors.right: time.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("time:")
            }

            MyComBox{
                id:time
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: frameRatelModel
            }

        }



    }


    Column{
        id:contentRight

        spacing: 10
        anchors.top: contentLeft.top
        anchors.left: contentLeft.right
        anchors.leftMargin: 80
        Rectangle{
            id:rectstartTime

            height: startTime.height
            width: 250
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtstartTime
                anchors.right: startTime.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("startTime:")
            }

            MyComBox{
                id:startTime
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: channelModel
            }

        }

        Rectangle{
            id:rectendTime
            color: "transparent"
            width: 250
            height: endTime.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtendTime
                anchors.right: endTime.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("endTime:")
            }

            MyComBox{
                id:endTime
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: frameRatelModel
            }

        }



    }



}
