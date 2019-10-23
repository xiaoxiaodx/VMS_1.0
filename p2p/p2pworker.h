#ifndef P2PWORKER_H
#define P2PWORKER_H

#include <QObject>
#include <QDebug>
#include <QThread>
#include <QTimer>

#include "dispatchmsgmanager.h"
extern "C"{
#include "PPCS_API.h"
#include "PPCS_Error.h"
#include "PPCS_Type.h"
}

#include "protocal_pkg.h"

//struct meian_pkg_head_type
//{
//    unsigned short head;
//    unsigned short len;
//    unsigned short cmd;
//    unsigned short reslv;
//};


//#define MEIAN_HEAD 0xBEEF
//#define CMD_USR_KEY	DEF_APPCMD_HEX_REQ(CMDMOD_ID_LOGIN,5)   //0x084A


#define D_SYNCDATA_HEAD0 0xBE
#define D_SYNCDATA_HEAD1 0xEF

#define serverKeyLen 16
#define appKeyLen 32
class P2pWorker : public QObject
{
    Q_OBJECT
public:
    explicit P2pWorker(QObject *parent = nullptr);
    ~P2pWorker();

    void writeBuff(unsigned int cmd,char* buff,int bufflen);
    void stopWoring();
signals:


    void signal_sendH264(char* vH264Arr,int arrLen,long long pts);
    void signal_sendPcmALaw(char* PcmALawArr,int arrLen,long long pts);

    void signal_loopEnd();
    void signal_sendMsg(MsgInfo *info);

public slots:

    void slot_connectDev(QString deviceDid,QString name,QString pwd);
    void slot_startLoopRead();
private:

    void p2pinit();


    void processUnPkg(char* inBuff, int inbuffSize);
    void processReqPkg(unsigned int cmd,  char* inBuff, int inbuffSize, char * outBuff,int *outBuffSize,bool isNeedEncrypt);
    void usr_decode(char *pIn, int inLen, char *pKey, int keyLen);
    void resetParseVariant();
    unsigned short char2Short(char ch1,char ch2 );
    int sessionHandle;

    char m_appKey[appKeyLen];
    char *m_serverKey;


    bool isFindHead;
    bool isFindCmd;
    bool isWorking;
    bool isForceStopWorking;
    bool isP2pInitSucc;
    bool isConnectDevSucc;



    QString m_did;
    QString m_account;
    QString m_password;

    unsigned short m_cmd;
    int m_validDatalen;
    int needLen;

    QByteArray readDataBuff;
};

#endif // P2PWORKER_H
