#ifndef TCPWORKER_H
#define TCPWORKER_H


#define D_SYNCDATA_HEAD0 0x77
#define D_SYNCDATA_HEAD1 0x17
#define MAX_STREAM_MTU_SIZE 1450

#include <QObject>
#include <QTcpSocket>
#include <QThread>
#include <QHostAddress>
#include <QTimer>
#include <QImage>

#include "mediaqueue/mediaqueue.h"
#include "mediadataprocess.h"
#include <QFile>

#include "ffmpegcodec.h"
#include "avirecord.h"
#include "dispatchmsgmanager.h"

#define MAX_AUDIO_FRAME_SIZE 192000

class TcpWorker : public QObject
{
    Q_OBJECT
public:
    explicit TcpWorker(QObject *parent = nullptr);
    ~TcpWorker();

signals:

    void signal_sendH264(char* vH264Arr,int arrLen,long long pts);
    void signal_sendPcmALaw(char* PcmALawArr,int arrLen,long long pts);
    void signal_sendPreparePlayAudio(int samplerate,int prenum,int bitwidth,int soundmode,long pts);

    void signal_sendMsg(MsgInfo *info);
    void signal_authenticationFailue(QString did);

    void signal_writeMediaVideoQueue(char *data,int len,QueueVideoInputInfo_T param,Enum_MediaType mediaType);
    void signal_writeMediaAudioQueue(char *data,int len,QueueAudioInputInfo_T param,Enum_MediaType mediaType);

    void signal_readMediaQueue();
    void signal_waitTcpConnect(QString str);
    void signal_endWait();
    void signal_workFinished();

    void finish();
public slots:

    void slot_readData();
    void slot_tcpDisconnected();
    void slot_tcpConnected();


    void slot_timerConnectSer();
    void slot_disConnectSer();
    void slot_tcpSendAuthentication(QString did,QString name,QString pwd);
    void slot_tcpRecAuthentication(QString did,QString name,QString pwd);

    void slot_destory();

    void creatNewTcpConnect(QString ip,int port);

    void startParsing();
    void stopParsing();
private:


    /*********************************/
    int saveVideoInfo(QByteArray &arr);
    int saveAudioInfo(QByteArray &arr);
    QueueVideoInputInfo_T infoV;
    QueueAudioInputInfo_T infoA;

    /*********************************/
    void writeDebugfile(QString filename,QString funname,int lineCount,QString strContent);
    int byteArr2Int(QByteArray arr);
    void parseRecevieData();

    void initVariable();
    void resetAVFlag();

    QTcpSocket *tcpSocket;

    QByteArray readDataBuff;
    bool isFindHead;
    bool isFindMediaType;
    bool isSaveVideoInfo;
    bool isSaveAudioInfo;
    bool isSendAudioData;
    int mediaDataType;
    int m_streamDateLen;

    int minLen;

    QString m_did;
    QString m_usrName;
    QString m_password;
    QString ip;
    quint16 port;

    QTimer *timerConnectSer;
    bool isReconnecting;



    QFile *audioSrc;

    int videoFrameMaxLen;
    int audioFrameMaxLen;

    QMutex parseMutex;

    bool isStartParsing;
    bool isCheckedDataLong;
    bool isConnected;
    bool isHavaData;




};

#endif // TCPWORKER_H
