import QtQuick 2.0
import QtQuick.Controls 1.4


TableView {
    id: root

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    signal sDeviceConfig(var str)

    model:ListModel{
        id:listModel
        ListElement{
            devicename:qsTr("zhangsan")
            devicedid:18
            devicetype:qsTr("hello14565")
            networkstatus:"online"
        }


    }


    Component{
        id:itemDelegateText
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            elide: styleData.elideMode
            text: styleData.value
            font.pointSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
        }
    }

    Component{
        id:itemDelegateTextImg


        Rectangle{
            anchors.fill: parent

            color: "transparent"

            Rectangle{
                anchors.horizontalCenter:parent.horizontalCenter
                color: "transparent"
                height: parent.height
                width: img.width + txt.width + 5
                Image {
                    id: img
                    anchors.verticalCenter: parent.verticalCenter
                    source: styleData.value==="online"?"qrc:/images/deviceOnline":"qrc:/images/deviceOffline"
                }
                Text {
                    id:txt
                    anchors.left: img.right
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    color: styleData.value==="online"?"#67C23A":"#red"
                    elide: styleData.elideMode
                    text: styleData.value
                    font.pointSize: 14


                }
            }
        }
    }

    Component{
        id:itemDelegateImg


        Rectangle{
            color: "transparent"
            anchors.fill: parent
            Image {
                id: img
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/images/cruise_set"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: sDeviceConfig();
            }

        }


    }

    TableViewColumn{
        role:"devicename"
        title:qsTr("device name")
        width:(tableView.width)/columnCount
        delegate: itemDelegateText
    }

    TableViewColumn{
        role:"devicedid"
        title:qsTr("device did")
        width:(tableView.width)/columnCount
        delegate:itemDelegateText
    }

    TableViewColumn{
        role:"devicetype"
        title:qsTr("device type")
        width:(tableView.width)/columnCount
        delegate: itemDelegateText
    }

    TableViewColumn{
        role:"networkstatus"
        title:qsTr("network status")
        width:(tableView.width)/columnCount
        delegate: itemDelegateTextImg
    }
    TableViewColumn{
        role:"deviceconfig"
        title:qsTr("device config")
        width:(tableView.width)/columnCount
        delegate: itemDelegateImg
    }

    headerDelegate: Rectangle{
        height: 34
        border.width: 0
        color: "#383838"


        Text {
            id: headerName
            text: styleData.value
            font.pointSize: 12
            color: "white"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
        }
    }



    rowDelegate: Rectangle{
        id:rowRectangle
        property color rowColor: styleData.selected?"#3A3D41":(styleData.alternate ? "#383838":"#383838")//是否为奇数
        color:rowColor
        height: 30
        border.width: 0


    }

    backgroundVisible: false





}
