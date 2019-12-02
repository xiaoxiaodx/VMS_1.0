import QtQuick 2.0

import QtQuick.Controls 1.4
import Qt.labs.platform 1.1
import QtQuick.Dialogs 1.3
import "../simpleControl"
Rectangle {

    property int curSelectIndex: -1
    Rectangle{

        id:rectLeft
        width: 300
        height: parent.height
        color: "#272727"
        Rectangle{
            id:leftHead
            width: parent.width
            height: 66
            color: "transparent"
            Image {
                id: img
                anchors.left: parent.left
                anchors.leftMargin: 17
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/systemconfig.png"
            }

            Text {
                id: txt
                text: qsTr("System Config")
                anchors.left: img.right
                anchors.leftMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                color: "white"
            }
            Rectangle{

                color: "#88000000"
                width: parent.width-32
                height: 37
                anchors.top: leftHead.bottom
                anchors.left: parent.left
                anchors.leftMargin: 16

                Text {
                    id: txt1
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 16
                    color: "white"
                    text: qsTr("local settings")
                }
            }
        }

    }

    Rectangle{

        id:content
        width: parent.width - rectLeft.width
        height: parent.height
        anchors.left: rectLeft.right
        anchors.top: rectLeft.top
        color: "#383838"
        Column{
            width: parent.width

            spacing: 40
            anchors.top: parent.top
            anchors.topMargin: 100
            Rectangle{

                anchors.horizontalCenter: parent.horizontalCenter
                height: 50
                width: label.width + rect1.width + 20
                color: "transparent"
                Text {
                    id: label
                    color:"white"
                    font.pixelSize: 18
                    anchors.right: rect1.left
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("         video file save path")
                }

                Rectangle{
                    id:rect1
                    width: 480
                    height: parent.height
                    anchors.right: parent.right
                    color: "#80000000"
                    Text {
                        id: txtVedioSavePath
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        font.pixelSize: 14
                        color: "white"
                        text: qsTr("")
                    }
                    Image {
                        id: imgVedioSavePath
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        source: "qrc:/images/pathSelect.png"

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {

                                    fileDialog.pathname = label.text.toString();

                                    fileDialog.open();

                            }
                        }
                    }
                }

            }

            Rectangle{

                anchors.horizontalCenter: parent.horizontalCenter
                height: 50
                width: label2.width + rect2.width + 20
                color: "transparent"
                Text {
                    id: label2
                    color:"white"
                    font.pixelSize: 18
                    anchors.right: rect2.left
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("screenshot file save path")
                }

                Rectangle{
                    id:rect2
                    width: 480
                    height: parent.height

                    anchors.right: parent.right
                    color: "#80000000"
                    Text {
                        id: txtscreenshotSavePath
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        font.pixelSize: 14
                        color: "white"
                        text: qsTr("")
                    }


                    Image {
                        id: imgscreenshotSavePath
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        source: "qrc:/images/pathSelect.png"
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {

                                fileDialog.pathname = label2.text.toString();
                              //  fileDialog.folder = inputS.text.toString()
                                fileDialog.open();

                        }
                    }
                }

            }

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
            if(pathname === label.text.toString()){

                var str = fileDialog.fileUrl.toString();
                txtVedioSavePath.text = str.replace('file:///','');


            }else if(pathname === label2.text.toString()){
                txtscreenshotSavePath.text = fileDialog.fileUrl.toString().replace('file:///','');

            }

        }
        onRejected: {


        }
    }
}
