import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import Qt.labs.platform 1.1

import QtQuick.LocalStorage 2.0 as Sql




//备份  2019 10 16------添加完设备后自动显示界面

Rectangle {


    signal s_addDevice();
    signal st_showToastMsg(string str1);
    signal s_multiScreenNumChange(int num);

    property int multiScreenNum: 2
    property int premultiScreenNum: 2

    property int modelDataCurrentIndex: 0

    property int preMaxIndex: 0//最大化前，该视频对应的索引位置，0表示第一个
    property int preMaxmultiScreenNum: 2//最大化之前，该流对应的索引位置，0表示第一个

    property bool isMax: false

    onMultiScreenNumChanged: {

        console.debug("home content 屏幕发生变化:"+multiScreenNum)
        s_multiScreenNumChange(multiScreenNum);


        if(multiScreenNum == 1){//屏幕为1时代表  屏幕最大化

            isMax = true;
            vedioWindowMax(modelDataCurrentIndex,premultiScreenNum)

        }else{

            if(isMax){
                isMax = false;
                vedioWindowRestore(preMaxIndex,preMaxmultiScreenNum)
            }

        }
        premultiScreenNum = multiScreenNum;

        for(var i= listDeviceDataModel.count ; i<=multiScreenNum*multiScreenNum;i++)
            addDevice(0,"***"+i+1,"***","***","***","***");
    }


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

        }

        ListView{
            id:listDevice
            width: deviceAdd.width
            height: parent.height - 90
            anchors.top: searchDevice.bottom
            anchors.topMargin: 10
            spacing: 1
            currentIndex: modelDataCurrentIndex
            z:0
            model: listDeviceDid

            delegate: ListDeviceItem{

                backColor: index === modelDataCurrentIndex?"#dedede":"#eeeeee"
                mDeviceID: did
                mArea: did

                MouseArea{

                    anchors.fill: parent

                    onDoubleClicked: {

                        if(modelDataCurrentIndex >= 0 && (index != modelDataCurrentIndex)){

                            console.debug("modelDataCurrentIndex  "+modelDataCurrentIndex+" index   "+index);

                            var minIndex ;
                            var maxIndex ;

                            if(modelDataCurrentIndex > index){
                                maxIndex = modelDataCurrentIndex;
                                minIndex = index;
                            }else{
                                maxIndex = index;
                                minIndex = modelDataCurrentIndex;
                            }

                            listDeviceDid.move(minIndex,maxIndex,1);
                            listDeviceDid.move(maxIndex-1,minIndex,1);

                            //交换位置
                            var strDid1 = listDeviceDid.get(minIndex).did
                            var strDid2 = listDeviceDid.get(maxIndex).did

                            var tmpIndex1 = -1;
                            var tmpIndex2 = -1;

                            for(var tmpindex = 0;tmpindex < listDeviceDataModel.count;tmpindex++){
                                if(listDeviceDataModel.get(tmpindex).did === strDid1 ){
                                    tmpIndex1 = tmpindex;
                                    break;
                                }
                            }
                            for(tmpindex = 0;tmpindex < listDeviceDataModel.count;tmpindex++){
                                if(listDeviceDataModel.get(tmpindex).did === strDid2 ){
                                    tmpIndex2 = tmpindex;
                                    break;
                                }
                            }
                            console.debug("`````````````````    "+tmpIndex1 + " "+tmpIndex2 + " "+listDeviceDataModel.count)

                            listDeviceDataModel.move(tmpIndex2,tmpIndex1,1);
                            listDeviceDataModel.move(tmpIndex1-1,tmpIndex2,1);

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

        Rectangle {
            id: view
            height: parent.height - rectBar.height-2
            width: parent.width;
            anchors.top: rectBar.bottom
            anchors.topMargin: 2
          //  currentIndex: 1
            z:0
            Rectangle{
                id:rect
                 //color: "blue"
                color: "#00000000"

                width: parent.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                GridView{
                    id: touchPad
                    z:1

                    anchors.fill: parent
                    cacheBuffer: 0

                    objectName: "listDeviceDataModel"
                    model: listDeviceDataModel //objectlist model
                    cellWidth: (parent.width )/multiScreenNum
                    cellHeight:(parent.height )/multiScreenNum
                    //                        move: Transition {
                    //                            NumberAnimation { properties: "x,y"; duration: 500 }
                    //                        }
                    //                    moveDisplaced: Transition {
                    //                                            NumberAnimation { properties: "x,y"; from: 0; duration: 300 }
                    //                                        }

                    delegate:
                        VideoLivePlay{
                        id:video
                        z:3
                        width: touchPad.cellWidth
                        height: touchPad.cellHeight

                        color: "black"
                        mip:ip
                        mport:port
                        mID:did
                        mAcc:account
                        mPwd:password
                        mIsPlayAudio:(index===0 && multiScreenNum===1)?true:false
                        mIsCreateConenect:isCreateConnected>0?true:false

                        mIsSelected: index === modelDataCurrentIndex

                        onClick:  modelDataCurrentIndex = index

                        onDoubleClick: {


                            console.debug("onDoubleClick    "+multiScreenNum)
                            if(multiScreenNum != 1)
                                multiScreenNum = 1;
                            else
                                multiScreenNum = preMaxmultiScreenNum


                        }

                        onS_showToastMsg:st_showToastMsg(str)

                        onS_deleteObject:deleteDevice(index)
                    }

                }

                MouseArea{
                    id:mouse
                    anchors.fill: parent

                    propagateComposedEvents: true

                    enabled: true

                    onWheel: {
                    }

                    z:2
                }
            }
        }
    }

    ListModel{
        id:listDeviceDataModel

        Component.onCompleted: {

            loadDeviceData()

            var listCount = listDeviceDataModel.count;
            var needCount = multiScreenNum*multiScreenNum;


            if(listCount < needCount){

                for(var i = 0;i<(needCount-listCount);i++)
                    addDevice(0,"***"+listCount+i+1,"***","***","***","***");

            }
            console.debug("loadDeviceData   count:"+listDeviceDataModel.count)

        }
        Component.onDestruction: saveImageData()

        function loadDeviceData() {
            var db = Sql.LocalStorage.openDatabaseSync("MyDB", "1.0", "My model SQL", 50000);
            db.transaction(
                        function(tx) {
                            // Create the database if it doesn't already exist
                            tx.executeSql('CREATE TABLE IF NOT EXISTS DeviceInfoList(did TEXT,isCreateConnected INTEGER, account TEXT,password TEXT, ip TEXT,port TEXT)');

                            var rs = tx.executeSql('SELECT * FROM DeviceInfoList');
                            var index = 0;
                            if (rs.rows.length > 0) {
                                var index = 0;
                                while (index < rs.rows.length) {
                                    var myItem = rs.rows.item(index);

                                    addDevice(myItem.isCreateConnected,myItem.did,myItem.account,myItem.password,myItem.ip,myItem.port  )

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
                            tx.executeSql('CREATE TABLE IF NOT EXISTS DeviceInfoList(did TEXT,isCreateConnected INTEGER, account TEXT,password TEXT, ip TEXT,port TEXT)');
                            var index = 0;


                            while (index < listDeviceDataModel.count) {
                                var myItem = listDeviceDataModel.get(index);


                                console.debug(myItem.did +","+ myItem.isCreateConnected+","+myItem.account+","+ myItem.password+","+myItem.ip+","+myItem.port)
                                tx.executeSql('INSERT INTO DeviceInfoList VALUES(?,?,?,?,?,?)', [myItem.did, myItem.isCreateConnected,myItem.account, myItem.password,myItem.ip,myItem.port]);
                                index++;
                            }
                        }
                        )
        }
    }


    function vedioWindowMax(saveIndex,saveScreenNum){

        //console.debug("vedioWindowMax" + preMaxIndex +"  "+preMaxmultiScreenNum + "    "+ tmpIndex)
        preMaxmultiScreenNum = saveScreenNum
        preMaxIndex = saveIndex;

        listDeviceDataModel.move(saveIndex,0,1);
        modelDataCurrentIndex = 0;
    }

    function vedioWindowRestore(restoreIndex,restoreScreenNum){

        //console.debug("vedioWindowRestore   " + preMaxIndex +"  "+preMaxmultiScreenNum)
        listDeviceDataModel.move(0,restoreIndex,1);

        modelDataCurrentIndex = restoreIndex;
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
        for(var i = 0;i<listDeviceDataModel.count;i++){

            if(listDeviceDataModel.get(i).did === strID && listDeviceDataModel.get(i).isCreateConnected > 0){
                st_showToastMsg(qsTr("add failed! The current did already exists"))
                return;
            }
        }

        //是否是需要建立连接的添加
        if(isCreateTcpConnect){

            var isExist = false;
            for(var i = 0;i<listDeviceDataModel.count;i++){


                if(!listDeviceDataModel.get(i).isCreateConnected ){

                    var tmpDataModel = listDeviceDataModel.get(i);

                    tmpDataModel.did = strID;

                    tmpDataModel.account = strAcc;
                    tmpDataModel.password = strPwd;
                    tmpDataModel.ip = strIp;
                    tmpDataModel.port = strPort;
                    tmpDataModel.isCreateConnected = isCreateTcpConnect;
                    isExist = true;
                    break;
                }
            }

            if(!isExist)
                listDeviceDataModel.append({did:strID,isCreateConnected:isCreateTcpConnect,account:strAcc,password:strPwd,ip:strIp,port:strPort});

            listDeviceDid.append({did:strID})
        }else
            listDeviceDataModel.append({did:strID,isCreateConnected:isCreateTcpConnect,account:strAcc,password:strPwd,ip:strIp,port:strPort});

    }

    function deleteDevice(tmpIndex){

        var tmpIsConnected = listDeviceDataModel.get(tmpIndex).isCreateConnected;
        var tDid = listDeviceDataModel.get(tmpIndex).strID;

        if(tmpIsConnected > 0)
            listDeviceDid.remove(tDid);

        listDeviceDataModel.remove(tmpIndex);

        if(listDeviceDataModel.count < multiScreenNum*multiScreenNum)
            addDevice(0,"***","***","***","***","***");

    }

}



