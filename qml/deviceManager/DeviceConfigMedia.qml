import QtQuick 2.0

import "../simpleControl"
Rectangle {
    id:root


    property var channelModel: ["channel1", "channel1"]
    property var frameRatelModel: ["frameRate1", "frameRate2"]
    property var codeRateModel: ["codeRate1", "codeRate2"]
    property var pictureQualityModel: ["pictureQuality1", "pictureQuality2"]


    Text {
        id: txtLabel1
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 20
        font.pixelSize: 18
        color: "white"
        text: qsTr("Video")
    }

    Rectangle{
        id:splitline1
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: txtLabel1.bottom
        anchors.topMargin: 9
        width: 680
        height: 1
        color: "#616161"

    }

    Column{
        id:vedioLeft

        spacing: 10
        anchors.top: splitline1.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 80
        Rectangle{
            id:rectchannel

            height: channel.height
            width: 250
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtchannel
                anchors.right: channel.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("channel:")
            }

            MyComBox{
                id:channel
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
            id:rectframeRate
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtframeRate
                anchors.right: frameRate.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("frameRate:")
            }

            MyComBox{
                id:frameRate
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: frameRatelModel
            }

        }

        Rectangle{
            id:rectcodeRate
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtcodeRate
                anchors.right: codeRate.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("codeRate:")
            }

            MyComBox{
                id:codeRate
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: codeRateModel
            }

        }

        Rectangle{
            id:rectpictureQuality
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtpictureQuality
                anchors.right: pictureQuality.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("pictureQuality:")
            }

            MyComBox{
                id:pictureQuality
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: pictureQualityModel
            }

        }

        Rectangle{
            id:recttranscodingRate
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txttranscodingRate
                anchors.right: transcodingRate.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("transcodingRate:")
            }

            MyComBox{
                id:transcodingRate
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
        id:vedioRight

        spacing: 10
        anchors.top: splitline1.bottom
        anchors.topMargin: 20
        anchors.left: vedioLeft.right
        anchors.leftMargin: 80
        Rectangle{
            id:rectframeInterval

            height: channel.height
            width: 250
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtframeInterval
                anchors.right: frameInterval.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("frameInterval:")
            }

            MyComBox{
                id:frameInterval
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
            id:rectencodeType
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtencodeType
                anchors.right: encodeType.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("encodeType:")
            }

            MyComBox{
                id:encodeType
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: frameRatelModel
            }

        }

        Rectangle{
            id:rectencodeStyle
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtencodeStyle
                anchors.right: encodeStyle.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("encodeStyle:")
            }

            MyComBox{
                id:encodeStyle
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: codeRateModel
            }

        }

        Rectangle{
            id:rectresolution
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtresolution
                anchors.right: resolution.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("resolution:")
            }

            MyComBox{
                id:resolution
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: pictureQualityModel
            }

        }
    }



    Text {
        id: txtLabel2
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 314
        font.pixelSize: 18
        color: "white"
        text: qsTr("Audio")
    }

    Rectangle{
        id:splitline2
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: txtLabel2.bottom
        anchors.topMargin: 9
        width: 680
        height: 1
        color: "#616161"

    }


    Column{
        id:audioLeft

        spacing: 10
        anchors.top: splitline2.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 80
        Rectangle{
            id:rectenable

            height: channel.height
            width: 250
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtenable
                anchors.right: frameInterval.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("enable:")
            }

           QmlImageButton{
            id:btnenable

           }

        }

        Rectangle{
            id:rectbiteRate
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtbiteRate
                anchors.right: biteRate.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("biteRate:")
            }

            MyComBox{
                id:biteRate
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: frameRatelModel
            }

        }

        Rectangle{
            id:rectAudioencodeType
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtaudioencodeType
                anchors.right: audioencodeType.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("encodeType:")
            }

            MyComBox{
                id:audioencodeType
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: codeRateModel
            }

        }


    }


    Column{
        id:audioRight

        spacing: 10
        anchors.top: splitline2.bottom
        anchors.topMargin: 20
        anchors.left: audioLeft.right
        anchors.leftMargin: 80
        Rectangle{
            id:rectsample
             color: "transparent"
            width: 250
            height: frameRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtsample
                anchors.right: sample.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("sample:")
            }

            MyComBox{
                id:sample
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: codeRateModel
            }

        }
    }

}
