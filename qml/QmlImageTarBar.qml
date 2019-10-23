import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

TabBar {
    property alias myModel: myModel
    property int lastIndex: 0

    id: bar
    currentIndex: 0

    spacing: 10
    ListModel {
        id: myModel
    }

    Repeater {
        id: repeater
        model: myModel

        TabButton {
            property alias imageSource: image.source

            height: bar.height

            background:Image{
                id: image
                width: 36
                height: 36
                anchors.horizontalCenter: parent.horizontalCenter
                source: (model.index === bar.currentIndex) ? modelSrcPress : modelSrc
            }
            onHoveredChanged: {
                if (model.index !== bar.currentIndex){

                    hovered ? image.source = modelSrcHover : image.source = modelSrc
                }
            }
            onClicked: {
                repeater.itemAt(bar.lastIndex).imageSource = myModel.get(bar.lastIndex).modelSrc;

                image.source = modelSrcPress;

                bar.lastIndex = model.index;
            }
        }
    }


    function setSelectItem(parIntex){

         currentIndex = parIntex;

//        console.debug("setSelectItem    "+ parIntex);
//        console.debug("lastIndex    "+ lastIndex);

        repeater.itemAt(lastIndex).imageSource = myModel.get(lastIndex).modelSrc;

        repeater.itemAt(parIntex).imageSource = myModel.get(parIntex).modelSrcPress;


        lastIndex = parIntex;
    }
}
