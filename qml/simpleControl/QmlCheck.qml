import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

CheckBox{
    id:checkedRemPwd

    property string indImg: "qrc:/images/client_remPwd.png"
    property string indImgPressed: "qrc:/images/client_remPwd_S.png"
    property color colorNor: "#9B9B9B"
    property color colorPressed: "#000000"
    signal s_Checked(bool ischecked)

    onCheckedChanged: {



    }

    style: CheckBoxStyle {
        indicator:
            Image {
            width: 12
            height: 12
            source: control.checked?indImg:indImgPressed
        }

        label: Text {
            text: control.text
            font.family: "Roboto-Medium"
            font.pointSize: 10
            color: control.checked ? colorNor : colorPressed
            verticalAlignment: Text.AlignVCenter
        }
    }
}
