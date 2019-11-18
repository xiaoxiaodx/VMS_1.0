import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 2.1
import "../simpleControl"
Rectangle{
    id:stateBar

    property int isRecord: 0

    property int multiScreenNum: 2//2：代表2X2


    signal s_multiScreenNumChange(var num);

    color: "#131415"

    onMultiScreenNumChanged: {
        //console.debug("home stateBar 屏幕发生变化:"+multiScreenNum);
        s_multiScreenNumChange(multiScreenNum)

        bar.setSelectItem(multiScreenNum-1);
    }



    QmlImageTarBar{
        id: bar
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 50
        Component.onCompleted: {
            myModel.append({ "modelSrc": "qrc:/images/screen1.png", "modelSrcHover": "qrc:/images/screen1_enter.png", "modelSrcPress": "qrc:/images/screen1_enter.png"})
            myModel.append({ "modelSrc": "qrc:/images/screen4.png", "modelSrcHover": "qrc:/images/screen4_enter.png", "modelSrcPress": "qrc:/images/screen4_enter.png"})
            myModel.append({ "modelSrc": "qrc:/images/screen9.png", "modelSrcHover": "qrc:/images/screen9_enter.png", "modelSrcPress": "qrc:/images/screen9_enter.png"})
            myModel.append({ "modelSrc": "qrc:/images/screen16.png", "modelSrcHover": "qrc:/images/screen16_enter.png", "modelSrcPress": "qrc:/images/screen16_enter.png"})

            bar.setSelectItem(multiScreenNum-1);
        }

        onCurrentIndexChanged: {


            multiScreenNum = currentIndex+1;


        }
    }


    function setSelectItem(multiScreenNum){
        bar.setSelectItem(multiScreenNum-1);
    }



}
