import QtQuick 2.0

Image {

    id: mimg


    //属于图片的属性
    property string imgSourseNormal: ""
    property string imgSourseHover: ""
    property string imgSoursePress: ""

    width: 36
    height: 36
    source: imgSourseNormal
    signal click();
    MouseArea{

        anchors.fill:parent
        hoverEnabled: true

        onEntered: {
             mimg.source = imgSourseHover

        }
        onExited: {

             mimg.source = imgSourseNormal
        }

        onClicked: {

          click()

        }
    }
}








