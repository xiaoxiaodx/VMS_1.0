#include "devicemanagerment.h"

DeviceManagerment::DeviceManagerment(QObject *parent) : QObject(parent)
{

    m_typeNetwork = 0;



    m_listDeviceInfo.clear();

};

void DeviceManagerment::funP2pSendData(QString name,QString cmd,QVariant map)
{

    DeviceInfo *info = findDeviceName(name);

    if(info != nullptr){

        info->p2pWorker->p2pSendData(cmd,map);
    }else
        emit signal_err(OTHER,"not find device");


}
void DeviceManagerment::funConnectP2pDevice(QString name, QString did, QString acc, QString pwd)
{
    qDebug()<<" connectP2pDevice";


    DeviceInfo *info = findDeviceName(name);

    if(info == nullptr){

        DeviceInfo *info = new DeviceInfo;
        info->setname(name);
        if(m_typeNetwork == 0){

            m_listDeviceInfo.append(info);

            info->createP2pThread();
            info->p2pWorker->test();

            connect(info->p2pWorker,&P2pWorker::signal_sendH264,this,&DeviceManagerment::slot_recVedio);
            connect(info->p2pWorker,&P2pWorker::signal_loginState,this,&DeviceManagerment::slot_recP2pLoginState);
            connect(info->p2pWorker,&P2pWorker::signal_p2pConnectState,this,&DeviceManagerment::slot_p2pConnetState);

            //        connect(p2pWorker,&P2pWorker::signal_sendH264,this,&XVideo::slot_recH264,Qt::DirectConnection);
            //        connect(p2pWorker,&P2pWorker::signal_sendPcmALaw,this,&XVideo::slot_recPcmALaw,Qt::DirectConnection);

            connect(info->p2pWorker,&P2pWorker::signal_p2pErr,this,&DeviceManagerment::slot_p2pErr);

            emit info->signal_connectP2pDev(did,acc,pwd);


        }

    }else{
        signal_err(DEVICE_ADD_DIFFPAR,"The name already exists");
    }

}
void DeviceManagerment::slot_p2pConnetState(QString name,bool isSucc){


    qDebug()<<"slot_p2pConnetState  "<<isSucc;

    if(isSucc){

        QVariantMap map;
        map.insert("username","admin");
        map.insert("password","admin");

        DeviceInfo *info = findDeviceName(name);

        if(info != nullptr){
            info->p2pWorker->p2pSendData("login",map);

        }

    }

}

void DeviceManagerment::slot_recP2pLoginState(bool isSucc,QString name,QString did,QString acc,QString pwd,QString errStr)
{

    qDebug()<<"slot_recP2pConenctState :"<<isSucc <<"   "<<name<<"  "<<errStr;

    emit signal_p2pConnectCallback(isSucc,name,did,acc,pwd,errStr);

}

void DeviceManagerment::slot_recVedio(QString name ,char* h264Arr,int arrlen,quint64 time)
{
    emit signal_p2pConnectCallVideoData(name,h264Arr,arrlen);
}

void DeviceManagerment::slot_p2pErr(QString did,QString str)
{
    qDebug()<<"did  "<<did<<"   content:"<<str;
}


DeviceInfo* DeviceManagerment::findDeviceName(QString name)
{

    for(int i=0;i<m_listDeviceInfo.size();i++){
        DeviceInfo *info = m_listDeviceInfo.at(i);

        qDebug()<<info->name()<<"   "   <<name;
        if(info->name().compare(name)==0){

            return info;
        }
    }
    return nullptr;
}





