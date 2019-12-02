import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "../simpleControl"
Rectangle {



    signal click_addTrack();
    signal click_removeTrack(var trackIndex);
    signal click_playTrack(var trackIndex)
    signal click_stopTrack(var trackIndex)


    signal trackSet(var trackIndex);
    ListView{
        id:listcruisetrack
        width: parent.width
        height: parent.height - cruiseBottom.height-12
        anchors.top: parent.top
        anchors.topMargin: 12
        model: cruisetrackModel
        z:0
        delegate: Rectangle{


            color: "transparent"
            width: parent.width
            height: 32



            TextField{
                id:txtfieldname
                property bool isTextChange: false
                width: 250
                height: 24
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                cursorPosition:10
                activeFocusOnPress: false
                font.pixelSize: 12
                text: trackName
                style:TextFieldStyle {
                    textColor: "white"
                    background: Rectangle {
                        color: "transparent"
                        implicitWidth: 100
                        implicitHeight: 24
                        radius: 4
                    }
                }

                onEditingFinished: {
                    console.debug("onEditingFinished    "+trackName +"    "+ text);

                    if(isTextChange){
                        isTextChange = false;
                    }
                    txtfieldname.focus = false
                }
                onTextChanged: isTextChange = true

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        txtfieldname.forceActiveFocus()
                        mouse.accepted = false
                    }
                    onReleased: mouse.accepted = true
                }
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

                onClick: click_playTrack(index)
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

                onClick: click_stopTrack(index)
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

                onClick: trackSet(index)
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
                onClick: click_removeTrack(index)

            }

        }
    }

    Rectangle{
        id:cruiseBottom
        width: parent.width
        height: 31
        anchors.top: listcruisetrack.bottom
        color: "#272727"
        z:1
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
            anchors.right: parent.right
            anchors.rightMargin: 20
            imgSourseNormal: "qrc:/images/cruise_presetPlus.png"
            imgSoursePress:"qrc:/images/cruise_presetAddPlusP.png"
            imgSourseHover: imgSourseNormal
            onClick: click_addTrack()
        }
        //        QmlImageButton{
        //            id:imgRemove
        //            width: 20
        //            height: 20
        //            anchors.verticalCenter: parent.verticalCenter
        //            anchors.right: parent.right
        //            anchors.rightMargin: 20
        //            imgSourseNormal:"qrc:/images/cruise_presetLess.png"
        //            imgSourseHover: imgSourseNormal
        //            imgSoursePress:"qrc:/images/cruise_presetLessP.png"
        //        }

    }
}
