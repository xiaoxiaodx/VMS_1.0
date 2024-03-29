import QtQuick 2.0

import QtQuick.Controls 1.4

import "../simpleControl"
Rectangle {

    color: "red"


    property int curSelectIndex: -1
    Rectangle{

        id:rectLeft
        width: 300
        height: parent.height


        color: "#272727"
        Rectangle{
            id:leftHead
            width: parent.width
            height: 66
            color: "transparent"
            Image {
                id: img
                anchors.left: parent.left
                anchors.leftMargin: 17
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/device.png"
            }

            Text {
                id: txt
                text: qsTr("Device Manager")
                anchors.left: img.right
                anchors.leftMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
            }
            Rectangle{

                color: "#88000000"
                width: parent.width-32
                height: 37
                anchors.top: leftHead.bottom
                anchors.left: parent.left
                anchors.leftMargin: 16

                Text {
                    id: txt1
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 16
                    color: "white"
                    text: qsTr("device")
                }
            }
        }

    }


    Rectangle{
        id:content
        width: parent.width - rectLeft.width
        height: parent.height
        anchors.left: rectLeft.right
        anchors.top: parent.top

        color: "#383838"
        QmlTabBarButtonH{
            id:tabbarBtn
            height: 50
            btnBgColor:"transparent"
            btnBgSelectColor:"transparent"
            mflagColor:"#409EFF"
            textColor: "white"
            textSelectColor:"#409EFF"
            imageSrcEnter:"#333333"
            txtLeftMargin:24
            imageLeftMargin: 11
            textSize:18
            anchors.left: splitline.left
            anchors.bottom: splitline.top
            Component.onCompleted: {

                tabbarBtn.barModel.append({txtStr:qsTr("Device"),imgSrc:"qrc:/images/homemenuClos1e.png",imgSrcEnter:"qrc:/images/homem1enuClose.png"})
                tabbarBtn.barModel.append({txtStr:qsTr("Flow Media Services"),imgSrc:"qrc:/images/homemenuCl1ose.png",imgSrcEnter:"qrc:/images/hom1emenuClose.png"})

            }
        }

        Rectangle{
            id:btnDeviceAdd
            width: 66
            height: 30
            anchors.bottom: splitline.bottom
            anchors.bottomMargin: 6
            anchors.right: splitline.right
            color: "#409EFF"
            Image {
                id: btnImg
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/deviceAdd.png"
            }
            Text {
                id: btnTxt
                anchors.left: btnImg.right
                anchors.leftMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("add")
                font.pixelSize: 14
                color: "white"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: btnDeviceAdd.color = "#dd409EFF"
                onReleased:  btnDeviceAdd.color = "#409EFF"
                onClicked: deviceAdd.open()
            }

        }
        Rectangle{
            id:splitline
            width: tableView.width
            height: 1
            anchors.left: tableView.left
            color: "#303030"
            anchors.bottom: tableView.top
            anchors.bottomMargin: 10
        }

        DeviceTable{
            id:tableView
            frameVisible: true
            width: parent.width -170-30
            height:parent.height - 68 - 6
            anchors.top: parent.top
            anchors.topMargin: 68
            anchors.left: parent.left
            anchors.leftMargin: 30

            model: listdeviceInfo
            onSDeviceConfig:{
                curSelectIndex = configIndex
                deviceconfig.open()
                var map={};
                devicemanagerment.funP2pSendData(listdeviceInfo.get(configIndex).devicename,"getvideoencodeparam",map);
                devicemanagerment.funP2pSendData(listdeviceInfo.get(configIndex).devicename,"getaudioencodeparam",map);
                devicemanagerment.funP2pSendData(listdeviceInfo.get(configIndex).devicename,"getmotiondetectparam",map);
            }
        }

        Rectangle{
            color: "#00000000"
            anchors.fill: tableView
            border.width: 1
            border.color: "#383838"

        }


    }


    DeviceConfig{
        id:deviceconfig
        width: 900
        height: 640
    }



    DialogAddDevice{

        id:deviceAdd
        width: 525
        height: 434

        onS_deviceIDstr: devicemanagerment.funConnectP2pDevice(name, strID, strAccoount, strPassword)
    }



    Connections{
        target: devicemanagerment
        onSignal_p2pConnectCallback: {
            console.debug(name + "  **  "+ did + "  "+isSucc)

            var objectDevice = devicemanagerment.findDeviceByName(name);
            if(objectDevice === null){
                listdeviceInfo.append({
                                          devicename:name,
                                          devicedid:did,
                                          acc:acc,
                                          pwd:pwd,
                                          onlinestate:isSucc,
                                          devicetype:"undefine",
                                          showVidoIndex:-1,

                                          videoChn:0,
                                          videoStreamid:0,
                                          videoFramerate:0,
                                          videoBitRate:0,
                                          videoQuality:0,
                                          videoCvbrmode:0,
                                          videoGop:0,
                                          videoEncodetype:0,
                                          videoEncodestyle:0,
                                          videoResolution:0,

                                          audioEnable:0,
                                          audioEncodetype:0,
                                          audioBitrate:0,
                                          audioSamplerate:0,

                                          motionDetectionEnabled:0,
                                          motionDetectionSensitive:0,
                                          motionDetectionTimenabled:0,
                                          motionDetectionStarttime:0,
                                          motionDetectionEndtime:0,
                                      });
            }else
                objectDevice.onlinestate = isSucc

        }


    }

}
