import QtQuick 2.0
import XVideo 1.0
import QtQuick.Controls 1.4
Rectangle {

    signal doubleClick(bool isFullScreen);
    signal click();
    signal s_showToastMsg(string str)
    signal s_deleteObject()
    signal s_authenticationFailue(string str)

    property string mip: ""
    property string mport: ""
    property string mID: ""
    property string mAcc: ""
    property string mPwd: ""
    property bool mIsCreateConenect: false
    property bool mIsPlayAudio: false
    property bool mIsSelected: false
    property bool mIsRecordVedio: false

    property string shotScrennFilePath: ""
    property string recordingFilePath: ""


    property string belongDeviceName: ""

    border.color: mIsSelected?"#409EFF":"#00000000"
    border.width: 2


    onMIsCreateConenectChanged: {
        console.debug("onMXVideoIsCreateTcpConnectChanged   "+ mIsCreateConenect)
        if(mIsCreateConenect){
            video.sendAuthentication(mID,mAcc,mPwd);
            video.connectServer(mip,mport)
        }else{
            video.disConnectServer();
        }
    }

    onMIsPlayAudioChanged: video.funPlayAudio(mIsPlayAudio)
    onShotScrennFilePathChanged: video.funSetShotScrennFilePath(shotScrennFilePath);
    onRecordingFilePathChanged: video.funSetRecordingFilePath(recordingFilePath)

    XVideo{
        id:video
        anchors.fill: parent
        anchors.margins: 2

        property bool mXVideoPlayAudio: mIsPlayAudio
        property bool mXVideoRecordVedio: mIsRecordVedio
        property bool mXVideoIsCreateTcpConnect: mIsCreateConenect


        onSignal_authenticationFailue: {
            s_authenticationFailue(str)
        }

        onSignal_loginStatus: s_showToastMsg(msg);

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents:true

            onClicked: click();

            onDoubleClicked:doubleClick(true);

        }

        Image {
            id: img_delete
            x:parent.x + parent.width - img_delete.width

            visible:  (mIsCreateConenect && mIsSelected) ? true:false
            source: "qrc:/images/img_delete.png"

            MouseArea{
                anchors.fill: parent
                enabled: true

                onClicked: {

                    s_deleteObject();

                }

                onDoubleClicked: {
                    //console.debug("1000")
                }

            }
        }

        Rectangle{
            id:rectRecord
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            width: parent.width-8

            visible: (mIsCreateConenect&&parent.height > 5*50)?true:false
            opacity: 0

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered:
                    if(mIsSelected)
                        rectRecord.state = "show"
                onExited:
                    if(mIsSelected)
                        rectRecord.state = "hide"
            }

            states: [
                State {
                    name: "show"; PropertyChanges { target: rectRecord; opacity: 1 }
                },
                State {
                    name: "hide"; PropertyChanges { target: rectRecord;  opacity: 0 }
                }]

            transitions: Transition {
                PropertyAnimation  {properties: "opacity"; duration: 600; easing.type: Easing.Linear  }
            }

            BorderImage{

                id:btnstop

                width: 40
                height: 40
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/stop.png"

            }

            BorderImage{
                id:btnRecordVideo
                width: 34
                height: 34
                anchors.left: btnstop.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: mIsRecordVedio?"qrc:/images/recordVideo_ing.png":"qrc:/images/recordVideo_start.png"

                MouseArea{
                    anchors.fill: parent
                    enabled: true
                    onClicked:delayFun(500,recordBtnClickFun);
                }
            }

            BorderImage{
                id:btnScreenShot
                width: 34
                height: 34
                anchors.left: btnRecordVideo.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/screenshot.png"

                MouseArea{
                    anchors.fill: parent

                    enabled: true
                    onClicked: delayFun(100,screenShotBtnClick);
                }
            }
        }
        Rectangle{
            id:screenBlack
            anchors.fill: parent
            visible: mIsCreateConenect?false:true
            color: "#3A3D41"
        }

        Rectangle{
            id:screenShotMask
            anchors.fill: parent
            color: "white"
            opacity: 0

            SequentialAnimation {

                id:animationOpacity
                NumberAnimation { target: screenShotMask; property: "opacity"; to: 0.5; duration: 100 }
                NumberAnimation { target: screenShotMask; property: "opacity"; to: 0; duration: 100 }
            }
            function startAnimation(){
                animationOpacity.start();
            }
        }
    }

    function recVedio(h264,len){

        if(screenBlack.visible)
            screenBlack.visible = !screenBlack.visible

        video.funSendVideoData(h264,len)
    }


    Timer{
        id:delayTimer

        triggeredOnStart:false

        repeat:false

        function setTimeOut(delayTime,fun){
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(fun);
            timer.triggered.connect(function release(){
                timer.triggered.disconnect(fun);
                timer.triggered.disconnect(release);
            })
            timer.start();
        }
    }


    Connections{
        target: devicemanagerment
        onSignal_p2pCallbackVideoData: {

            //console.debug("belongDeviceName "+belongDeviceName)

            if(name === belongDeviceName){


                if(screenBlack.visible)
                    screenBlack.visible = !screenBlack.visible

                video.funSendVideoData(h264Arr,arrlen)

            }

        }

    }


    function delayFun(delay,fun1){


        delayTimer.setTimeOut(delay,fun1)

    }



    function recordBtnClickFun(){


        console.debug("recordBtnClickFun        ----"+mIsRecordVedio)
        if(!mIsRecordVedio){

            s_showToastMsg("start record");
            mIsRecordVedio = true;

        }else{
            s_showToastMsg("end record");
            mIsRecordVedio = false;

        }

        video.funRecordVedio(mIsRecordVedio);
    }

    function screenShotBtnClick(){

        screenShotMask.startAnimation();
        video.funScreenShot();
    }
}



