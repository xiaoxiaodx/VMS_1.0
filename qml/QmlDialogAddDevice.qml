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
    width: 344
    height: 345
    modal: true
    focus: true
    //设置窗口关闭方式为按“Esc”键关闭
    closePolicy: Popup.OnEscape
    //设置窗口的背景控件，不设置的话Popup的边框会显示出来
    background: rect

    signal s_deviceIDstr(var strID,var strAccoount,var strPassword,var strIp,var strPort)

    signal s_showToast(var str1)

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "white"

        radius: 8

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
            text: qsTr("Add Device")
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

                id:input1
                width: 270
                height: 34
                placeholderText: qsTr("Enter Did")

                //validator: RegExpValidator { regExp: /[0-9A-F-]+/ }
                text:"INEW-003882-RHHFR"

             //   inputMask: "AAAA-00000-AAAAA"
            }

            TextField {

                id:input2
                width: 270
                height: 34

                placeholderText: qsTr("Enter account")
                text:"admin"

            }

            TextField {

                id:input3
                width: 270
                height: 34
                placeholderText: qsTr("Enter password")
                text:"admin"

            }

            TextField {

                id:input4
                width: 270
                height: 34
                placeholderText: qsTr("Enter ip")
                text:"218.76.52.29"//"10.67.3.58"

            }

            TextField {

                id:input5
                width: 270
                height: 34
                placeholderText: qsTr("Enter prot")
                text:"555"
            }
        }
        Button {

            anchors.top: txtInput.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("ok")

            onClicked: {



                var did = input1.text.replace(/ /g,"");
                var acc = input2.text.replace(/ /g,"");
                var pwd = input3.text.replace(/ /g,"");
                var ip = input4.text.replace(/ /g,"");
                var port = input5.text.replace(/ /g,"");


                input1.text = did
                input2.text = acc
                input3.text = pwd
                input4.text = ip
                input5.text = port


                var didFirstChar = did.charAt(0);

                 if(((didFirstChar >= 'A' && didFirstChar <= 'Z') || (didFirstChar >= 'a' && didFirstChar <= 'z')));
                 else{
                    s_showToast("did input error")
                     return;
                 }

                s_deviceIDstr(did,acc,pwd,ip,port)

                root.close()
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

