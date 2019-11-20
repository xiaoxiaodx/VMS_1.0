#ifndef DEVICEMANAGERMENT_H
#define DEVICEMANAGERMENT_H

#include <QObject>
#include "deviceinfo.h"




class DeviceManagerment : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void funConnectP2pDevice(QString name,QString did,QString acc,QString pwd);

    QML_PROPERTY(int,typeNetwork)

    Q_PROPERTY(QVariant listDeviceInfo READ listDeviceInfo WRITE setlistDeviceInfo NOTIFY listDeviceInfoChange);



    Q_ENUMS(ERR_CODE)
public:
    explicit DeviceManagerment(QObject *parent = nullptr);

    enum ERR_CODE{
        DEVICE_ADD_DIFFPAR = 0,//参数不同

    };
    QVariant listDeviceInfo();
    void setlistDeviceInfo(QVariant tmpList);
signals:
    void listDeviceInfoChange();
    void signal_err(int errCode,QVariant varint = 0);

    void signal_connectDev(QString deviceDid,QString name,QString pwd);
    //回调
    void signal_p2pConnectCallback(bool isSucc,QString name,QString errStr );

public slots:

    void slot_p2pConnetState(QString did,bool isSucc);
    void slot_recP2pLoginState(bool isSucc,QString name,QString errStr);
    void slot_p2pErr(QString did,QString str);

private:

   DeviceInfo* findDeviceName(QString did);

   void connectDevice();


   QList<DeviceInfo*> m_listDeviceInfo;

   //QList<DeviceInfo*> m_listDeviceInfo;
};

#endif // DEVICEMANAGERMENT_H
