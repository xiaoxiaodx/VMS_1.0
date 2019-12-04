#ifndef P2PWORKER_H
#define P2PWORKER_H

#include <QObject>
#include <QDebug>
#include <QThread>
#include <QTimer>

#include "dispatchmsgmanager.h"

#include "p2pprotrol.h"
extern "C"{
#include "PPCS_API.h"
#include "PPCS_Error.h"
#include "PPCS_Type.h"
}

#include "protocal_pkg.h"
#include "ffmpegcodec.h"



#define D_SYNCDATA_HEAD0 0xBE
#define D_SYNCDATA_HEAD1 0xEE

#define serverKeyLen 16
#define appKeyLen 32
class P2pWorker : public QObject
{
    Q_OBJECT
public:
    explicit P2pWorker(QString name);
    ~P2pWorker();

    void writeBuff(unsigned int cmd,char* buff,int bufflen);
    void writeBuff1(unsigned int cmd,char* buff,int bufflen);
    void stopWoring();

    void p2pSendData(QString cmd,QVariant map);


    void test();
    QString m_name;
signals:
    void signal_p2pReplyData(QString name,QVariant map);

    void signal_sendH264(QString name ,QVariant img,long long pts);
    void signal_sendPcmALaw(QString name ,char* PcmALawArr,int arrLen,long long pts);

    void signal_sendReplayH264(QString name ,QVariant img,long long pts);
    void signal_sendReplayPcmALaw(QString name,char* PcmALawArr,int arrLen,long long pts);

    void signal_loopEnd();
    void signal_sendMsg(MsgInfo *info);

    void signal_p2pConnectState(QString name,bool isSucc);
    void signal_loginState(bool isSucc,QString name,QString did,QString acc,QString pwd,QString errStr);

    void signal_p2pErr(QString name,QString str);
    void signal_deviceParameterSet(QString name,int parameterType,QVariantMap parMap);
public slots:

    void slot_connectDev(QString deviceDid,QString name,QString pwd);
    void slot_startLoopRead();




private:

    void p2pinit();


    void createFFmpegDecodec();


    void processUnPkg(char* inBuff, int inbuffSize);
    void processReqPkg(unsigned int cmd,  char* inBuff, int inbuffSize, char * outBuff,int *outBuffSize,bool isNeedEncrypt);
    void usr_decode(char *pIn, int inLen, char *pKey, int keyLen);
    void resetParseVariant();
    unsigned short char2Short(char ch1,char ch2 );
    int sessionHandle;

    QString err2String(int ret);

    void writeDebugFile(QString str);
    char m_appKey[appKeyLen];
    char *m_serverKey;


     FfmpegCodec *pffmpegCodec;

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

    P2pProtrol p2pProtrol;

    //QFile *debugFile;
};

#endif // P2PWORKER_H
