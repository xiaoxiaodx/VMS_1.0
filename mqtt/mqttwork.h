#ifndef MqttWork_H
#define MqttWork_H

#include <QObject>
#include <QDebug>
#include "QtMqtt/QMqttClient"
#include "mqttpacket.h"

class MqttWork : public QObject
{
    Q_OBJECT
public:
    explicit MqttWork(QObject *parent = nullptr);

    Q_INVOKABLE void funLogin(QString ip,int port,QString acc,QString pwd);
    Q_INVOKABLE void subscribeTopic(QString topic);
    Q_INVOKABLE void publishMsg(QString cmd,QVariant msgContent);

signals:

    void signal_connect(bool isConnected);
    void signal_login(bool isLogiged,QString errStr);
    void signal_listdevice(QVariant variant);
    void signal_listSer(QVariant variant);
    void signal_DeviceInfo(QVariant variant);
    void signal_modifyPwd(bool isSucc,QString errStr);
    void signal_loginout(bool isSucc,QString errStr);
public slots:

    void slot_disConneted();
    void slot_conneted();
    void slot_receMsg(const QByteArray &message, const QMqttTopicName topic);
    void slot_createMqttConnect(QString ip,int port);
private:
    void consoleDebugStr(QString strContent,QString filename = "",QString funcName="", int lineCount=-1);
    void initVariant();

    QMqttClient *m_client;//mqtt client指针
    MqttPacket *m_mqttPacket;

    QString mainServerSubTopicName ;
    QString mainServerPubTopicName ;

    QString account;
    QString password;
};

#endif // MqttWork_H
