import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import "../simpleControl"
Rectangle {



    signal sEnsure();
    signal sCancel();
    signal sAddPreset();
    signal sPresetUp(var trancksetIndex);
    signal sPresetDown(var trancksetIndex);
    signal sPresetRemove(var trancksetIndex)
    signal sDeviceIndexChange(var trancksetIndex,var mpresetIndex);

    property alias trackArrModel: listpresetPt.model
    Rectangle{
        id:rectHead
        color: "#191919"
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 5
        height: 32
        z:1
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

            onClick:  sAddPreset()//

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
            onClick: sPresetUp(listpresetPt.currentIndex)

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
            onClick: sPresetDown(listpresetPt.currentIndex)

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
            onClick: sPresetRemove(listpresetPt.currentIndex)
        }
    }


    Rectangle{
        id:listHead
        width: parent.width-2
        anchors.horizontalCenter: parent.horizontalCenter
        height: 36
        anchors.top: rectHead.bottom
        color: "#272727"
        z:1
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

    }


    ListView{
        id:listpresetPt
        width: listHead.width
        height: parent.height - cruiseBottom.height-rectHead.height-listHead.height-12
        anchors.top: listHead.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8
        z:0
        delegate: Rectangle{
            width: parent.width
            height: 28
            color: index===listpresetPt.currentIndex?"#191919":"transparent"

            MyComBox{
                id:presetList
                width: 72
                height: parent.height-4
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
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
                currentIndex: presetIndex


                onCurrentIndexChanged: sDeviceIndexChange(index,presetList.currentIndex);


            }

            TextField {
                id:inputSpeed
                width: 84
                height: parent.height-4
                anchors.left: presetList.right
                anchors.leftMargin: 32
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.horizontalCenter
                font.pixelSize: 12
                placeholderText: qsTr("speed")
                activeFocusOnPress: false
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
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        inputSpeed.forceActiveFocus()
                        mouse.accepted = false
                    }
                    onReleased: mouse.accepted = true
                }
            }

            TextField {
                id:inputTime
                width: 72
                height: parent.height-4
                anchors.left: inputSpeed.right
                anchors.leftMargin: 32
                font.pixelSize: 12
                text:time
                placeholderText: qsTr("time")
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.horizontalCenter
                activeFocusOnPress: false
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
                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        inputTime.forceActiveFocus()
                        mouse.accepted = false
                    }
                    onReleased: mouse.accepted = true
                }

            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    listpresetPt.currentIndex  = index
                    mouse.accepted = false
                }

            }

        }

    }


    Rectangle{
        id:cruiseBottom
        width: parent.width
        height: 31
        anchors.bottom: parent.bottom
        color: "#272727"
        z:1
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
            onClicked: {



                sEnsure()
            }
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
