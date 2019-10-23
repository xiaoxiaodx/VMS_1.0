import QtQuick 2.0

Rectangle {



    property int multiScreenNum: 1
    property color bordColor: "green"


    color: "red"
    Rectangle{
        id:screen1
        border.width: 4
        border.color: "red"
        color: "gray"


        width: parent.width
        height: parent.height



    }

    Rectangle{
        id:screen2
        border.width: 4
        border.color: "red"
        color: "gray"

    }

    Rectangle{
        id:screen3
        border.width: 4
        border.color: "red"
        color: "gray"

    }

    Rectangle{
        id:screen4
        border.width: 4
        border.color: "red"
        color: "gray"

    }

    Rectangle{
        id:screen5
        border.width: 4
        border.color: "red"
        color: "gray"

    }
    Rectangle{
        id:screen6
        border.width: 4
        border.color: "red"
        color: "gray"

    }
    Rectangle{
        id:screen7
        border.width: 4
        border.color: "red"
        color: "gray"

    }
    Rectangle{
        id:screen8
        border.width: 4
        border.color: "red"
        color: "gray"

    }
    Rectangle{
        id:screen9
        border.width: 4
        border.color: "red"
        color: "gray"

    }
    Rectangle{
        id:screen10
        border.width: 4
        border.color: "red"
        color: "gray"

    }


    function setMultiScreenNum(number){

        if(number === 1){

        }

    }


}
