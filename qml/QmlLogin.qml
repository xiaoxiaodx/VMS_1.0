import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 1.4



Popup {
    id: root
    x: parent.width/2 - root.width/2
    y: parent.height/2 - root.height/2
    width: 500
    height: 360
    modal: true
    focus: true

    //设置窗口的背景控件，不设置的话Popup的边框会显示出来
    background: rect

    closePolicy: Popup.NoAutoClose


    signal s_Login(string accout,string pwd);
    signal s_connectSer(string ip,string port);
    signal s_showToast(var str1)

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "white"

        radius: 5

        Rectangle{
            width: parent.width-4
            height: 2
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.left: parent.left
            color: "#F8F8F8"
            anchors.leftMargin: 2
            radius: 8
        }



        //设置标题栏区域为拖拽区域
        Text {
            id:title
            width: parent.width
            height: 40
            anchors.top: parent.top
            text: qsTr("Landing platform")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            MouseArea {
                property point clickPoint: "0,0"

                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: {
                    clickPoint  = Qt.point(mouse.x, mouse.y)
                }
                onPositionChanged: {
                    var offset = Qt.point(mouse.x - clickPoint.x, mouse.y - clickPoint.y)
                    setDlgPoint(offset.x, offset.y)
                }
            }
        }


        Column{
            id:txtInput
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: title.bottom
            anchors.topMargin: 15
            spacing: 10

            TextField {

                id:txtAccount
                width: 400
                height: 34

                placeholderText: qsTr("Enter account")
                text:"admin"

            }

            TextField {

                id:txtPwd
                width: 400
                height: 34
                placeholderText: qsTr("Enter password")
                text:"admin"

            }


            Rectangle{

                width: parent.width
                height: 34

                CheckBox {
                    id:checkboxRpwd
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    checked: false
                    text: qsTr("remember password")
                }

                CheckBox {
                    id:checkboxAlogin
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    checked: false
                    text: qsTr("automatic login")
                }
            }

            Rectangle{
                id:serverPlatformtSelect
                width: 400
                height: 34
                Text {
                    id:serverPlatformtip
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: 34
                    text: qsTr("Server platform:")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                ComboBox{
                    id:cmb
                    anchors.left: serverPlatformtip.right
                    anchors.verticalCenter: parent.verticalCenter
                    width:100
                    height: 34
                    model: ["TCP", "P2P"]
                }
            }

            Rectangle{

                id:serverinfo
                width: 400
                height: 34

                TextField {

                    id:serverIp
                    width: 200
                    height: 34
                    placeholderText: qsTr("ip")
                    text:"10.67.1.167"

                }

                TextField {

                    id:serverPort
                    width: 70
                    height: 34
                    anchors.left: serverIp.right
                    anchors.leftMargin: 5
                    anchors.top: serverIp.top
                    placeholderText: qsTr("prot")
                    text:"1883"
                }
            }

            Button {
                id:btnLogin

                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Login")

                onClicked: {

//                    mqttestt.connectServer(serverIp.text.toString(),serverPort.text.toString())

                    s_connectSer(serverIp.text.toString(),serverPort.text.toString());
                    //s_Login(txtAccount.text.toString(),txtPwd.text.toString())

                }
            }

        }




        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 4
            verticalOffset: 4
            color:"#80000000"
        }
    }


    function setDlgPoint(dlgX ,dlgY)
    {
        //设置窗口拖拽不能超过父窗口
        if(root.x + dlgX < 0)
        {
            root.x = 0
        }
        else if(root.x + dlgX > root.parent.width - root.width)
        {
            root.x = root.parent.width - root.width
        }
        else
        {
            root.x = root.x + dlgX
        }
        if(root.y + dlgY < 0)
        {
            root.y = 0
        }
        else if(root.y + dlgY > root.parent.height - root.height)
        {
            root.y = root.parent.height - root.height
        }
        else
        {
            root.y = root.y + dlgY
        }
    }
}

