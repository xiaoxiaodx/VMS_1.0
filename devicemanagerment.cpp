#include "devicemanagerment.h"

DeviceManagerment::DeviceManagerment(QObject *parent) : QObject(parent)
{

    listDeviceInfo.clear();
}


void DeviceManagerment::funConnectP2pDevice(QString name, QString did, QString acc, QString pwd)
{
    qDebug()<<" connectP2pDevice";

    int findIndex = -1;
    for(int i=0;i<listDeviceInfo.size();i++){
        DeviceInfo *info = listDeviceInfo.at(i);

        if(info->name().compare(name)==0){

            findIndex = i;
            break;
        }
    }

    if(findIndex==-1){

        DeviceInfo *info = new DeviceInfo;
        if(m_typeNetwork == 0){
            info->createP2pThread();

            emit info->signal_connectP2pDev(did,acc,pwd);

            connect(info,&DeviceInfo::signal_connectP2p,this,&DeviceManagerment::slot_recP2pConenctState);
            listDeviceInfo.append(info);
        }

    }else{
        signal_err(DEVICE_ADD_DIFFPAR,"The name already exists");
    }

}

void DeviceManagerment::slot_recP2pConenctState(bool isSucc,QString name,QString errStr)
{

    qDebug()<<"slot_recP2pConenctState :"<<isSucc <<"   "<<name<<"  "<<errStr;
}
