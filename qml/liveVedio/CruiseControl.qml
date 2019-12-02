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
        z:1
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
                if(modelDataCurrentIndex<0){
                    showToast(qsTr("no device specified"))
                    return;
                }
                var deviceName =  listDeviceDataModel.get(modelDataCurrentIndex).deviceName
                var map;
                devicemanagerment.funP2pSendData(deviceName,"getptzpreset",map)
            }
            onClick_addPresetPt:{
                if(modelDataCurrentIndex<0){
                    showToast(qsTr("no device specified"))
                    return;
                }
                var deviceName =  listDeviceDataModel.get(modelDataCurrentIndex).deviceName
                var map = {presetname:"dmj"+(++nameIndex),name:"dmj"+nameIndex};
                devicemanagerment.funP2pSendData(deviceName,"setptzpreset",map)
            }
            onClick_removePresetPt: {
                if(modelDataCurrentIndex<0){
                    showToast(qsTr("no device specified"))
                    return;
                }
                var deviceName =  listDeviceDataModel.get(modelDataCurrentIndex).deviceName
                var map = {presetid:presetPtModel.get(presetIndex).presetid,name:presetPtModel.get(presetIndex).showStr};
                devicemanagerment.funP2pSendData(deviceName,"removeptzpreset",map)
            }

            onClick_moveToPreset: {
                if(modelDataCurrentIndex<0){
                    showToast(qsTr("no device specified"))
                    return;
                }
                var deviceName =  listDeviceDataModel.get(modelDataCurrentIndex).deviceName
                var map = {presetid:presetPtModel.get(presetIndex).presetid,name:presetPtModel.get(presetIndex).showStr};
                devicemanagerment.funP2pSendData(deviceName,"gotoptzpreset",map)
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

                    onClick_playTrack: {
                        trackTime.curTrackIndex = 0;
                        trackTime.timeTrackArr = cruisetrackModel.get(trackIndex).trackArr;
                        trackTime.start();
                    }

                    onClick_stopTrack: trackTime.stop();

                    onClick_addTrack:cruisetrackModel.append({trackName:"track"+trackNameIndex,trackArr:[]})

                    onClick_removeTrack:cruisetrackModel.remove(trackIndex);
                }
            }

            Component{
                id:cruiseTrackSetCmp
                CuriseTrackSet{
                    id:cruiseTrackSet
                    border.color: "black"
                    color: "transparent"

                    trackArrModel:cruisetrackModel.get(configIndex).trackArr

                    onSEnsure:stack.pop()

                    onSCancel:stack.pop()

                    onSAddPreset: {
                        console.debug("     onSAddPreset    "+cruisetrackModel.get(configIndex).trackArr.count)
                        cruisetrackModel.get(configIndex).trackArr.append({presetIndex:0,time:0,speed:0});

                    }
                    onSPresetDown: {

                        var trackArr = cruisetrackModel.get(configIndex).trackArr
                        if(trancksetIndex<(trackArr.count-1))
                            trackArr.move(trancksetIndex,trancksetIndex+1,1)

                    }
                    onSPresetUp: {
                        var trackArr = cruisetrackModel.get(configIndex).trackArr
                        if(trancksetIndex>0)
                            trackArr.move(trancksetIndex,trancksetIndex-1,1)
                    }
                    onSPresetRemove: {
                        var trackArr = cruisetrackModel.get(configIndex).trackArr
                        trackArr.remove(trancksetIndex)
                    }

                    onSDeviceIndexChange: {

                         var trackArr = cruisetrackModel.get(configIndex).trackArr

                        trackArr.get(trancksetIndex).presetIndex = mpresetIndex
                    }


                    //Component.onCompleted: cruiseTrackSet.trackArrModel = cruisetrackModel.get(configIndex).trackArr

                }
            }

        }
    }

    Timer{
        id:trackTime
        property var timeTrackArr;
        property var curTrackIndex;
        interval: 500
        repeat: true
        onTriggered: {


            var tmpindex = timeTrackArr.get(curTrackIndex).presetIndex;

            console.debug("onTriggered  Arrcount" + timeTrackArr.count+"    devName:"+tmpindex)

            curTrackIndex++;

            if(curTrackIndex >= (timeTrackArr.count-1))
                curTrackIndex = 0


            var map = {presetid:presetPtModel.get(tmpindex).presetid,name:presetPtModel.get(tmpindex).showStr};
            devicemanagerment.funP2pSendData(listDeviceDataModel.get(modelDataCurrentIndex).deviceName,"gotoptzpreset",map)

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
        onSignal_setrtmpinfo:{


        }
        onSignal_gotoptzpreset:{

        }
        onSignal_removeptzpreset:{


            for(var i=0;i<presetPtModel.count;i++){
                if(presetPtModel.get(i).showStr === smap.name){
                    presetPtModel.remove(i)
                    trackPresetPtModel.remove(i)
                    return;
                }

            }
        }
    }
}
