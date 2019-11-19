#include "mqttwork.h"
#include <QDateTime>
#include <QJsonObject>
#include <QJsonDocument>

MqttWork::MqttWork(QObject *parent) : QObject(parent)
{

    initVariant();
}

void MqttWork::initVariant()
{
    m_client = nullptr;


    mainServerSubTopicName = "gzstreammedia/mainserver/winpc"+QString::number(QDateTime::currentSecsSinceEpoch(),10)+"/pullmsg";
    mainServerPubTopicName = "gzstreammedia/web/mainserver/pullmsg";

}

void MqttWork::slot_createMqttConnect(QString ip,int port)
{

    if(m_client == nullptr){
        m_client = new QMqttClient();
        m_mqttPacket = new MqttPacket;

        m_mqttPacket->setMainServerPubTopicName(mainServerPubTopicName);
        m_mqttPacket->setMainServerSubTopicName(mainServerSubTopicName);

        connect(m_client,&QMqttClient::connected,this,&MqttWork::slot_conneted);
        connect(m_client,&QMqttClient::disconnected,this,&MqttWork::slot_disConneted);
        connect(m_client,&QMqttClient::messageReceived,this,&MqttWork::slot_receMsg);
    }

    if (m_client->state() == QMqttClient::Disconnected) {

        qDebug()<<"mqtt try to connted ";

        //m_client->setAutoKeepAlive(true);
        m_client->setHostname(ip);
        m_client->setPort(port);

        m_client->connectToHost();
    } else {//断开连接

        m_client->disconnectFromHost();
    }

}
void MqttWork::funLogin(QString ip,int port,QString acc,QString pwd)
{


    account = acc;
    password = pwd;
    slot_createMqttConnect(ip,port);



}

void MqttWork::subscribeTopic(QString topic)
{
    //    QMqttTopicFilter topicF;
    //    topicF.setFilter(mainServerSubTopicName);

    m_client->state();
    if(m_client != nullptr){

        consoleDebugStr("mqtt try to subscribe "+mainServerSubTopicName);
        auto subscription = m_client->subscribe(mainServerSubTopicName);
        if (!subscription) {

            consoleDebugStr("mqtt subscribe fail");

            return;
        }else
            consoleDebugStr("mqtt subscribe succ");
    }
}


void MqttWork::publishMsg(QString cmd,QVariant msgContent)
{


    QByteArray sendArr = m_mqttPacket->makePacket(cmd,msgContent);
    if (m_client->publish(mainServerPubTopicName, sendArr) == -1){

        consoleDebugStr("publish fail :");

    }else {
        consoleDebugStr("publish succ :   "+QString(sendArr));
    }

}

void MqttWork::slot_conneted()
{


    subscribeTopic("");

    QVariantMap map;

    map.insert("username",account);
    map.insert("password",password);
    publishMsg("loginmainserver",map);

    emit signal_connect(true);
    qDebug()<<"服务器连接成功";
}

void MqttWork::slot_disConneted()
{

    emit signal_connect(false);
    qDebug()<<"服务器连接失败";
}

void MqttWork::slot_receMsg(const QByteArray &message, const QMqttTopicName topic)
{


    qDebug()<<"unPacket  : "<<topic.name()<<"   "<<QString(message);

    QMap<QString,QVariant> map = m_mqttPacket->unPacket(topic.name(),message);


    if(map.value("cmd").toString().compare("loginmainserver")==0){
        if(map.value("statuscode").toInt()==200)
            emit signal_login(true,"login successful");
        else if (map.value("statuscode").toInt()==401)
            emit signal_login(false,"Incorrect account or password");
        else if(map.value("statuscode").toInt()==400)
            emit signal_login(false,"Request error");;

    }else if(map.value("cmd").toString().compare("getdevicelist")==0){

    }else if (map.value("cmd").toString().compare("getserverlist")==0) {

        QVariantList listSer =  map.value("serverlist").toList();

        emit signal_listSer(listSer);

        for(int i=0;i<listSer.count();i++){

            QVariantMap variant = listSer.at(i).toMap();

            publishMsg("getdeviceinfobyserverid",variant);

        }

    }else if (map.value("cmd").toString().compare("getdeviceinfobyserverid")==0) {

        QVariantList listDev =  map.value("devicelist").toList();

        emit signal_listdevice(map);
        for(int i=0;i<listDev.count();i++){;

            QVariantMap variant = listDev.at(i).toMap();
            publishMsg("getmediaserverbasicinfo",variant);
        }
    }else if (map.value("cmd").toString().compare("getmediaserverbasicinfo")==0){
        emit signal_DeviceInfo(map);
    }else if (map.value("cmd").toString().compare("modifyusrpasswd")==0) {
        int statuscode = map.value("statuscode").toInt();
        if(statuscode == 200)
            signal_modifyPwd(true,tr("Successfully modified"));
        else if(statuscode == 401)
            signal_modifyPwd(false,tr("Password modification failed! Authentication failure"));
        else
            signal_modifyPwd(false,tr("Password modification failed!"));
    }else if (map.value("cmd").toString().compare("loginoutmainserver")==0) {
        int statuscode = map.value("statuscode").toInt();
        if(statuscode == 200)
            signal_loginout(true,tr("Successfully exit"));
        else
            signal_loginout(false,tr("exit failed!"));
    }

}

void MqttWork::consoleDebugStr(QString strContent,QString filename,QString funcName, int lineCount)
{

    qDebug()<<strContent;
}
