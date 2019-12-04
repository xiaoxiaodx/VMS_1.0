import QtQuick 2.0

import "../simpleControl"
Rectangle {
    id:root



    ListModel{
        id:channelModel
        Component.onCompleted: {

            channelModel.append({showStr:"0"})
            channelModel.append({showStr:"1"})
            channelModel.append({showStr:"2"})
            channelModel.append({showStr:"3"})

        }
    }

    ListModel{
        id:transcodingRateModel
        Component.onCompleted: {
            transcodingRateModel.append({showStr:"fixed rate"})
            transcodingRateModel.append({showStr:"variable rate"})
        }
    }

    ListModel{
        id:pictureQualityModel
        Component.onCompleted: {
            pictureQualityModel.append({showStr:"1"})
            pictureQualityModel.append({showStr:"2"})
            pictureQualityModel.append({showStr:"3"})
            pictureQualityModel.append({showStr:"4"})
            pictureQualityModel.append({showStr:"5"})
        }
    }
    ListModel{
        id:resolutionModel
        Component.onCompleted: {
            resolutionModel.append({showStr:"1920*1080"})
            resolutionModel.append({showStr:"640*360"})
            resolutionModel.append({showStr:"320*160"})

        }
    }
    ListModel{
        id:encodingTypeModel
        Component.onCompleted: {
            encodingTypeModel.append({showStr:"jpeg"})
            encodingTypeModel.append({showStr:"mpeg4"})
            encodingTypeModel.append({showStr:"h264"})
            encodingTypeModel.append({showStr:"h265"})

        }
    }
    ListModel{
        id:encodingStyleModel
        Component.onCompleted: {
            encodingStyleModel.append({showStr:"baseline"})
            encodingStyleModel.append({showStr:"main"})
            encodingStyleModel.append({showStr:"extended"})
            encodingStyleModel.append({showStr:"high"})

        }
    }
    ListModel{
        id:codestreamTypeModel
        Component.onCompleted: {
            codestreamTypeModel.append({showStr:"main stream"})
            codestreamTypeModel.append({showStr:"substream"})

        }
    }
    ListModel{
        id:audioencodeTypeModel
        Component.onCompleted: {
            audioencodeTypeModel.append({showStr:"g711a"})

        }
    }

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
            id:rectinputframeRate
            color: "transparent"
            width: 250
            height: inputframeRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtframeRate
                anchors.right: inputframeRate.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("frameRate:")
            }
            LineEdit {
                id: inputframeRate
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

        Rectangle{
            id:rectcodeRate
            color: "transparent"
            width: 250
            height: inputcodeRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtcodeRate
                anchors.right: inputcodeRate.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("codeRate:")
            }

            LineEdit {
                id: inputcodeRate
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

        Rectangle{
            id:rectpictureQuality
            color: "transparent"
            width: 250
            height: inputframeRate.height
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
                currentIndex: 0

            }

        }

        Rectangle{
            id:recttranscodingRate
            color: "transparent"
            width: 250
            height: transcodingRate.height
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
                model: transcodingRateModel

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
                anchors.right: inputframeInterval.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("frameInterval:")
            }

            LineEdit {
                id: inputframeInterval
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

        Rectangle{
            id:rectencodeType
            color: "transparent"
            width: 250
            height: inputframeRate.height
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
                model: encodingTypeModel

            }

        }

        Rectangle{
            id:rectencodeStyle
            color: "transparent"
            width: 250
            height: inputframeRate.height
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
                model: encodingStyleModel

            }

        }

        Rectangle{
            id:rectresolution
            color: "transparent"
            width: 250
            height: inputframeRate.height
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
                model: resolutionModel

            }

        }

        Rectangle{
            id:rectcodestreamType
            color: "transparent"
            width: 250
            height: inputframeRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtcodestreamType
                anchors.right: codestreamType.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("code stream type:")
            }

            MyComBox{
                id:codestreamType
                width: 184
                height: 34
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                itemColorHoverd: "#191919"
                font.pixelSize: 15
                model: codestreamTypeModel

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
                anchors.right: parent.right
                anchors.rightMargin: 194
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("enable:")
            }

            SwitchButton{
                id:audioEnable
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
            id:rectbiteRate
            color: "transparent"
            width: 250
            height: inputframeRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtbiteRate
                anchors.right: inputbiteRate.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("biteRate:")
            }

            LineEdit {
                id: inputbiteRate
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
                isNeedImg: false
            }

        }

        Rectangle{
            id:rectAudioencodeType
            color: "transparent"
            width: 250
            height: inputframeRate.height
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
                model: audioencodeTypeModel

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
            height: inputframeRate.height
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txtsample
                anchors.right: inputsample.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
                text: qsTr("sample:")
            }

            LineEdit {
                id: inputsample
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

        onSignal_videoencodeparam:{

            console.debug("onS_videoencodeparam * "+smap)
            console.debug("onS_videoencodeparam * "+smap.streamid)

            codestreamType.currentIndex = smap.streamid
            channel.currentIndex = smap.chn
            inputframeRate.text = smap.framerate
            inputcodeRate.text =smap.bitrate
            inputframeInterval.text = smap.gop


            if(smap.h264profile === "baseline")
                encodeStyle.currentIndex = 0
            else if(smap.h264profile === "main")
                encodeStyle.currentIndex = 1
            else if(smap.h264profile === "extended")
                encodeStyle.currentIndex = 2
            else if(smap.h264profile === "high")
                encodeStyle.currentIndex = 3



            if(smap.encoding === "jpeg")
                encodeType.currentIndex = 0
            else if(smap.encoding === "mpeg4")
                encodeType.currentIndex = 1
            else if(smap.encoding === "h264")
                encodeType.currentIndex = 2
            else if(smap.encoding === "h265")
                encodeType.currentIndex = 3

            if(smap.cvbrmode==="cbr")
                transcodingRate.currentIndex = 1
            else
                transcodingRate.currentIndex = 0

            pictureQuality.currentIndex = smap.quality
            if(smap.width === 1920)
                resolution.currentIndex = 0
            else if(smap.width === 640)
                resolution.currentIndex = 1
            else if(smap.width === 320)
                resolution.currentIndex = 2



            var objectDevice = listdeviceInfo.get(curSelectIndex)
            objectDevice.videoChn = smap.chn;
            objectDevice.videoStreamid = smap.streamid;
            objectDevice.videoFramerate = smap.framerate;
            objectDevice.videoBitrate = smap.bitrate;
            objectDevice.videoQuality = smap.quality;
            objectDevice.videoGop = smap.gop;
            objectDevice.videoCvbrmode = smap.cvbrmode;
            objectDevice.videoEncodetype = smap.encoding;

            objectDevice.videoEncodestyle = smap.h264profile;
            if(smap.width === 1920)
                objectDevice.videoResolution = 0
            else if(smap.width === 640)
                objectDevice.videoResolution = 1
            else if(smap.width === 320)
                objectDevice.videoResolution = 2

        }
        onSignal_audioencodeparam:{

            //                objectDevice.audioEnable = smap.enabled
            //                objectDevice.audioEncodetype = smap.encoding
            //                objectDevice.audioBitrate = smap.bitrate
            //                objectDevice.audioSamplerate = smap.samplerate

            console.debug(" onSignal_audioencodeparam***    "+ smap.enabled)
            if(smap.enabled>0)
                audioEnable.checked = true
            else
                audioEnable.checked = false
            inputsample.text = smap.samplerate
            inputbiteRate.text = smap.bitrate
            audioencodeType.currentIndex = 0


            var objectDevice = listdeviceInfo.get(curSelectIndex)
            objectDevice.audioEnable = smap.enabled
            objectDevice.audioEncodetype = smap.encoding
            objectDevice.audioBitrate = smap.bitrate
            objectDevice.audioSamplerate = smap.samplerate

        }


    }


    function getMediaVideoConfig(){

        var w,h;
        if(resolution.currentIndex === 0){w=1920;h=1080}
        else if (resolution.currentIndex===1){w=640;h=320;}
        else if (resolution.currentIndex===2){w=320;h=160;}
        var map={
            chn:channel.currentIndex,
            streamid:codestreamType.currentIndex,
            framerate:inputframeRate.text.toString(),
            bitrate:inputcodeRate.text.toString(),
            quality:pictureQuality.currentIndex,
            cvbrmode:transcodingRate.currentIndex,
            encoding:encodeType.currentText.toString(),
            h264profile:encodeStyle.currentText.toString(),
            width:w,
            height:h
        };
        return map;
    }



}
