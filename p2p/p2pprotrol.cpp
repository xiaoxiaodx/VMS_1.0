#include "p2pprotrol.h"
#include <qdebug>
P2pProtrol::P2pProtrol(QObject *parent) : QObject(parent)
{

}


QByteArray P2pProtrol::makeJsonPacket(QString cmd,QVariant msgContent)
{
    QJsonObject jObject;
    jObject.insert("cmd",cmd);
    jObject.insert("method","request");
    jObject.insert("msgid","0123");
    jObject.insert("sessionid",sessionid);
    if(cmd.compare("login")==0){

        QJsonObject jObjectData ;
        jObjectData.insert("username",msgContent.toMap().value("username").toString());
        jObjectData.insert("password",msgContent.toMap().value("password").toString());
        jObject.insert("data",jObjectData);


    }else if (cmd.compare("setptzmove")==0) {

        QJsonObject jObjectData ;
        jObjectData.insert("movecmd",msgContent.toMap().value("movecmd").toString());
        jObjectData.insert("direction",msgContent.toMap().value("direction").toString());
        jObjectData.insert("speedx",msgContent.toMap().value("speedx").toInt());
        jObjectData.insert("speedy",msgContent.toMap().value("speedy").toInt());
        jObjectData.insert("speedz",msgContent.toMap().value("speedz").toInt());
        jObjectData.insert("posx",msgContent.toMap().value("posx").toInt());
        jObjectData.insert("posy",msgContent.toMap().value("posy").toInt());
        jObjectData.insert("posz",msgContent.toMap().value("posz").toInt());

        jObject.insert("data",jObjectData);

    }else if(cmd.compare("setptzhomepoint")==0){//不需要填充参数



    }else if(cmd.compare("setmotiondetectparam")==0){
        QJsonObject jObjectData ;
        jObjectData.insert("enabled",msgContent.toMap().value("enabled").toInt());
        jObjectData.insert("sensitive",msgContent.toMap().value("sensitive").toInt());

        QJsonObject jObjectDataTimesection ;
        jObjectDataTimesection.insert("enabled",msgContent.toMap().value("enabled").toInt());
        jObjectDataTimesection.insert("starttime",msgContent.toMap().value("starttime").toString());
        jObjectDataTimesection.insert("endtime",msgContent.toMap().value("endtime").toString());

        jObjectData.insert("timesection",jObjectDataTimesection);
        jObject.insert("data",jObjectData);

    }else if(cmd.compare("getmotiondetectparam")==0){//获取移动帧参数，不需要填参


    }else if (cmd.compare("getdeviceinfobyserverid")==0) {


    }else if (cmd.compare("getmediaserverbasicinfo")==0) {


    }
    QJsonDocument jsDoc(jObject);
    return jsDoc.toJson();
}
QMap<QString,QVariant> P2pProtrol::unJsonPacket(QString cmd,QByteArray &arr)
{


    QMap<QString,QVariant> map;

    QJsonDocument jsDoc = QJsonDocument::fromJson(arr.data());



    map.insert("cmd",cmd);
    map.insert("msgid",jsDoc.object().value("msgid"));






    if(cmd.compare("login")==0){


        map.insert("statuscode",jsDoc.object().value("statuscode").toInt());
        //qDebug()<<"statuscode   "<<jsDoc.object().value("statuscode").toInt();
    }else if(cmd.compare("getmotiondetectparam")==0){

        QJsonObject jObjectData = jsDoc.object().value("data").toObject();

        map.insert("enable",jObjectData.value("enabled").toInt());
        map.insert("sensitive",jObjectData.value("sensitive").toInt());


    }

    return map;
}
