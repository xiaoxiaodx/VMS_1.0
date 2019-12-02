import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 1.4
import "../simpleControl"
Popup {
    id: root
    x: parent.width/2 - root.width/2
    y: parent.height/2 - root.height/2
    width: 520
    height: 431
    modal: true
    focus: true
    //设置窗口关闭方式为按“Esc”键关闭
    closePolicy: Popup.OnEscape
    //设置窗口的背景控件，不设置的话Popup的边框会显示出来
    background: rect

    signal s_deviceIDstr(var name,var strID,var strAccoount,var strPassword)

    signal s_showToast(var str1)

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "black"

        radius: 3

        //设置标题栏区域为拖拽区域
        Rectangle{
            id:recttitle
            width: parent.width
            height: 54
            anchors.top: parent.top
            color: "transparent"
            Text {



                text: qsTr("Add device")
                color: "white"

                anchors.left: parent.left
                anchors.leftMargin: 19
                anchors.verticalCenter: parent.verticalCenter
            }

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

            Image {
                id: imgClose
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 18
                source: "qrc:/images/devicem_close"

                MouseArea{

                    anchors.fill: parent
                    onClicked: root.close()
                }
            }

        }

        Column{
            id:txtInput

            width: parent.width
            anchors.top: recttitle.bottom
            anchors.topMargin: 40
            spacing: 20



            Rectangle{

                width: parent.width
                height: 40
                color: "transparent"
                Text {
                    id: txtname
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: input4.left
                    anchors.rightMargin: 6
                    font.pixelSize: 16
                    color: "white"
                    text: qsTr("name:")
                }

                Text {
                    id: txtname1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: txtname.left
                    color: "red"
                    font.pixelSize: 16
                    text: qsTr("*")
                }
                TextField {

                    id:input4
                    width: 254
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 118
                    placeholderText: qsTr("enter name")
                    text:"hello"//"113.247.22.69"//"218.76.52.29"//
                    font.pixelSize: 16
                     activeFocusOnPress: false
                    style:TextFieldStyle {
                        textColor: "#ffffff"
                        background: Rectangle {
                            color: "#272727"
                            implicitWidth: 100
                            implicitHeight: 24
                            radius: 4
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            input4.forceActiveFocus()
                            mouse.accepted = false
                        }
                        onReleased: mouse.accepted = true
                    }
                }
            }
            Rectangle{
                width: parent.width
                height: 40
                color: "transparent"
                Text {
                    id: txtdid
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: input1.left
                    anchors.rightMargin: 6
                    font.pixelSize: 16
                    color: "white"
                    text: qsTr("device did:")
                }

                Text {
                    id: txtdid1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: txtdid.left
                    color: "red"
                    font.pixelSize: 16
                    text: qsTr("*")
                }
                TextField {

                    id:input1
                    width: 254
                    height: 40
                    placeholderText: qsTr("input did")
                    anchors.right: parent.right
                    anchors.rightMargin: 118
                    //validator: RegExpValidator { regExp: /[0-9A-F-]+/ }
                    font.pixelSize: 16
                    text:"INEW-003882-RHHFR"
                    activeFocusOnPress: false
                    style:TextFieldStyle {
                        textColor: "#ffffff"
                        background: Rectangle {
                            color: "#272727"
                            implicitWidth: 100
                            implicitHeight: 24
                            radius: 4
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            input1.forceActiveFocus()
                            mouse.accepted = false
                        }
                        onReleased: mouse.accepted = true
                    }
                    //inputMask: "AAAA-000000-AAAAA"
                }
            }
            Rectangle{
                width: parent.width
                height: 40
                color: "transparent"
                Text {
                    id: txtacc
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: input2.left
                    anchors.rightMargin: 6
                    font.pixelSize: 16
                    color: "white"
                    text: qsTr("account:")
                }

                Text {
                    id: txtacc1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: txtacc.left
                    color: "red"
                    font.pixelSize: 16
                    text: qsTr("*")
                }
                TextField {

                    id:input2
                    width: 254
                    height: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 118
                    placeholderText: qsTr("input account")
                    text:"admin"
                    font.pixelSize: 16
                    activeFocusOnPress: false
                    style:TextFieldStyle {
                        textColor: "#ffffff"
                        background: Rectangle {
                            color: "#272727"
                            implicitWidth: 100
                            implicitHeight: 24
                            radius: 4
                        }
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        input2.forceActiveFocus()
                        mouse.accepted = false
                    }
                    onReleased: mouse.accepted = true
                }
            }
            Rectangle{
                width: parent.width
                height: 40
                color: "transparent"
                Text {
                    id: txtpwd
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: input3.left
                    anchors.rightMargin: 6
                    font.pixelSize: 16
                    color: "white"
                    text: qsTr("password:")
                }

                Text {
                    id: txtpwd1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: txtpwd.left
                    color: "red"
                    font.pixelSize: 16
                    text: qsTr("*")
                }
                TextField {

                    id:input3
                    width: 254
                    height: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 118
                    placeholderText: qsTr("input password")
                    activeFocusOnPress: false
                    text:"admin"
                    font.pixelSize: 16
                    style:TextFieldStyle {
                        textColor: "#ffffff"

                        background: Rectangle {
                            color: "#272727"
                            implicitWidth: 100
                            implicitHeight: 24
                            radius: 4
                        }
                    }

                }
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        input3.forceActiveFocus()
                        mouse.accepted = false
                    }
                    onReleased: mouse.accepted = true
                }
            }
        }





        QmlButton {


            id:btnEnsure

            width: 78
            height: 39
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 40

            colorNor:"black"
            colorPressed: "#409EFF"
            borderColor: "#D9D9D9"
            borderW: 1
            mRadius: 5
            fontsize: 17
            text: qsTr("ensure")
            onClicked: {

                s_deviceIDstr(input4.text.toString(),input1.text.toString(),input2.text.toString(),input3.text.toString())

                root.close()
            }
        }
        QmlButton{
            width: 78
            height: 39
            anchors.bottom: btnEnsure.bottom
            anchors.right: btnEnsure.left
            anchors.rightMargin: 10
            colorNor:"black"
            colorPressed: "#409EFF"
            borderColor: "#D9D9D9"
            borderW: 1
            mRadius: 5
            fontsize: 17
            text: qsTr("cancel")
            onClicked: {



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

