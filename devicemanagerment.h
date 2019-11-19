#ifndef DEVICEMANAGERMENT_H
#define DEVICEMANAGERMENT_H

#include <QObject>
#include "deviceinfo.h"


class DeviceManagerment : public QObject
{
    Q_OBJECT
    Q_INVOKABLE void funConnectP2pDevice(QString name,QString did,QString acc,QString pwd);

    QML_PROPERTY(int,typeNetwork)

    Q_ENUMS(ERR_CODE)
public:
    explicit DeviceManagerment(QObject *parent = nullptr);

    enum ERR_CODE{
        DEVICE_ADD_DIFFPAR = 0,//参数不同

    };

signals:
    void signal_err(int errCode,QVariant varint = 0);


    //回调
    void signal_p2pConnectCallback(bool isSucc,QString name,QString errStr );

public slots:

    void slot_recP2pConenctState(bool isSucc,QString name,QString errStr);

private:
   void connectDevice();
   QList<DeviceInfo*> listDeviceInfo;
};

#endif // DEVICEMANAGERMENT_H
