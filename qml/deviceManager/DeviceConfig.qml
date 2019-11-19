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



                text: qsTr("Remote device configuration")
                color: "white"

                anchors.left: parent.left
                anchors.leftMargin: 20
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


        Rectangle{
            id:content
            width: parent.width
            height: parent.height - recttitle.height
            color: "#272727"
            Rectangle{
                id:contentleft
                width: 200
                height: parent.height

                Rectangle{
                    id:rectmedia
                    anchors.top: parent.top
                    anchors.topMargin: 14
                    width: parent.width
                    height: 37
                    Text {
                        id: txtMedia
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: qsTr("MediaInfo")
                    }

                }

                Rectangle{
                    id:rectmove
                    anchors.top: rectmedia.bottom
                    width: parent.width
                    height: 37
                    Text {
                        id: txtmove
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: qsTr("MediaInfo")
                    }

                }
            }
            SwipeView {
                id: view
                z:0
                width: parent.width -contentleft.left
                height: parent.height
                interactive:false
                anchors.top: parent.top
                anchors.left: contentleft.right

                currentIndex: 0
                DeviceConfigMedia{

                }

                DeviceConfigMotionDetection{

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

