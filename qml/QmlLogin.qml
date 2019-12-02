import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.12
import QtQml 2.12


import "./simpleControl"
Rectangle{


    signal s_Login();
    id:login
    visible: true


    //property var netWorkModel: [{showStr:"tcp",num:0},{showStr:"p2p",num:0}]
    ListModel{
        id:netWorkModel
        Component.onCompleted: {
            netWorkModel.append({showStr:"tcp"})
            netWorkModel.append({showStr:"p2p"})
        }
    }


    Image {
        id: loginImg
        anchors.fill: parent
        source: "qrc:/images/loginImgBg.png"
    }


    Text {
        id: idLabe
        x:641
        y:58
        width: 80
        height: 28
        font.bold: true
        font.pointSize: 20
        color: "#409EFF"
        text: qsTr("欢迎登陆")
    }





    Rectangle{
        id:rectAcc
        width: 258
        height: 36

        anchors.horizontalCenter: idLabe.horizontalCenter
        anchors.top: idLabe.bottom
        anchors.topMargin: 20
        color: "#272727"
        radius: 4
        Image {
            id: img
            anchors.left: parent.left
            anchors.leftMargin: 13
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/loginAcc.png"
        }


        TextField {
            id:inputacc
            width: rectAcc.width - 61
            height: 30
            anchors.left: img.right
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            placeholderText: qsTr("enter account")
            font.pointSize:12
            activeFocusOnPress: false
            style:TextFieldStyle {
                textColor: "white"
                placeholderTextColor:"#999999"
                background: Rectangle {
                    color: "transparent"
                }
            }


            MouseArea{
                anchors.fill: parent
                onPressed: {
                    inputacc.forceActiveFocus()
                    mouse.accepted = false
                }
                onReleased: mouse.accepted = true
            }
        }
    }

    Rectangle{
        id:rectPwd
        width: 258
        height: 36

        anchors.horizontalCenter: idLabe.horizontalCenter
        anchors.top: rectAcc.bottom
        anchors.topMargin: 12
        color: "#272727"
        radius: 4
        Image {
            id: img1
            anchors.left: parent.left
            anchors.leftMargin: 13
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/loginPwd.png"
        }


        TextField {
            id:inputpwd
            width: rectPwd.width - 61
            height: 30
            anchors.left: img1.right
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            placeholderText: qsTr("enter password")
            activeFocusOnPress: false
            font.pointSize:12
            style:TextFieldStyle {
                textColor: "white"
                placeholderTextColor:"#999999"
                background: Rectangle {
                    color: "transparent"
                }
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    inputpwd.forceActiveFocus()
                    mouse.accepted = false
                }
                onReleased: mouse.accepted = true
            }
        }
    }

    QmlCheck{
        id:checkedRemPwd
        anchors.left:rectPwd.left
        anchors.top: rectPwd.bottom
        anchors.topMargin: 8
        text: "Remember password"
        colorNor:"#999999"
        colorPressed: "#ffffff"
        indImg: "qrc:/images/loginUnSelect.png"
        indImgPressed: "qrc:/images/loginSelect.png"

    }



    QmlCheck{
        id:checkedAutoLogin
        anchors.right:rectPwd.right
        anchors.top: rectPwd.bottom
        anchors.topMargin: 8
        text: "Auto login"
        colorNor:"#999999"
        colorPressed: "#ffffff"
        indImg: "qrc:/images/loginUnSelect.png"
        indImgPressed: "qrc:/images/loginSelect.png"
    }

    Text {
        id: txtNetworkType
        anchors.top: checkedAutoLogin.bottom
        anchors.topMargin: 26
        anchors.left: rectPwd.left
        text: qsTr("Network Type")
        font.family: "Roboto-Medium"
        font.pointSize: 14
        color: "white"
    }

    MyComBox{
        id:boxNetWorkType
        width: 258
        height: 36
        anchors.left: txtNetworkType.left
        anchors.top: txtNetworkType.bottom
        anchors.topMargin: 8
        model: netWorkModel
        currentIndex: 0

    }

    Text {
        id: txtSerInfo
        anchors.top: boxNetWorkType.bottom
        anchors.topMargin: 12
        anchors.left: rectPwd.left
        text: qsTr("Server")
        font.family: "Roboto-Medium"
        font.pointSize: 14
        color: "white"
    }



    TextField {
        id:inputSerIp
        width: 169
        height: 36
        anchors.left: txtSerInfo.left
        anchors.top: txtSerInfo.bottom
        anchors.topMargin: 8
        placeholderText: qsTr("ip")
        text:""//10.67.1.167
        activeFocusOnPress: false
        font.pointSize:12
        style:TextFieldStyle {
            textColor: "white"
            placeholderTextColor:"#999999"
            background: Rectangle {
                color: "#272727"
                radius: 4.3
            }
        }
        MouseArea{
            anchors.fill: parent
            onPressed: {
                inputSerIp.forceActiveFocus()
                mouse.accepted = false
            }
            onReleased: mouse.accepted = true
        }
    }

    TextField {
        id:inputSerPort
        width: 82
        height: 36
        anchors.left: inputSerIp.right
        anchors.leftMargin: 7
        anchors.top: inputSerIp.top
        placeholderText: qsTr("port")
        text:""//1883
        activeFocusOnPress: false
        font.pointSize:12
        style:TextFieldStyle {


            textColor: "white"
            placeholderTextColor:"#999999"
            background: Rectangle {
                color: "#272727"
                radius: 4.3
            }

        }
        MouseArea{
            anchors.fill: parent
            onPressed: {
                inputSerPort.forceActiveFocus()
                mouse.accepted = false
            }
            onReleased: mouse.accepted = true
        }
    }

    QmlButton{
        id:btnLogin
        width: 258
        height: 43
        anchors.top:inputSerPort.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: idLabe.horizontalCenter
        text: "Sign in"
        colorNor: "#409EFF"
        colorPressed: "#aa409EFF"
        fontsize: 16
        onClicked:{
//            systemAttributes.settcpSerAccount(inputacc.text.toString())
//            systemAttributes.settcpSerIp(inputSerIp.text.toString())
//            systemAttributes.settcpSerPassword(inputpwd.text.toString())
//            systemAttributes.settcpSerPort(inputSerPort.text.toString())
//            systemAttributes.settcpSerIsRemPwd(checkedRemPwd.checkedState)
//            systemAttributes.settcpSerIsAutoLogin(checkedAutoLogin.checkedState)
//            systemAttributes.setnetwokType(boxNetWorkType.currentIndex)

            //s_Login(inputSerIp.text.toString(),inputSerPort.text.toString(),inputacc.text.toString(),inputpwd.text.toString())
            s_Login();
        }

    }



}
