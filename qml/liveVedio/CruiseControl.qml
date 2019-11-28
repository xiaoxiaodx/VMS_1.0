import QtQuick 2.0
import QtQuick.Controls 2.5
import "../simpleControl"

Rectangle {


    property int nameIndex: 2
    property int trackNameIndex: 0
    Rectangle{
        width: parent.width
        height: 1
        color: "black"
    }


    ListModel{//预置点
        id:presetPtModel

    }

    ListModel{//预置点 因为combox限制了数据模型必须为单数据模型，所以额外增加一个在轨迹设置里面使用的数据模型，需要与presetPtModel保持同步
        id:trackPresetPtModel
    }


    ListModel{//巡航轨迹
        id:cruisetrackModel
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

            onClick_flush:  {
                var map;
                devicemanagerment.funP2pSendData("hello","getptzpreset",map)
            }
            onClick_addPresetPt:{

                var map = {presetname:"dmj"+(++nameIndex)};
                devicemanagerment.funP2pSendData("hello","setptzpreset",map)
            }
            onClick_removePresetPt: {

                var map = {presetid:smap.get(presetIndex).presetid};


                devicemanagerment.funP2pSendData("hello","removeptzpreset",map)
            }

            onClick_moveToPreset: {
                var map = {presetid:smap.get(presetIndex).presetid};
                devicemanagerment.funP2pSendData("hello","gotoptzpreset",map)
            }
        }


        StackView{
            id: stack
            property int configIndex: -1
            initialItem: cruiseControlCmp

            Component{
                id:cruiseControlCmp
                CruiseTrack{
                    id:cruiseTrackSet
                    border.color: "black"
                    color: "transparent"
                    onTrackSet: {

                        configIndex = trackIndex
                        stack.push(cruiseTrackSetCmp)

                    }

                    onClick_playTrack: ;

                    onClick_stopTrack: ;

                    onClick_addTrack:cruisetrackModel.append({trackName:"track"+trackNameIndex,trackArr:[{showStr:"11",time:0,speed:0},{showStr:"11",time:0,speed:0}]})

                    onClick_removeTrack:;
                }
            }

            Component{
                id:cruiseTrackSetCmp
                CuriseTrackSet{
                    id:cruiseTrackSet
                    border.color: "black"
                    color: "transparent"

                    onSEnsure:stack.pop()
                    onSCancel: stack.pop()

                    Component.onCompleted: cruiseTrackSet.trackArrModel = cruisetrackModel.get(configIndex).trackArr

                }
            }

        }



    }



    Connections{
        target: devicemanagerment
        onSignal_getptzpreset:{

            var listPreset = smap.presets;
            for(var i=0;i<listPreset.length;i++){
                var preset = listPreset[i];

                presetPtModel.append({showStr:preset.presetname,presetid:preset.presetid,x:preset.x,y:preset.y,z:preset.z})
                trackPresetPtModel.append({showStr:preset.presetname})
                nameIndex = preset.presetid
            }

        }
    }
}
