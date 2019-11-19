#include "deviceinfo.h"

DeviceInfo::DeviceInfo()
{

}



void DeviceInfo::createP2pThread()
{

    if(p2pWorker == nullptr){

        p2pWorker = new P2pWorker;
        m_p2pThread = new QThread;
        p2pWorker->moveToThread(m_p2pThread);

        connect(p2pWorker,&P2pWorker::signal_sendH264,this,&DeviceInfo::slot_recH264,Qt::DirectConnection);
        connect(p2pWorker,&P2pWorker::signal_sendPcmALaw,this,&DeviceInfo::slot_recPcmALaw,Qt::DirectConnection);


        connect(this,&DeviceInfo::signal_connectP2pDev,p2pWorker,&P2pWorker::slot_connectDev);


        connect(m_p2pThread,&QThread::finished,p2pWorker,&P2pWorker::deleteLater);
        connect(m_p2pThread,&QThread::finished,m_p2pThread,&QThread::deleteLater);

        m_p2pThread->start();

    }

}

void DeviceInfo::createTcpThread()
{

    worker = new TcpWorker();
    m_readThread = new QThread();
    worker->moveToThread(m_readThread);

    connect(worker,&TcpWorker::signal_sendH264,this,&DeviceInfo::slot_recH264,Qt::DirectConnection);
    connect(worker,&TcpWorker::signal_sendPcmALaw,this,&DeviceInfo::slot_recPcmALaw,Qt::DirectConnection);





}



//tcpworker 线程
void DeviceInfo::slot_recH264(char* h264Arr,int arrlen,quint64 time)
{



}


//tcpworker 线程
void DeviceInfo::slot_recPcmALaw( char * buff,int len,quint64 time)
{

}
