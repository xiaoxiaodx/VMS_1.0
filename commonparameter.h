#ifndef COMMONPARAMETER_H
#define COMMONPARAMETER_H

#include <QObject>
#include <QHostInfo>
#include <QTimer>
#include <QMutex>
class CommonParameter : public QObject
{
    Q_OBJECT
public:
    explicit CommonParameter(QObject *parent = nullptr);


    void statrTimingDetectionNetWork();
    static bool isPossibleAccessInternet;
    static CommonParameter *getInstance(){
        SingletonMutex->lock();
        if(commonParameter == nullptr)
            commonParameter = new CommonParameter;
        SingletonMutex->unlock();
        return commonParameter;
    }
signals:
    void signal_newWorkStateChange(bool isPossibleAccessInternet);
public slots:
    void onLookupHost(QHostInfo host);
    void checkNetWorkOnline();
private:
    static CommonParameter *commonParameter;
    static QMutex *SingletonMutex;
    QTimer *timer;
};

#endif // COMMONPARAMETER_H
