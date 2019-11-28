import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import Qt.labs.platform 1.1

import QtQuick.LocalStorage 2.0 as Sql
import XVideo 1.0
import TimeLine 1.0


import "../liveVedio"
import "../simpleControl"
Rectangle {

    id:playbackvideo
    signal s_addDevice();
    signal st_showToastMsg(string str1);
    signal s_multiScreenNumChange(int num);

    property int multiScreenNum: 2
    property int premultiScreenNum: 2

    property int modelDataCurrentIndex: -1
    property int listDeviceCurrentIndex: -1

    property string shotScreenFilePath2: ""
    property string recordingFilePath2: ""

    property bool isMax: false

    Rectangle{

        id:leftContent
        anchors.top: parent.top
        anchors.left: parent.left
        width:300
        height: parent.height
        color: "#272727"
        Text {
            id: timelabel
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 17
            color: "white"
            font.pixelSize: 16
            text: qsTr("time")
        }


        Rectangle{
            id:timeRect
            anchors.top: timelabel.bottom
            anchors.topMargin: 20
            anchors.left: timelabel.left
            width: parent.width -32
            height: 32
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#3A3D41"
            Image {
                id: imgTimeSelect
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 15
                source: "qrc:/images/search.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        getRecordInfo(1,Qt.formatDate(calendar.getCurrentData(),"yyyyMMdd000000"));
                        calendar.open();
                    }
                }
            }

            Text{
                id:timeInput
                anchors.left: parent.left
                anchors.leftMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
            }

        }



        Text {
            id: mydevice

            anchors.left: timeRect.left
            anchors.top: timeRect.bottom
            anchors.topMargin: 20
            color: "white"
            font.family: "Microsoft Yahei"
            font.pixelSize: 16
            text: qsTr("my device")

        }




        Rectangle{
            id:searchDevice
            anchors.top: mydevice.bottom
            anchors.topMargin: 20
            width: parent.width -32
            height: 32
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#3A3D41"
            Image {
                id: imgSearch
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15
                source: "qrc:/images/search.png"
            }

            TextInput{
                id:inputSearch
                width: searchDevice.width - imgSearch.width - 15 -2
                height: 24
                anchors.left: imgSearch.right
                anchors.leftMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14


            }



        }



        ListView{
            id:listDevice
            width: parent.width -32
            height: parent.height - 90
            anchors.top: searchDevice.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 1

            model: listdeviceInfo//listdeviceInfo// mArea: model.devicename

            delegate:Rectangle{
                id:deviceItem
                width: parent.width
                height: 32
                color: "transparent"
                Text {
                    id: txtDevice
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    color: listDevice.currentIndex === index?"#409EFF":"white"
                    font.pixelSize: 12
                    text: devicename
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: deviceItem.color = Qt.rgba(0,0,0,87)

                    onExited:  deviceItem.color = "transparent"

                    onClicked: listDevice.currentIndex = index
                }

            }
        }



    }


    Rectangle{
        id:rightContent
        anchors.left: leftContent.right
        anchors.top: parent.top

        width: parent.width - leftContent.width
        height: parent.height

        color: "#131415"
        XVideo{
            id:video

            anchors.top: parent.top
            width:parent.width
            height: parent.height - videoControl.height-timeline.height
            Rectangle{
                id:screenBlack
                anchors.fill: parent

                color: "#3A3D41"
            }

        }
        Rectangle{
            id:videoControl
            width: parent.width
            height: 50
            anchors.top:video.bottom
            color: "#303030"
        }
        TimeLine{
            id:timeline
            width:parent.width
            height:50

            anchors.top:videoControl.bottom
        }


    }


    MyCalendar{
        id:calendar
        width: 280
        height: 314
        dim:false
        x:timeRect.x
        y:timeRect.y+timeRect.height
        onS_dayChange: getRecordInfo(2,value)

        onS_mouthChange:getRecordInfo(1,value)

        onS_yearChange: console.debug("onS_yearChange   "+value)



    }

    ListModel{
        id:calendarEventModel

        function getDateEvent(tmpData){

            var dayNum = Qt.formatDate(tmpData,"dd")-1
            //console.debug("getDateEvent:    "+dayNum + "  "+calendarEventModel.count+"  "+calendarEventModel.get(dayNum))


            if(calendarEventModel.count == 0)
                return "#191919"
            if(calendarEventModel.get(dayNum)=== undefined)
                return "#191919"

            if(calendarEventModel.get(dayNum).type==="1")
                return "#3A3D41";
            else if(calendarEventModel.get(dayNum).type==="2")
                return "#FFAA36"
            else if(calendarEventModel.get(dayNum).type==="0")
                return "#191919"

            return "#191919"
        }
    }
    Connections{
        target: devicemanagerment
        onSignal_getrecordinginfo:{



            if(smap.infoType==="hourInfo"){

                //发送给时间轴渲染
                timeline.setTimeWarn(smap);


            }else if(smap.infoType==="dayInfo"){


                var dayStr = Qt.formatDate(calendar.getCurrentData(),"yyyyMMdd");

                var listRecord = smap.data;

                for(var i=0;i<smap.data.length;i++){


                    if(listRecord[i] !== "0"){
                        var timeStr
                        if(i <10)
                            timeStr= dayStr + "0"+i+"0000";
                        else
                            timeStr= dayStr + i+"0000";

                        getRecordInfo(3,timeStr)
                    }

                }



            }
            else if(smap.infoType==="mounthInfo"){

                var listRecord = smap.data;
                for(var i=0;i<listRecord.length;i++){
                    calendarEventModel.append({type:listRecord[i]})
                }
            }

            calendarEventModel.append({});

        }
    }


    function getRecordInfo(type,date){

        if(listdeviceInfo.get(listDevice.currentIndex)===undefined || listdeviceInfo.get(listDevice.currentIndex).devicename === undefined){
            main.showToast("No device specified")
            return
        }


        var name = listdeviceInfo.get(listDevice.currentIndex).devicename


        console.debug("onS_mouthChange   "+type+"   "+date)

        var map = {method:type,time:date,msgid:date}

        calendarEventModel.clear();
        devicemanagerment.funP2pSendData(name,"getrecordinginfo",map)

    }




}



