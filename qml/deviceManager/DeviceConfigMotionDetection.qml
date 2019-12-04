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
            id:rectenable
            height: 34
            width: 250
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtenable
                anchors.right: parent.right
                anchors.rightMargin: 194
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("enable:")
            }

            SwitchButton{
                id:motionEnable
                width: 50
                height: 25
                anchors.left: txtenable.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                bgColor: "#409EFF"
                onCheckedChange: console.debug("SwitchButton    "+checked)
            }


        }



        Rectangle{
            id:recttime
            color: "transparent"
            width: 250
            height: 34
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txttime
                anchors.right: parent.right
                anchors.rightMargin: 194
                anchors.verticalCenter:  parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("time enable:")
            }

            SwitchButton {
                id: timeenable
                width: 50
                height: 25
                anchors.left: txttime.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                bgColor: "#409EFF"
                onCheckedChange: console.debug("SwitchButton    "+checked)

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

            LineEdit {
                id: sensitivity
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                border.width: 0
                font.pixelSize: 14
                placeholderText: ""
                isNeedDoubleClickEdit: false
                textLeftPadding:0
                color: "#272727"
                text: "000000"
            }

        }

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

            LineEdit {
                id: startTime
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                border.width: 0
                font.pixelSize: 14
                placeholderText: ""
                isNeedDoubleClickEdit: false
                textLeftPadding:0
                color: "#272727"
                text: "000000"

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

            LineEdit {
                id:endTime
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                border.width: 0
                font.pixelSize: 14
                placeholderText: ""
                isNeedDoubleClickEdit: false
                textLeftPadding:0
                color: "#272727"

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

            console.debug("onSignal_motiondetectparam   "+ smap.enable+"   "+ smap.sensitive+"   "+ smap.enabled+"   "+ smap.starttime+"   "+smap.endtime)
            sensitivity.text = smap.sensitive
            if(smap.enable > 0)
                motionEnable.checked = true
            else
                motionEnable.checked = false

            if(smap.enabled > 0)
                timeenable.checked = true;
            else
                timeenable.checked = false;

            startTime.text =  smap.starttime
            endTime.text = smap.endtime



            var objectDevice = listdeviceInfo.get(curSelectIndex)
            objectDevice.motionDetectionEnabled = smap.enable
            objectDevice.motionDetectionSensitive = smap.sensitive
            objectDevice.motionDetectionTimenabled = smap.enabled
            objectDevice.motionDetectionStarttime = smap.starttime
            objectDevice.motionDetectionEndtime = smap.endtime
        }
    }

    function getMotionDetectionConfig(){
        var map={
            enable:motionEnable.checked,
            enabled:timeenable.checked,
            starttime:startTime.text.toString(),
            endtime:endTime.text.toString(),
            sensitive:sensitivity.text.toString()
        };
        return map;

    }
}
