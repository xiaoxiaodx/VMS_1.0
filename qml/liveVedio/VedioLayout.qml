import QtQuick 2.0

Rectangle {

    id:root

    property int myLayoutSquare: 2  //几乘几的显示

    property alias myModel: repeater.model

    property int currentIndex: -1

    property string shotScreenFilePath1: ""
    property string recordingFilePath1: ""

    signal s_doubleClick(var index,var ismax);
    signal s_click(var clickIndex);
    signal s_showToastMsg(string str)
    signal s_deleteObject()
    signal s1_authenticationFailue(string str)

    color: "black"
    Repeater{
        id:repeater


        VideoLivePlay{
            id:video
            width: (index === currentIndex && model.isMax >0)?root.width:((root.width-myLayoutSquare)/myLayoutSquare)
            height:  (index === currentIndex && model.isMax>0)?root.height:((root.height-myLayoutSquare)/myLayoutSquare)

            x:(index === currentIndex && model.isMax >0)?0:(index%myLayoutSquare) * (width+1)
            y:(index === currentIndex && model.isMax >0)?0:Math.floor(index/myLayoutSquare) * (height+1)

            color: "#3A3D41"
            mip:model.ip
            mport:model.port
            mID:model.did
            mAcc:model.account
            mPwd:model.password
            mIsPlayAudio:(model.isMax>0)?true:false
            mIsCreateConenect:model.isCreateConnected>0?true:false
            mIsSelected: index === currentIndex
            shotScrennFilePath:shotScreenFilePath1
            recordingFilePath: recordingFilePath1
            onClick: {

                //console.debug("current index "+ index)

                currentIndex = index

                s_click(currentIndex)
            }

            onDoubleClick: {
                //console.debug("VideoLivePlay onDoubleClick")

                if( model.isMax > 0 )
                     model.isMax = 0;
                else
                    model.isMax = 1;

                s_doubleClick(index,model.isMax)
            }

            onS_showToastMsg:st_showToastMsg(str)

            onS_deleteObject:{

                isCreateConnected = 0;

            }

            onS_authenticationFailue: {
                s1_authenticationFailue(str)
            }
        }
    }

}
