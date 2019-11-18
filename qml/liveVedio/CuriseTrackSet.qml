import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import "../simpleControl"
Rectangle {



    Rectangle{
        id:rectHead
        color: "transparent"
        width: parent.width
        height: 32
        Text {
            id: name
            font.pixelSize: 12
            color: "white"
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Cruise track")

        }

        QmlImageButton{
            id:imgTrackSet
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: imgCruiseSetUp.left
            anchors.rightMargin: 10
            imgSourseNormal:"qrc:/images/cruise_add.png"
            imgSoursePress:"qrc:/images/cruise_dddP.png"
            imgSourseHover: imgSourseNormal

            onClick: console.debug("QmlImageButton  imgTrackSet")
        }




        QmlImageButton{
            id:imgCruiseSetUp
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: imgCruiseSetDown.left
            anchors.rightMargin: 10
            imgSourseNormal:"qrc:/images/cruise_up.png"
            imgSoursePress:"qrc:/images/cruise_upP.png"
            imgSourseHover: imgSourseNormal


        }

        QmlImageButton{
            id:imgCruiseSetDown
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: imgCruiseSetDelete.left
            anchors.rightMargin: 10
            imgSourseNormal:"qrc:/images/cruise_down.png"
            imgSoursePress:"qrc:/images/cruise_downP.png"
            imgSourseHover: imgSourseNormal


        }

        QmlImageButton{
            id:imgCruiseSetDelete
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            imgSourseNormal:"qrc:/images/cruise_delete.png"
            imgSoursePress:"qrc:/images/cruise_deleteP.png"
            imgSourseHover: imgSourseNormal

        }
    }


    Rectangle{
        id:listHead
        width: parent.width
        height: 48
        anchors.top: rectHead.bottom
        color: "transparent"
        Rectangle{

            id:label1
            width: parent.width/3
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 16
            color: "transparent"
            Text {
                id: txt1

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12
                color: "white"
                text: qsTr("preset")
            }
        }

        Rectangle{

            id:label2
            width: parent.width/3
            height: parent.height
            anchors.left: label1.right
            anchors.leftMargin: 32
            color: "transparent"
            Text {
                id: txt2

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12
                color: "white"
                text: qsTr("speed")
            }
        }
        Rectangle{

            id:label3
            width: parent.width/3
            height: parent.height
            anchors.left: label2.right
            anchors.leftMargin: 38
            color: "transparent"
            Text {
                id: txt3
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12
                color: "white"
                text: qsTr("time")
            }
        }
    }
    ListView{
        id:listpresetPt
        width: parent.width
        height: parent.height - cruiseBottom.height-rectHead.height-listHead.height-12
        anchors.top: listHead.bottom
        model: [1,2,3]
        spacing: 2
        delegate: Rectangle{
            width: parent.width
            height: 30
            color: "transparent"

            MyComBox{
                id:presetList
                width: 72
                height: parent.height

                colorNor: "#FFFFFF"
                colorPressed: "#409EFF"
                fontColor:"#FFFFFF"
                bordColor:"#D9D9D9"

                mRadius:5



            }

            TextField {
                id:inputSpeed
                width: 72
                height: parent.height
                anchors.left: presetList.right
                anchors.leftMargin: 32


                font.pixelSize: 12
                placeholderText: qsTr("enter password")
                style:TextFieldStyle {
                    textColor: "white"

                    placeholderTextColor:"#999999"
                    background: Rectangle {
                        color: "transparent"
                        border.width: 1
                        border.color: "#D9D9D9"
                        radius: 5
                    }
                }
            }

            TextField {
                id:inputTime
                width: 72
                height: parent.height
                anchors.left: inputSpeed.right
                anchors.leftMargin: 32


                font.pixelSize: 12

                placeholderText: qsTr("enter password")
                style:TextFieldStyle {
                    textColor: "white"
                    placeholderTextColor:"#999999"
                    background: Rectangle {
                        color: "transparent"
                        border.width: 1
                        border.color: "#D9D9D9"
                        radius: 5
                    }
                }
            }






        }
    }



    Rectangle{
        id:cruiseBottom
        width: parent.width
        height: 31
        anchors.bottom: parent.bottom
        color: "transparent"

        Rectangle{
            width: parent.width
            height: 1
            color: "black"
            anchors.top: parent.top
        }

        QmlButton {
            id: imgAdd
            width: 56
            height: 24
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: imgRemove.left
            anchors.rightMargin: 20
            borderW:1
            borderColor: "white"
            colorNor: "transparent"
            colorPressed:"#409EFF"
            mRadius:3
            fontsize:10
            text: "ensure"

        }
        QmlButton{
            id:imgRemove
            width: 56
            height: 24
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            borderW:1
            borderColor: "white"
            colorNor: "transparent"
            colorPressed:"#409EFF"
            mRadius:3
            fontsize:10
            text: "cancel"
        }

    }
}
