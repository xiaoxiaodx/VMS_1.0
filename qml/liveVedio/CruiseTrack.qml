import QtQuick 2.0
import "../simpleControl"

Rectangle {




    signal trackSet();
    ListView{
        id:listcruisetrack
        width: parent.width
        height: parent.height - cruiseBottom.height-12
        anchors.top: parent.top
        anchors.topMargin: 12
        model: [1,2,3]
        delegate: Rectangle{


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
                text: qsTr("text")

            }



            QmlImageButton{
                id:imgCruisePlay
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: imgCruiseStop.left
                anchors.rightMargin: 10
                imgSourseNormal:"qrc:/images/cruise_play.png"
                imgSoursePress:"qrc:/images/cruise_playP.png"
                imgSourseHover: imgSourseNormal


            }

            QmlImageButton{
                id:imgCruiseStop
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: imgCruiseSet.left
                anchors.rightMargin: 10
                imgSourseNormal:"qrc:/images/cruise_stop.png"
                imgSoursePress:"qrc:/images/cruise_stopP.png"
                imgSourseHover: imgSourseNormal


            }

            QmlImageButton{
                id:imgCruiseSet
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: imgCruiseDelete.left
                anchors.rightMargin: 10
                imgSourseNormal:"qrc:/images/cruise_set.png"
                imgSoursePress:"qrc:/images/cruise_setP.png"
                imgSourseHover: imgSourseNormal

                onClick: trackSet()
            }

            QmlImageButton{
                id:imgCruiseDelete
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
    }

    Rectangle{
        id:cruiseBottom
        width: parent.width
        height: 31
        anchors.top: listcruisetrack.bottom
        color: "transparent"

         Rectangle{
            width: parent.width
            height: 1
            color: "black"
            anchors.top: parent.top
         }

        QmlImageButton {
            id: imgAdd
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: imgRemove.left
            anchors.rightMargin: 20
            imgSourseNormal: "qrc:/images/cruise_presetPlus.png"
            imgSoursePress:"qrc:/images/cruise_presetAddPlusP.png"
            imgSourseHover: imgSourseNormal
        }
        QmlImageButton{
            id:imgRemove
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            imgSourseNormal:"qrc:/images/cruise_presetLess.png"
            imgSourseHover: imgSourseNormal
            imgSoursePress:"qrc:/images/cruise_presetLessP.png"
        }

    }
}
