import QtQuick 2.0
import "../simpleControl"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
Rectangle{


    signal click_flush();
    signal click_addPresetPt()
    signal click_removePresetPt(var presetIndex);
    signal click_moveToPreset(var presetIndex);
    ListView{
        id:listPresetPt
        width: parent.width
        height: parent.height - cruiseBottom.height-12
        anchors.top: parent.top
        anchors.topMargin: 12
        model:presetPtModel
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
                text: showStr
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
                    console.debug("onEditingFinished    "+showStr +"    "+ text);

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
                id:imgPresetMove
                width: 14
                height: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: imgPresetRemove.left
                anchors.rightMargin: 10
                imgSourseNormal:"qrc:/images/cruise_move.png"
                imgSoursePress:"qrc:/images/cruise_moveP.png"
                imgSourseHover: imgSourseNormal
                onClick: click_moveToPreset(index)
            }

            QmlImageButton{
                id:imgPresetRemove
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 20
                imgSourseNormal:"qrc:/images/cruise_delete.png"
                imgSoursePress:"qrc:/images/cruise_deleteP.png"
                imgSourseHover: imgSourseNormal
                onClick: click_removePresetPt(index)
            }

        }
    }

    Rectangle{
        id:cruiseBottom
        width: parent.width
        height: 31
        anchors.top: listPresetPt.bottom
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
            onClick: click_addPresetPt()
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
//            onClick: click_removePresetPt()
//        }



        QmlImageButton{
            id:imgRefresh
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            imgSourseNormal:"qrc:/images/cruise_presetLess.png"
            imgSourseHover: imgSourseNormal
            imgSoursePress:"qrc:/images/cruise_presetLessP.png"

            onClick:{
                presetPtModel.clear();
                click_flush()
            }
        }

    }

}
