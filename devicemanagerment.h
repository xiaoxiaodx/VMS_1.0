#ifndef DEVICEMANAGERMENT_H
#define DEVICEMANAGERMENT_H

#include <QObject>
#include "deviceinfo.h"




class DeviceManagerment : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void funConnectP2pDevice(QString name,QString did,QString acc,QString pwd);
    Q_INVOKABLE void funP2pSendData(QString name,QString cmd,QVariant map);




    QML_PROPERTY(int,typeNetwork)





    Q_ENUMS(ERR_CODE)
public:
    explicit DeviceManagerment(QObject *parent = nullptr);

    enum ERR_CODE{
        DEVICE_ADD_DIFFPAR = 0,//参数不同


        OTHER = 100,

    };

signals:

    void signal_err(int errCode,QVariant varint = 0);

    void signal_connectDev(QString deviceDid,QString name,QString pwd);



    //回调
    void signal_p2pConnectCallback(bool isSucc,QString name,QString did,QString acc,QString pwd,QString errStr);
    void signal_p2pConnectCallVideoData(QString name ,char* h264Arr,int arrlen);


public slots:

    void slot_recVedio(QString name ,char* h264Arr,int arrlen,quint64 time);
    void slot_p2pConnetState(QString did,bool isSucc);
    void slot_recP2pLoginState(bool isSucc,QString name,QString did,QString acc,QString pwd,QString errStr);
    void slot_p2pErr(QString did,QString str);

private:

   DeviceInfo* findDeviceName(QString did);

   void connectDevice();


   QList<DeviceInfo*> m_listDeviceInfo;

   //QList<DeviceInfo*> m_listDeviceInfo;
};

#endif // DEVICEMANAGERMENT_H
