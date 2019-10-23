#include "commonparameter.h"


bool CommonParameter::isPossibleAccessInternet = true;
QMutex *CommonParameter::SingletonMutex = new QMutex;
CommonParameter * CommonParameter::commonParameter = nullptr;

CommonParameter::CommonParameter(QObject *parent) : QObject(parent)
{
    checkNetWorkOnline();
}

void CommonParameter::statrTimingDetectionNetWork()
{

    timer = new QTimer;
    connect(timer,&QTimer::timeout,this,&CommonParameter::checkNetWorkOnline);
    timer->start(5000);

}

void CommonParameter::checkNetWorkOnline()
{
    QHostInfo::lookupHost("www.baidu.com",this,SLOT(onLookupHost(QHostInfo)));
}

void CommonParameter::onLookupHost(QHostInfo host)
{
    if (host.error() != QHostInfo::NoError)
    {
        //qDebug() << "Lookup failed:" << host.errorString();
        //网络未连接，发送信号通知
        isPossibleAccessInternet = false;

        emit signal_newWorkStateChange(false);
    }
    else
    {
        //qDebug() << "Lookup succ";
        isPossibleAccessInternet = true;
        emit signal_newWorkStateChange(true);
    }
}
