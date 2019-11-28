import QtQuick 2.0
//import QtQuick.Controls 2.5
//import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import "../simpleControl"
Rectangle{
    id:rect


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
        width:350
        height: parent.height
        color: "#272727"


        Rectangle{
            id:deviceAdd
            width: parent.width
            height: 50
            color: "transparent"
            Image {
                id: imgDevice
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/mydevice.png"
            }


            Text {
                id: mydevice

                anchors.left: imgDevice.right
                anchors.leftMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment:Text.AlignVCenter
                color: "white"
                font.pixelSize: 16
                text: qsTr("My Device")

            }

        }


        Rectangle{
            id:searchDevice
            anchors.top: deviceAdd.bottom
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

            TextField{
                id:inputSearch
                width: searchDevice.width - imgSearch.width - 15 -2
                height: 24
                anchors.left: imgSearch.right
                anchors.leftMargin: 2
                anchors.verticalCenter: parent.verticalCenter

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                cursorPosition:10
                font.pixelSize: 14
                placeholderText:qsTr("search device id")
                style:TextFieldStyle {
                    textColor: "#909399"
                    background: Rectangle {
                        color: "transparent"
                        implicitWidth: 100
                        implicitHeight: 24
                        radius: 4
                    }
                }
            }

        }

//        ListModel{
//            id:listDeviceDid

//            Component.onCompleted: {

//                loadDeviceData();

//            }
//            Component.onDestruction: saveImageData()

//            function loadDeviceData() {
//                var db = Sql.LocalStorage.openDatabaseSync("MyDB", "1.0", "My model SQL", 50000);

//                //listDeviceDid.append({did:strID,account:strAcc,password:strPwd,ip:strIp,port:strPort});
//                db.transaction(
//                            function(tx) {
//                                // Create the database if it doesn't already exist
//                                tx.executeSql('CREATE TABLE IF NOT EXISTS DeviceInfoList(did TEXT, account TEXT,password TEXT, ip TEXT,port TEXT)');

//                                var rs = tx.executeSql('SELECT * FROM DeviceInfoList');
//                                var index = 0;
//                                if (rs.rows.length > 0) {
//                                    var index = 0;
//                                    while (index < rs.rows.length) {
//                                        var myItem = rs.rows.item(index);

//                                        addDevice(0,myItem.did,myItem.account,myItem.password,myItem.ip,myItem.port  )

//                                        index++;
//                                    }
//                                }
//                            }
//                            )
//            }
//            function saveImageData() {
//                var db = Sql.LocalStorage.openDatabaseSync("MyDB", "1.0", "My model SQL", 50000);
//                db.transaction(
//                            function(tx) {
//                                tx.executeSql('DROP TABLE DeviceInfoList');
//                                tx.executeSql('CREATE TABLE IF NOT EXISTS DeviceInfoList(did TEXT, account TEXT,password TEXT, ip TEXT,port TEXT)');
//                                var index = 0;
//                                while (index < listDeviceDid.count) {
//                                    var myItem = listDeviceDid.get(index);
//                                    console.debug(myItem.did +","+","+myItem.account+","+ myItem.password+","+myItem.ip+","+myItem.port)
//                                    tx.executeSql('INSERT INTO DeviceInfoList VALUES(?,?,?,?,?)', [myItem.did,myItem.account, myItem.password,myItem.ip,myItem.port]);
//                                    index++;
//                                }
//                            }
//                            )
//            }
//        }

        ListView{
            id:listDevice
            width: deviceAdd.width -32
            height: parent.height - 90
            anchors.top: searchDevice.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 1
            currentIndex: listDeviceCurrentIndex
            model: listdeviceInfo

            delegate: ListDeviceItem{

                backColor: index === listDeviceCurrentIndex?"#000000":"transparent"
                mDeviceID: "data.did"
                mArea: model.devicename
                color: "transparent"
                onDeleteClick: {

                    listDeviceDid.remove(index)

                    listDeviceDid.saveImageData();
                    for(var i=0;i<listDeviceDataModel.count;i++){
                        var curVideoItem = listDeviceDataModel.get(i);
                        if(curVideoItem.did === str){
                            curVideoItem.isCreateConnected = 0;
                            return
                        }
                    }
                }

                onDoubleClick: {


                    console.debug("qml:"+listdeviceInfo.count + "   "+index)

                    listdeviceInfo.get(index).showVidoIndex = modelDataCurrentIndex;

                    var map;
                    devicemanagerment.funP2pSendData(listdeviceInfo.get(index).devicename,"getVedio",map);


                }

            }
        }



        CloudControl{
            id:rectCloudControl
            width: parent.width
            height: 280
            anchors.bottom: cruiseControl.top
            color: "transparent"

            onSMoveUpPressed: {
                if(modelDataCurrentIndex > -1){

                    var map={ movecmd:"continuemove",direction:"up",speedx:200,speedy:0,speedz:0,posx:0,posy:0,posz:0}
                    devicemanagerment.funP2pSendData(listdeviceInfo.get(modelDataCurrentIndex).devicename,"setptzmove",map)
                }else
                    showToast(qsTr("Unspecified device"))
            }
            onSMoveUpReleased: {

                if(modelDataCurrentIndex > -1){

                    var map={ movecmd:"stop",direction:"up",speedx:200,speedy:0,speedz:0,posx:0,posy:0,posz:0}
                    devicemanagerment.funP2pSendData(listdeviceInfo.get(modelDataCurrentIndex).devicename,"setptzmove",map)

                }
            }

            onSMoveDownPressed: {
                if(modelDataCurrentIndex > -1){

                    var map={ movecmd:"continuemove",direction:"down",speedx:200,speedy:0,speedz:0,posx:0,posy:0,posz:0}
                    devicemanagerment.funP2pSendData(listdeviceInfo.get(modelDataCurrentIndex).devicename,"setptzmove",map)
                }else
                    showToast(qsTr("Unspecified device"))
            }
            onSMoveDownReleased: {
                if(modelDataCurrentIndex > -1){

                    var map={ movecmd:"stop",direction:"down",speedx:200,speedy:0,speedz:0,posx:0,posy:0,posz:0}
                    devicemanagerment.funP2pSendData(listdeviceInfo.get(modelDataCurrentIndex).devicename,"setptzmove",map)

                }
            }
            onSMoveLeftPressed: {
                if(modelDataCurrentIndex > -1){

                    var map={ movecmd:"continuemove",direction:"left",speedx:200,speedy:0,speedz:0,posx:0,posy:0,posz:0}
                    devicemanagerment.funP2pSendData(listdeviceInfo.get(modelDataCurrentIndex).devicename,"setptzmove",map)
                }else
                    showToast(qsTr("Unspecified device"))
            }
            onSMoveLeftReleased: {
                if(modelDataCurrentIndex > -1){

                    var map={ movecmd:"stop",direction:"left",speedx:200,speedy:0,speedz:0,posx:0,posy:0,posz:0}
                    devicemanagerment.funP2pSendData(listdeviceInfo.get(modelDataCurrentIndex).devicename,"setptzmove",map)

                }
            }
            onSMoveRightPressed: {
                if(modelDataCurrentIndex > -1){

                    var map={ movecmd:"continuemove",direction:"right",speedx:200,speedy:0,speedz:0,posx:0,posy:0,posz:0}
                    console.debug("modelDataCurrentIndex    "+modelDataCurrentIndex+"   listdeviceInfo.count:"+listdeviceInfo.count)

                    devicemanagerment.funP2pSendData(listdeviceInfo.get(modelDataCurrentIndex).devicename,"setptzmove",map)
                }else
                    showToast(qsTr("Unspecified device"))
            }
            onSMoveRightReleased: {
                if(modelDataCurrentIndex > -1){

                    var map={movecmd:"stop",direction:"right",speedx:200,speedy:0,speedz:0,posx:0,posy:0,posz:0}
                    devicemanagerment.funP2pSendData(listdeviceInfo.get(modelDataCurrentIndex).devicename,"setptzmove",map)

                }
            }


        }


        CruiseControl{
            id:cruiseControl

            width: parent.width
            height: 277
            anchors.bottom: parent.bottom
            color: "transparent"

        }

    }


    Rectangle{
        id:vedioContent
        anchors.left: leftContent.right
        anchors.top: parent.top
        width: parent.width - leftContent.width
        height: parent.height
        color: "#131415"
        VedioLayout{
            id: vedioLayout
            height: parent.height - mvideomultiWindow.height
            width: parent.width;

            myLayoutSquare:multiScreenNum

            myModel: listDeviceDataModel
            recordingFilePath1: recordingFilePath2
            shotScreenFilePath1: shotScreenFilePath2


            Component.onCompleted: {
                var listCount = listDeviceDataModel.count;
                var needCount = multiScreenNum*multiScreenNum;


                for(var i = listCount;i < needCount;i++){

                    listDeviceDataModel.append({did:"",account:"",password:"",ip:"",port:"",isCreateConnected:0,isMax:0});

                }

            }

            onS_click: modelDataCurrentIndex=clickIndex



            onS_doubleClick: {

                //console.debug("onS_doubleClick  " + multiScreenNum + "  "+premultiScreenNum + "  "+ismax)

                if(ismax > 0 ){

                    premultiScreenNum = multiScreenNum;
                    s_multiScreenNumChange(1)

                }else{

                    multiScreenNum = premultiScreenNum
                    s_multiScreenNumChange(premultiScreenNum)
                }
            }

            onS1_authenticationFailue: {

                for(var i=0;i<listDeviceDid.count;i++){

                    if(listDeviceDid.get(i).did == str)
                        listDeviceDid.remove(i)
                }

            }

        }

        VideoMultiWindow{

            id:mvideomultiWindow
            anchors.top:vedioLayout.bottom
            width: parent.width
            height: 50
            color: "#131415"
            onS_multiScreenNumChange: {

                console.debug("VideoMultiWindow "+num)
                if(num < 5)
                    setMultiScreenNum(num)

            }
        }


    }

    ListModel{
        id:listDeviceDataModel

    }


    function dispatchVedio(pos1,buff1,len1)
    {

        vedioLayout.dispatchVedioData(pos1,buff1,len1);

    }


    function openDlgFilePath(){
        myDlgfilePath.open();
    }

    function setMultiScreenNum(num){

        multiScreenNum = num;

        if(num > 1){

            for(var i=0;i<listDeviceDataModel.count;i++){

                if(listDeviceDataModel.get(i).isMax > 0){
                    listDeviceDataModel.get(i).isMax = 0;
                    break
                }

            }

        }
        for(var i= listDeviceDataModel.count ; i<=multiScreenNum*multiScreenNum;i++)
            listDeviceDataModel.append({did:"",account:"",password:"",ip:"",port:"",isCreateConnected:0,isMax:0});
    }

    function addDevice(isCreateTcpConnect,strID,strAcc,strPwd,strIp,strPort){

        if (strID == null || strID == undefined || strID == ""){

            st_showToastMsg(qsTr("add failed!  did is null"))

            return;
        }
        if (strAcc == null || strAcc == undefined || strAcc == ""){

            st_showToastMsg(qsTr("add failed!  account is null"))
            return;
        }
        if (strPwd == null || strPwd == undefined || strPwd == ""){

            st_showToastMsg(qsTr("add failed!  password is null"))
            return;
        }

        if (strIp == null || strIp == undefined || strIp == ""){

            st_showToastMsg(qsTr("add failed!   ip is null"))
            return;
        }

        if (strPort == null || strPort == undefined || strPort == ""){

            st_showToastMsg(qsTr("add failed!  port is null"))
            return;
        }

        //同一DID 不继续添加
        for(var i = 0;i<listDeviceDid.count;i++){

            if(listDeviceDid.get(i).did === strID){
                st_showToastMsg(qsTr("add failed! The current did already exists"))
                return;
            }
        }

        listDeviceDid.append({did:strID,account:strAcc,password:strPwd,ip:strIp,port:strPort});

        listDeviceDid.saveImageData();
    }

    function deleteDevice(tmpIndex){
        listDeviceDataModel.get(tmpIndex).isCreateConnected = 0;

    }



}
