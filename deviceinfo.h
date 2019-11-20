#ifndef DEVICEINFO_H
#define DEVICEINFO_H



#define QML_PROPERTY(type,name) \
    Q_PROPERTY(type name READ name WRITE set##name NOTIFY name##Change); type m_##name; \
    public: type name() const { return m_##name;} \
    public Q_SLOTS: void set##name(type arg) { m_##name = arg;emit name##Change();} \
    Q_SIGNALS:  \
    void name##Change();\
    private:
#include <QObject>
#include <QVariant>
#include "p2p/p2pworker.h"
#include "tcpworker.h"

class DeviceInfo : public QObject
{
    Q_OBJECT


public:
    explicit DeviceInfo();

    QML_PROPERTY(int,typeNetwork)
    QML_PROPERTY(int,veidoIndex)

    QML_PROPERTY(bool,isOnline)
    QML_PROPERTY(QString,name)
    QML_PROPERTY(QString,did)
    QML_PROPERTY(QString,acc)
    QML_PROPERTY(QString,pwd)




public:
    void createTcpThread();
    void createP2pThread();
QString nima;
signals:

    void signal_connectP2pDev(QString deviceDid,QString name,QString pwd);



public slots:
    void slot_recH264(char *buff,int len,quint64 time);
    void slot_recPcmALaw(char *buff,int len,quint64 time);



public:
    QThread *m_p2pThread;
    P2pWorker *p2pWorker;

    QThread *m_readThread;
    TcpWorker *worker;

};

#endif // DEVICEINFO_H
