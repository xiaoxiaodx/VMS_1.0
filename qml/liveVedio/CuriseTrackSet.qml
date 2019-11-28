import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import "../simpleControl"
Rectangle {



    signal sEnsure();
    signal sCancel();

    property alias trackArrModel: listpresetPt.model
    Rectangle{
        id:rectHead
        color: "#191919"
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 5
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
            id:imgTrackAdd
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: imgCruiseSetUp.left
            anchors.rightMargin: 10
            imgSourseNormal:"qrc:/images/cruise_add.png"
            imgSoursePress:"qrc:/images/cruise_dddP.png"
            imgSourseHover: imgSourseNormal

            onClick: trackArrModel.append({presetIndex:0,speed:0,time:0});
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
        height: 36
        anchors.top: rectHead.bottom
        color: "transparent"

        Text {
            id: txt1

            anchors.left: parent.left
            anchors.leftMargin: 34
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: "white"
            text: qsTr("preset")
        }



        Text {
            id: txt2

            anchors.left: parent.left
            anchors.leftMargin: 144
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: "white"
            text: qsTr("speed")
        }


        Text {
            id: txt3
            anchors.left: parent.left
            anchors.leftMargin: 254
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: "white"
            text: qsTr("time")
        }

        MouseArea{
            anchors.fill: parent
            onClicked: console.debug("*******   "+parent.width)
        }
    }


    ListView{
        id:listpresetPt
        width: parent.width
        height: parent.height - cruiseBottom.height-rectHead.height-listHead.height-12
        anchors.top: listHead.bottom

        spacing: 8
        delegate: Rectangle{
            width: parent.width
            height: 28
            color: "transparent"

            MyComBox{
                id:presetList
                width: 72
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 16
                model: trackPresetPtModel
                colorNor: "#D9D9D9"
                colorPressed: "#409EFF"
                fontColor:"#FFFFFF"
                bordColor:"#D9D9D9"
                itembordColor:"#D9D9D9"
                itemColorNor: "black"
                itemColorHoverd: "#191919"
                font.pixelSize: 12
                indicatorW:6
                indicatorH:4

            }

            TextField {
                id:inputSpeed
                width: 84
                height: parent.height
                anchors.left: presetList.right
                anchors.leftMargin: 32


                font.pixelSize: 12
                placeholderText: qsTr("speed")

                text: speed
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
                text:time
                placeholderText: qsTr("time")
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
            onClicked: sEnsure()
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
            onClicked:sCancel()
        }

    }
}
