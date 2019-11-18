import QtQuick 2.0
import QtQuick.Controls 2.5
import "../simpleControl"

Rectangle {


    Rectangle{
        width: parent.width
        height: 1
        color: "black"
    }

    QmlTabBarButtonH{
        id:tabbarBtn
        height: 30
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 13
        btnBgColor:"#3A3D41"
        btnBgSelectColor:"black"
        mflagColor:"#00000000"
        textColor: "white"
        textSelectColor:"#409EFF"
        imageSrcEnter:"#444444"
        txtLeftMargin:16
        imageLeftMargin: 8
        textSize: 14
        Component.onCompleted: {

            tabbarBtn.barModel.append({txtStr:qsTr("preset point"),imgSrc:"qrc:/images/homemenuClo1se.png",imgSrcEnter:"qrc:/images/homemenuClose.png"})
            tabbarBtn.barModel.append({txtStr:qsTr("cruise track"),imgSrc:"undefine",imgSrcEnter:"undefine"})

        }

    }


    Rectangle{
        id:rectleftSwipView
        height: view.height
        width: 16
        anchors.right: view.left
        anchors.top: view.top
        color: "#272727"
        z:1
    }
    Rectangle{
        id:rectrightSwipView
        height: view.height
        width: 16
        anchors.left: view.right
        anchors.top: view.top
        color: "#272727"
        z:1
    }

    SwipeView {
        id: view
        z:0
        width: parent.width -32
        height: 224
        interactive:false
        anchors.top: tabbarBtn.bottom
        anchors.left: tabbarBtn.left

        currentIndex: tabbarBtn.curIndex
        CruisePresetPoint{

            id:cruise
            border.color: "black"
            color: "transparent"
        }


        StackView{
            id: stack
            initialItem: cruiseControlCmp

            Component{
                id:cruiseControlCmp
                CruiseTrack{
                    id:cruiseTrackSet
                    border.color: "black"
                    color: "transparent"
                    onTrackSet: stack.push(cruiseTrackSetCmp)
                }
            }

            Component{
                id:cruiseTrackSetCmp
                CuriseTrackSet{
                    id:cruiseTrackSet
                    border.color: "black"
                    color: "transparent"

                }
            }

        }



    }


}
