#include "p2pprotrol.h"

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
        jObject.insert("data",jObjectData);

    }else if(cmd.compare("getrecordinginfo")==0){

        QJsonObject jObjectData ;
        jObjectData.insert("method",msgContent.toMap().value("method").toInt());
        jObjectData.insert("time",msgContent.toMap().value("time").toString());
        jObject.insert("data",jObjectData);

    }else if(cmd.compare("getdevicelist")==0){


    }else if(cmd.compare("getserverlist")==0){


    }else if (cmd.compare("getdeviceinfobyserverid")==0) {


    }else if (cmd.compare("getmediaserverbasicinfo")==0) {


    }
    QJsonDocument jsDoc(jObject);
    return jsDoc.toJson();
}
QMap<QString,QVariant> P2pProtrol::unJsonPacket(QString cmd,QByteArray arr)
{
    QMap<QString,QVariant> map;

    QJsonDocument jsDoc = QJsonDocument::fromJson(arr);

    map.insert("cmd",cmd);
    map.insert("msgid",jsDoc.object().value("msgid"));
    map.insert("statuscode",jsDoc.object().value("statuscode"));

    if(cmd.compare("login")==0){

        sessionid = jsDoc.object().value("sessionid").toString();

    }else if(cmd.compare("modifyusrpasswd")==0){


    }

    return map;
}
