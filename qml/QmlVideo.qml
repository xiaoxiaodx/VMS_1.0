import QtQuick 2.5
import XVideo 1.0
import QtQuick.Controls 1.4

Rectangle {

    property bool fullScreen: true
    border.width: 2
    border.color: "#ff0000"

    property string msgStrTip: ""
    property string msgStrWait: ""

    property string defaultIp: ""
    property string defaultDid: ""
    property string defaultPort: ""
    signal doubleClick(bool isFullScreen);

    Column{
        width: parent.width
        height: parent.height

        Row{
            width: parent.width
            height: 30
            Rectangle{
                color: "#00ffffff"
                width: 10
                height: 30
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {

                anchors.verticalCenter: parent.verticalCenter

                text: qsTr("ip:")
            }

            TextInput{
                id:ipStr
                width: 80
                height:parent.height
                text:defaultIp//"10.67.1.119"
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("port:")
            }

            TextInput{
                id:portStr
                width:60
                height:parent.height
                text:defaultPort//"8064"
                verticalAlignment: Text.AlignVCenter//(2)
            }

            Button{
                id:connect
                text: qsTr("connect server")
                width: 100
                height: header.height-4
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {

                    video.connectServer(ipStr.text,portStr.text);

                }
            }

        }

        Row{
            id:header
            width: parent.width
            height: 30
            spacing: 20

            Rectangle{
                color: "#00ffffff"
                width: 5
                height: 30
                anchors.verticalCenter: parent.verticalCenter
            }


            Rectangle{
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                width: txt.width + txtInput.width+5
                border.width: 1
                border.color: "#ffff0000"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    id: txt
                    text: qsTr(" device id：")
                }

                TextInput{
                    id:txtInput

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: txt.right
                    height:parent.height
                    text:defaultDid//"INEW-004040-JXMBB"
                    wrapMode:TextInput.WordWrap
                    verticalAlignment: Text.AlignVCenter//(2)
                }
            }

            Rectangle{
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                width: txt1.width + txtInput1.width+5
                border.width: 1
                border.color: "#ffff0000"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    id: txt1
                    text: qsTr(" user name：")
                }

                TextInput{
                    id:txtInput1
                    anchors.left: txt1.right
                    height:parent.height
                    text:"admin"
                    wrapMode:TextInput.WordWrap
                    verticalAlignment: Text.AlignVCenter//(2)
                }
            }

            Rectangle{
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                width: txt2.width + txtInput2.width+5

                border.width: 1
                border.color: "#ffff0000"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    id: txt2
                    text: qsTr(" password：")
                }

                TextInput{
                    id:txtInput2
                    anchors.left: txt2.right
                    height:parent.height
                    text:"admin"
                    wrapMode:TextInput.WordWrap
                    verticalAlignment: Text.AlignVCenter//(2)
                }
            }

            Button{
                id:btnSend
                text: qsTr("send Authentication")
                width: 150
                height: header.height-4
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    video.sendAuthentication(txtInput.text,txtInput1.text,txtInput2.text);
                }
            }

        }

        XVideo{
            id:video
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width-4;
            height: parent.height-4-header.height;

            onSignal_loginStatus: {

                msgStrTip = msg;
                loaderToast.sourceComponent = null;
                loaderToast.sourceComponent = toast;

            }

            onSignal_waitingLoad: {

                if(msgStrWait === msgload)
                    return;
                msgStrWait = msgload
                loaderWait.sourceComponent = waiteLoad;

            }
            onSignal_endLoad: {
                msgStrWait = "";
                loaderWait.sourceComponent = null;
            }

            Loader{
                id:loaderToast
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 100
                sourceComponent: null
            }

            Loader{
                id:loaderWait
                anchors.fill: parent
                sourceComponent: null
            }

            Component {
                id: toast
                QmlToast{

                    txtStr:msgStrTip
                    backColor: "#ffffff00"
                    txtColor:"#ee555555"
                    maxWid: video.width/2

                }
            }


            Component {
                id: waiteLoad
                QmlWaitingEllipsis{
                    mNumPt:6
                    mPtColor:"#21be2b"
                    mStrShow:qsTr(msgStrWait)
                }
            }



            Rectangle{

                color: "#00000000"
                anchors.fill: parent

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true

                    onPositionChanged: {



                    }

                    onExited: {


                    }

                    onDoubleClicked: {



                    }

                }
            }

        }
    }


}
