import QtQuick 2.0
import "../qml/simpleControl"
Rectangle {


    property alias mCurIndex: tabbarBtn.curIndex
    Rectangle{
        id:rectHome
        width: 80
        height: 40
        anchors.left: parent.left
        anchors.leftMargin: 33
        color: tabbarBtn.curIndex>-1?"transparent":"#409EFF"
        Image {
            id: btnHome

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/mainPage.png"

        }
        MouseArea{

            anchors.fill: parent
            onClicked: {

                tabbarBtn.curIndex = -1;



            }
        }
    }


    QmlTabBarButtonH{
        id:tabbarBtn
        height: parent.height
        anchors.left: rectHome.right
        anchors.leftMargin: 31
        btnBgColor:"transparent"
        btnBgSelectColor:"#272727"
        mflagColor:"#409EFF"
        textColor: "white"
        textSelectColor:"white"
        imageSrcEnter:"#333333"
        txtLeftMargin:24
        imageLeftMargin: 11
        textSize:16
        Component.onCompleted: {

            tabbarBtn.barModel.append({txtStr:qsTr("Video Live"),imgSrc:"qrc:/images/homemenuClose.png",imgSrcEnter:"qrc:/images/homemenuClose.png"})
            tabbarBtn.barModel.append({txtStr:qsTr("Video playback"),imgSrc:"qrc:/images/homemenuClose.png",imgSrcEnter:"qrc:/images/homemenuClose.png"})
            tabbarBtn.barModel.append({txtStr:qsTr("Device Manager"),imgSrc:"qrc:/images/homemenuClose.png",imgSrcEnter:"qrc:/images/homemenuClose.png"})

        }

    }


}
