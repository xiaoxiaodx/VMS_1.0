#include "mqttpacket.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>

#include <QDebug>
MqttPacket::MqttPacket()
{

    mainServerSubTopicName = "";
    mainServerPubTopicName = "";
    sessionid = "";

}

void MqttPacket::setMainServerSubTopicName(QString str)
{
    mainServerSubTopicName = str;
}
void MqttPacket::setMainServerPubTopicName(QString str)
{
    mainServerPubTopicName = str;
}


QByteArray MqttPacket::makePacket(QString cmd,QVariant msgContent)
{

    QJsonObject jObject;
    jObject.insert("cmd",cmd);
    jObject.insert("method","request");
    jObject.insert("srctopic",mainServerSubTopicName);
    jObject.insert("desttopic",mainServerPubTopicName);
    jObject.insert("sessionid",sessionid);
    jObject.insert("msgid","0123");

    if(cmd.compare("loginmainserver")==0){

        QJsonObject jObjectData ;
        jObjectData.insert("username",msgContent.toMap().value("username").toString());
        jObjectData.insert("password",msgContent.toMap().value("password").toString());
        jObject.insert("data",jObjectData);
    }else if (cmd.compare("loginoutmainserver")==0) {

    }else if(cmd.compare("modifyusrpasswd")==0){

        QJsonObject jObjectData ;
        jObjectData.insert("username",msgContent.toMap().value("username").toString());
        jObjectData.insert("oldpassword",msgContent.toMap().value("oldpassword").toString());
        jObjectData.insert("newpassword",msgContent.toMap().value("newpassword").toString());
        jObject.insert("data",jObjectData);

    }else if(cmd.compare("getdevicelist")==0){

        QJsonObject jObjectData ;
        QString did = msgContent.toMap().value("deviceid").toString();
        if(did.compare("")!=0)
            jObjectData.insert("deviceid",did);

        jObject.insert("data",jObjectData);
    }else if(cmd.compare("getserverlist")==0){


    }else if (cmd.compare("getdeviceinfobyserverid")==0) {

        QJsonObject jObjectData ;



        QString token = msgContent.toMap().value("mediatoken").toString();
        QString desTop = "gzstreammedia/web/stream/"+token+"/pullmsg";

        jObjectData.insert("mediatoken",token);
        jObject.insert("desttopic",desTop);
        jObject.insert("msgid",token);
        jObject.insert("data",jObjectData);

    }else if (cmd.compare("getmediaserverbasicinfo")==0) {

        QJsonObject jObjectData ;
        QString token = msgContent.toMap().value("mediatoken").toString();
        jObjectData.insert("mediatoken",token);


        QString desTop = "gzstreammedia/web/stream/"+token+"/pullmsg";
        jObject.insert("msgid",msgContent.toMap().value("deviceid").toString());
        jObject.insert("desttopic",desTop);
        jObject.insert("data",jObjectData);

    }

    QJsonDocument jsDoc(jObject);

    return jsDoc.toJson();
}

QMap<QString,QVariant> MqttPacket::unPacket(QString topic,QByteArray arr)
{


    QMap<QString,QVariant> map;

    QJsonDocument jsDoc = QJsonDocument::fromJson(arr);

    QString cmd =  jsDoc.object().value("cmd").toString();


    map.insert("cmd",cmd);
    map.insert("msgid",jsDoc.object().value("msgid"));
    map.insert("statuscode",jsDoc.object().value("statuscode"));

    if(cmd.compare("loginmainserver")==0){
        QJsonObject jObjectData = jsDoc.object().value("data").toObject();

        sessionid = jObjectData.value("sessionid").toString();
        map.insert("sessionid",sessionid);

    }else if(cmd.compare("modifyusrpasswd")==0){


    }else if(cmd.compare("getdevicelist")==0){

        unPacketGetDevicelist(map,jsDoc);

    }else if(cmd.compare("getserverlist")==0){

        unPacketGetserverlist(map,jsDoc);

    }else if(cmd.compare("getdeviceinfobyserverid")==0){

        unPacketGetserverDevicelist(map,jsDoc);

    }else if(cmd.compare("getmediaserverbasicinfo")==0){
        QJsonObject jObjectData = jsDoc.object().value("data").toObject();
        map.insert("mediatoken",jObjectData.value("mediatoken").toString());
        map.insert("hostip",jObjectData.value("hostip").toString());
        map.insert("mediatoken",jObjectData.value("mediatoken").toString());

    }else if (cmd.compare("loginoutmainserver")==0) {

    }

    return map;
}


void MqttPacket::unPacketGetDevicelist(QMap<QString,QVariant> &map,QJsonDocument &jsDoc)
{

    map.insert("statuscode",jsDoc.object().value("statuscode").toString());

    QJsonArray jarr = jsDoc.object().value("data").toObject().value("devicelist").toArray();


    QVariantMap  mapGroup;//设备分组列表，每组下还有个设备列表


    for (int i=0;i<jarr.size();i++) {

        QJsonValue jvalue = jarr.at(i);

        QString mediatokenstr = jvalue.toObject().value("mediatoken").toString();

        QVariantMap deviceInfo;
        deviceInfo.insert("deviceid",jvalue.toObject().value("deviceid"));
        deviceInfo.insert("mediatoken",jvalue.toObject().value("mediatoken"));
        deviceInfo.insert("state",jvalue.toObject().value("state"));


        if(mapGroup.contains(mediatokenstr)){


            QVariantList vlist = mapGroup.value(mediatokenstr).toList();


            vlist.append(deviceInfo);

            mapGroup.insert(mediatokenstr,vlist);

        }else {

            QVariantList listDevice;
            listDevice.append(deviceInfo);

            mapGroup.insert(mediatokenstr,listDevice);


        }
    }

    map.insert("devicelist",mapGroup);
}

void MqttPacket::unPacketGetserverlist(QMap<QString,QVariant> &map,QJsonDocument &jsDoc)
{

    map.insert("statuscode",jsDoc.object().value("statuscode").toString());

    QJsonArray jarr = jsDoc.object().value("data").toObject().value("streammedialist").toArray();


    QVariantList mapServiceList;

    for (int i=0;i<jarr.size();i++) {

        QJsonValue jvalue = jarr.at(i);


        QVariantMap mediaSerInfo;
        mediaSerInfo.insert("mediatoken",jvalue.toObject().value("mediatoken").toString());
        mediaSerInfo.insert("name",jvalue.toObject().value("name").toString());
        mediaSerInfo.insert("location",jvalue.toObject().value("location").toString());
        mediaSerInfo.insert("onlinestate",jvalue.toObject().value("onlinestate").toString());

        mapServiceList.append(mediaSerInfo);
    }

    map.insert("serverlist",mapServiceList);
}

void MqttPacket::unPacketGetserverDevicelist(QMap<QString,QVariant> &map,QJsonDocument &jsDoc)
{


    QJsonArray jarr = jsDoc.object().value("data").toArray();


    QVariantList mapDeviceList;

    qDebug()<<" unPacketGetserverDevicelist "<<jarr.size();

    for (int i=0;i<jarr.size();i++) {

        QJsonValue jvalue = jarr.at(i);

        QVariantMap deviceinfo;

        deviceinfo.insert("deviceid",jvalue.toObject().value("deviceid"));
        deviceinfo.insert("mediatoken",jsDoc.object().value("msgid"));
        deviceinfo.insert("state",jvalue.toObject().value("onlinestate"));
        deviceinfo.insert("encoding",jvalue.toObject().value("encoding"));
        deviceinfo.insert("country",jvalue.toObject().value("country"));
        deviceinfo.insert("model",jvalue.toObject().value("model"));
        deviceinfo.insert("name",jvalue.toObject().value("name"));
        mapDeviceList.append(deviceinfo);
    }

    map.insert("devicelist",mapDeviceList);
}

