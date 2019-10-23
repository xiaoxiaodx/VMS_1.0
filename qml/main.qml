import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.12
import QtQml 2.12


Window {

    id: main;
    visible: true
    flags:Qt.FramelessWindowHint |
          Qt.WindowMinimizeButtonHint |
          Qt.Window

    property bool fullscreen: false
    property bool isPress: false

    property int mWindowStates: 4   // 2：正常 4：最大化

    property int preX:0
    property int preY:0
    property int preWidth:0
    property int preHeight:0

    property string toastStr: ""

    property string versionstr: "V1.2"

    property bool isSpecilState: false      //窗口在最大化的时候调用最小化 会出现特例（窗口还原后大小不再是最大化了）

    minimumWidth:  Screen.desktopAvailableWidth/2
    minimumHeight: Screen.desktopAvailableHeight/2

    width: Screen.desktopAvailableWidth/2
    height: Screen.desktopAvailableHeight/2

    visibility : "Maximized"
    color: "#BDBDBD"


    onVisibilityChanged: {

        //console.debug(" HomeContent:"+mhomecontent.x  + "   "+ mhomecontent.y)
        if(isSpecilState){
            if(main.visibility === 2){
                main.visibility = "Maximized"
                isSpecilState = false;
            }
        }

    }

    Rectangle{
        id:rect

        width: main.width
        height: main.height
        color: "#BDBDBD"
        HomeTitleBar{
            id:mTitleBar
            width: parent.width
            height: 60
            color: "#3f8eff"
            versionStr:versionstr
            z:2
            onWinMin: {

               if(main.visibility === 4)
                    isSpecilState = true;

                main.visibility = "Minimized"
            }
            onWinMax: {

                if(main.visibility === 2)
                    main.visibility = "Maximized"

                else if(main.visibility === 4)
                    main.visibility = "Windowed"


            }
            onWinClose:Qt.quit();
            onDragPosChange:setDlgPoint(mx,my);

            onSetFilePath:mhomecontent.openDlgFilePath();

        }

        HomeStateBar{

            id:mhomeState
            anchors.top:mhomecontent.bottom
            anchors.topMargin: 2
            width: parent.width
            height: 65
            z:3
            onS_multiScreenNumChange: {
                //几乘几的屏幕显示
                //mhomecontent.setMultiScreen(num);

                if(num < 5)
                    mhomecontent.setMultiScreenNum (num);

            }
        }

        HomeContent{
            id:mhomecontent
            anchors.top: mTitleBar.bottom
            anchors.left: parent.left
            width: parent.width
            height: parent.height - mTitleBar.height - mhomeState.height-2
            z:1

            onS_addDevice: {
                myDlgAddDevice.open();
            }

            onSt_showToastMsg: {

                showToast(str1)


            }

            onS_multiScreenNumChange:{

                mhomeState.setSelectItem (num)

            }

            onS_mqttLoginSucc: {
                    myLogin.close();
            }

        }




        Loader{
            id:loaderToast
            z:10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80
            sourceComponent: null
        }
        Component {
            id: toast
            QmlToast{
                txtStr:toastStr
                backColor: "#ffffff00"
                txtColor:"#ee555555"
                maxWid: rect.width/2

            }
        }

    }



    QmlDialogAddDevice{
        id: myDlgAddDevice
        onS_deviceIDstr: {

            mhomecontent.addDevice(1,strID,strAccoount,strPassword,strIp,strPort)
        }

        onS_showToast: {
            showToast(str1)
        }
    }



    function showToast(stri){
        toastStr = stri;
        loaderToast.sourceComponent = null;
        loaderToast.sourceComponent = toast
    }


    function saveWindowState(tChange)
    {
        mWindowChange = tChange
        preX = main.x;
        preY = main.y
        preWidth = main.width
        preHeight = main.height

    }
    function recoveryWindowState()
    {
        main.x = preX;
        main.y = preY;
        main.width = preWidth
        main.height = preHeight
        mWindowChange = 0;
    }
    function setDlgPoint(dlgX ,dlgY)
    {
        //设置窗口拖拽不能超过父窗口
        if(main.x + dlgX < 0)
        {
            main.x = 0
        }
        else if(main.x + dlgX > Screen.desktopAvailableWidth - main.width)
        {
            main.x = Screen.desktopAvailableWidth - main.width
        }
        else
        {
            main.x = main.x + dlgX
        }
        if(main.y + dlgY < 0)
        {
            main.y = 0
        }
        else if(main.y + dlgY >  Screen.desktopAvailableHeight - main.height)
        {
            main.y =  Screen.desktopAvailableHeight - main.height
        }
        else
        {
            main.y = main.y + dlgY
        }
    }


    Timer{
        id:timer
        function setTimeOut(delayTime,fun){
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(fun);
            timer.triggered.connect(function release(){
                timer.triggered.disconnect(fun);
                timer.triggered.disconnect(release);
            })
            timer.start();
        }
    }
}
