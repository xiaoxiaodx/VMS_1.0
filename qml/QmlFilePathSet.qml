import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import QtQuick.Controls.Styles 1.4
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3
import QtQuick 2.1
import Qt.labs.settings 1.0

Popup {
    id: root
    x: parent.width/2 - root.width/2
    y: parent.height/2 - root.height/2
    width: 500
    height: 250
    modal: true
    focus: true
    //设置窗口关闭方式为按“Esc”键关闭
    closePolicy: Popup.OnEscape
    //设置窗口的背景控件，不设置的话Popup的边框会显示出来
    background: rect

    signal s_fiPath(var shotScreenPath,var recordingPath)

    signal s_showToast(var str1)


    Settings{
        id:setting1s
        property alias sFilePath: inputR.text
        property alias rFilePath: inputS.text

    }
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
            anchors.leftMargin: 10
            anchors.left: parent.left
            text: qsTr("File Path Setting")
            horizontalAlignment: Text.AlignLeft
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

            anchors.top: title.bottom
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 20
            spacing: 10


            Row{


                spacing: 10

                Label{
                    id:labelS
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Screenshot Path")

                }
                TextField {
                    id:inputS

                    width: 270
                    height: 34
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: qsTr("")

                }

                QmlImageButton{

                    width:26
                    height:26
                    anchors.verticalCenter: parent.verticalCenter
                    imgSourseHover: "qrc:/images/fileopen.png"
                    imgSourseNormal: "qrc:/images/fileopen.png"
                    imgSoursePress: "qrc:/images/fileopen.png"

                    onClick: {
                        fileDialog.pathname = labelS.text.toString();
                        fileDialog.folder = inputS.text.toString()
                        fileDialog.open();
                    }
                }
            }


            Row{

                spacing: 10

                Label{
                    id:labelR
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Recording   Path")

                }
                TextField {

                    id:inputR

                    anchors.verticalCenter: parent.verticalCenter
                    width: 270
                    height: 34

                    placeholderText: qsTr("")


                }

                QmlImageButton{
                    anchors.verticalCenter: parent.verticalCenter
                    width:26
                    height:26
                    imgSourseHover: "qrc:/images/fileopen.png"
                    imgSourseNormal: "qrc:/images/fileopen.png"
                    imgSoursePress: "qrc:/images/fileopen.png"

                    onClick: {
                        fileDialog.pathname = labelR.text.toString();
                        fileDialog.folder = inputR.text.toString()
                        fileDialog.open();

                    }

                }

            }
        }


        Button {
            id:btncancel
            anchors.top: txtInput.bottom
            anchors.topMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 10


            text: qsTr("cancel")

            onClicked: {
                root.close()
            }
        }

        Button {
            id:btnensure
            anchors.top: btncancel.top
            anchors.right: btncancel.left
            anchors.rightMargin: 10
            text: qsTr("ensure")



            onClicked: {

                s_fiPath(inputS.text.toString(),inputR.text.toString())

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

    FileDialog {
        id: fileDialog
        property string pathname:""
        title: "Please choose a file path"
        selectFolder:true
        selectMultiple: false
        //folder: shortcuts.home
        onAccepted: {
            if(pathname === labelS.text.toString()){

                var str = fileDialog.fileUrl.toString();
                inputS.text = str.replace('file:///','');


            }else if(pathname === labelR.text.toString()){
                inputR.text = fileDialog.fileUrl.toString().replace('file:///','');

            }

        }
        onRejected: {


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

