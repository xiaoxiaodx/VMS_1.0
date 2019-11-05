import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import Qt.labs.platform 1.1

import QtQuick.LocalStorage 2.0 as Sql


Rectangle {

    signal s_addDevice();
    signal st_showToastMsg(string str1);
    signal s_multiScreenNumChange(int num);

    signal s_mqttLoginSucc();
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
        color: "#FAFAFA"
        z:3

        Rectangle{
            id:deviceAdd
            width: parent.width-1
            height: 57
            z:1
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#FAFAFA"
            Text {
                id: mydevice
                width: 72
                height: 25
                anchors.left: parent.left
                anchors.leftMargin: 25
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment:Text.AlignVCenter
                color: "#4A4A4A"
                font.bold: true
                font.pixelSize: 18
                text: qsTr("My Device")

            }
            QmlImageButton{

                width:26
                height:26
                anchors.right: parent.right
                anchors.rightMargin: 26

                anchors.verticalCenter: parent.verticalCenter
                imgSourseHover: "qrc:/images/add_enter.png"
                imgSourseNormal: "qrc:/images/add.png"
                imgSoursePress: "qrc:/images/add_enter.png"

                onClick: {

                    s_addDevice();
                }
            }
        }


        Rectangle{
            id:searchDevice
            anchors.top: deviceAdd.bottom
            width:deviceAdd.width
            height: 30

            Image {
                id: imgSearch
                width: 26
                height: 28
                anchors.left: parent.left
                anchors.leftMargin: 15
                source: "qrc:/images/search.png"
            }

            TextField{
                id:inputSearch
                width: 168
                height: 24

                anchors.left: imgSearch.right
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter


                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                cursorPosition:10


                font.pixelSize: 14
                placeholderText:qsTr("search device id")

                style:TextFieldStyle {
                    textColor: "black"
                    background: Rectangle {
                        radius: 12
                        implicitWidth: 100
                        implicitHeight: 24
                        border.color: "#aaa"
                        border.width: 1
                    }
                }
            }
        }

        ListModel{
            id:listDeviceDid

            Component.onCompleted: {

                loadDeviceData();

            }
            Component.onDestruction: saveImageData()

            function loadDeviceData() {
                var db = Sql.LocalStorage.openDatabaseSync("MyDB", "1.0", "My model SQL", 50000);

                //listDeviceDid.append({did:strID,account:strAcc,password:strPwd,ip:strIp,port:strPort});
                db.transaction(
                            function(tx) {
                                // Create the database if it doesn't already exist
                                tx.executeSql('CREATE TABLE IF NOT EXISTS DeviceInfoList(did TEXT, account TEXT,password TEXT, ip TEXT,port TEXT)');

                                var rs = tx.executeSql('SELECT * FROM DeviceInfoList');
                                var index = 0;
                                if (rs.rows.length > 0) {
                                    var index = 0;
                                    while (index < rs.rows.length) {
                                        var myItem = rs.rows.item(index);

                                        addDevice(0,myItem.did,myItem.account,myItem.password,myItem.ip,myItem.port  )

                                        index++;
                                    }
                                }
                            }
                            )
            }

            function saveImageData() {

                var db = Sql.LocalStorage.openDatabaseSync("MyDB", "1.0", "My model SQL", 50000);


                db.transaction(
                            function(tx) {
                                tx.executeSql('DROP TABLE DeviceInfoList');
                                tx.executeSql('CREATE TABLE IF NOT EXISTS DeviceInfoList(did TEXT, account TEXT,password TEXT, ip TEXT,port TEXT)');
                                var index = 0;


                                while (index < listDeviceDid.count) {
                                    var myItem = listDeviceDid.get(index);


                                    console.debug(myItem.did +","+","+myItem.account+","+ myItem.password+","+myItem.ip+","+myItem.port)
                                    tx.executeSql('INSERT INTO DeviceInfoList VALUES(?,?,?,?,?)', [myItem.did,myItem.account, myItem.password,myItem.ip,myItem.port]);
                                    index++;
                                }
                            }
                            )
            }

        }

        ListView{
            id:listDevice
            width: deviceAdd.width
            height: parent.height - 90
            anchors.top: searchDevice.bottom
            anchors.topMargin: 10
            spacing: 1
            currentIndex: listDeviceCurrentIndex
            z:0
            model: listDeviceDid

            delegate: ListDeviceItem{

                backColor: index === listDeviceCurrentIndex?"#dedede":"#eeeeee"
                mDeviceID: did
                mArea: did

                onDeleteClick: {

                    listDeviceDid.remove(index)

                    for(var i=0;i<listDeviceDataModel.count;i++){
                        var curVideoItem = listDeviceDataModel.get(i);
                        if(curVideoItem.did === str){
                            curVideoItem.isCreateConnected = 0;
                            return
                        }
                    }
                }

                onDoubleClick: {
                    if(modelDataCurrentIndex >= 0 && (index != listDeviceCurrentIndex)){

                        var curVideoItem = listDeviceDataModel.get(modelDataCurrentIndex);

                        if(curVideoItem.did === did){
                            if(curVideoItem.isCreateConnected === 0)
                                curVideoItem.isCreateConnected = 1;

                        }else{
                            curVideoItem.isCreateConnected = 0
                            curVideoItem.did = did;
                            curVideoItem.account = account
                            curVideoItem.password = password
                            curVideoItem.ip = ip
                            curVideoItem.port = port
                            curVideoItem.isCreateConnected = 1

                        }
                    }
                }

            }
        }
    }


    Rectangle{
        id:vedioContent
        anchors.left: leftContent.right
        anchors.top: parent.top
        width: parent.width - leftContent.width
        height: parent.height

        color: "#BDBDBD"
        Rectangle{
            id:rectBar
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width
            height: 54
            color: "white"
            z:1

            Text {
                id: labelVideo
                anchors.left: parent.left
                anchors.leftMargin: 100
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: TextInput.AlignVCenter
                width: 72
                height: 25
                color: "#476BFD"
                font.pixelSize: 18
                font.bold: true
                text: qsTr("Live Video")
            }
        }

        VedioLayout{
            id: vedioLayout
            height: parent.height - rectBar.height-2
            width: parent.width;
            anchors.top: rectBar.bottom
            anchors.topMargin: 2

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

            onS_click: {

                modelDataCurrentIndex=clickIndex

            }

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
    }

    ListModel{
        id:listDeviceDataModel

    }

    QmlFilePathSet{
        id: myDlgfilePath
        onS_fiPath: {
            recordingFilePath2 = recordingPath
            shotScreenFilePath2 = shotScreenPath

        }

        onS_showToast: {

        }
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



