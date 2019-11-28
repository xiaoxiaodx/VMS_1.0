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

            Text {
                id: sensitivity
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: "white"

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

            Text {
                id: time
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: "white"

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

            Text {
                id: startTime
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: "white"

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

            Text {
                id:endTime
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: "white"

            }

        }



    }


    Connections{
            target: devicemanagerment;

//            objectDevice.motionDetectionEnabled = smap.enabled
//            objectDevice.motionDetectionSensitive = smap.sensitive
//            objectDevice.motionDetectionTimenabled = smap.enabled
//            objectDevice.motionDetectionStarttime = smap.starttime
//            objectDevice.motionDetectionEndtime = smap.endtime

            onSignal_motiondetectparam: {
                sensitivity.text = smap.sensitive
                startTime.text = smap.starttime
                endTime.text = smap.endtime


                 var objectDevice = listdeviceInfo.get(curSelectIndex)
                objectDevice.motionDetectionEnabled = smap.enabled
                objectDevice.motionDetectionSensitive = smap.sensitive
                objectDevice.motionDetectionTimenabled = smap.enabled
                objectDevice.motionDetectionStarttime = smap.starttime
                objectDevice.motionDetectionEndtime = smap.endtime
            }
        }

}
