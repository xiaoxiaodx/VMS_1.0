import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.12
import QtQml 2.12

import "../qml/homePage"
import "../qml/liveVedio"
import DeviceManagerment 1.0
Window {

    id: main;
    flags:Qt.FramelessWindowHint |
          Qt.WindowMinimizeButtonHint |
          Qt.Window
    property bool isMainContent: false
    property bool isSpecilState: false      //窗口在最大化的时候调用最小化 会出现特例（窗口还原后大小不再是最大化了）
    visible: true

    width:860
    height:499

    visibility : "Windowed"



    ListModel{
        id:listdeviceInfo

    }
    DeviceManagerment{
        id:devicemanagerment


    }
    QmlLogin{
        id:login
        width: parent.width
        height: parent.height

        visible: isMainContent?false:true
        onS_Login: {

            main.x = Screen.desktopAvailableWidth/6
            main.y = Screen.desktopAvailableHeight/8
            main.width=2*Screen.desktopAvailableWidth/3
            main.height= 3*Screen.desktopAvailableHeight/4
            isMainContent = true
        }
    }

    MainContent{
        id:maincontent
        width: parent.width
        height: parent.height
        visible: isMainContent?true:false

        onWinMin1: {
            if(main.visibility === 4)
                isSpecilState = true;

            main.visibility = "Minimized"

        }
        onWinMax1: {
            if(main.visibility === 2)

                main.visibility = "Maximized"

            else if(main.visibility === 4)
                main.visibility = "Windowed"

        }
        onWinClose1:Qt.quit();
        onDragPosChange1:main.setDlgPoint(mx,my);
    }


    onVisibilityChanged: {
        if(isSpecilState){
            if(main.visibility === 2){
                main.visibility = "Maximized"
                isSpecilState = false;
            }
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
            backColor: "#383838"
            txtColor:"#ffffff"
            maxWid: rect.width/2

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
