/*
  父类使用该组件格式,延迟加载
            Loader{
                id:loaderWait
                anchors.fill: parent
                sourceComponent: null
            }

            Component {
                id: waiteLoad
                WaitingLoad{
                    mNumPt:6
                    mPtColor:"#21be2b"
                    mStrShow:"loading"
                }
            }
*/


import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Rectangle{

    property int mNumPt: 0
    property color mPtColor: "#faaaaaaa"
    property string mStrShow: ""
    width: txt.width + control.width
    height: txt.height

    color: "#00000000"
    Text {
        id: txt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: mPtColor
        font.bold: true
        font.pixelSize: 20
        text: qsTr(mStrShow)
    }

    PageIndicator {
        id: control
        anchors.left: txt.right
        anchors.bottom: txt.bottom
        anchors.bottomMargin: -5
        count: mNumPt
        currentIndex: 1

        delegate: Rectangle {
            implicitWidth: 4
            implicitHeight: 4

            radius: width / 2
            color: mPtColor

            opacity: index === control.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

            Behavior on opacity {
                OpacityAnimator {
                    duration: 200
                }
            }
        }

        NumberAnimation on currentIndex {
            loops: Animation.Infinite
            from:0 ;
            to: mNumPt;
            duration: 1000
        }
    }
}
