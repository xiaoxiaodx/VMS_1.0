
#ifndef XVideo_H
#define XVideo_H
#include <QQuickPaintedItem>
#include <QImage>
#include <QList>
#include <QTimer>
#include <QAudioFormat>
#include <QAudioDeviceInfo>
#include <QAudioOutput>
#include <QSGSimpleTextureNode>
#include <QDateTime>
#include <QDir>

#include <QQuickWindow>
//#include "tcpworker.h"
#include "playaudio.h"
#include "dispatchmsgmanager.h"
//#include "p2pworker.h"
#include "mp4format.h"
#include "ffmpegcodec.h"
#include "avirecord.h"


class ImageInfo{

public:
    QImage *pImg;
    quint64 time;
};
class XVideo : public QQuickItem
{
    Q_OBJECT
public:

    Q_INVOKABLE void sendAuthentication(QString did,QString name,QString pwd);
    Q_INVOKABLE void connectServer(QString ip,QString port);
    Q_INVOKABLE void disConnectServer();
    Q_INVOKABLE void funPlayAudio(bool isPlay);
    Q_INVOKABLE void funRecordVedio(bool isRecord);
    Q_INVOKABLE void funScreenShot();
    Q_INVOKABLE void funSetShotScrennFilePath(QString str);
    Q_INVOKABLE void funSetRecordingFilePath(QString str);



    Q_INVOKABLE void funSendVideoData(QVariant buff,int len);
    Q_INVOKABLE void funSendAudioData(char *buff,int len);




    explicit XVideo();
    ~XVideo();

signals:
    //tcp
    void signal_connentSer(QString ip,int port);
    void signal_disconnentSer();
    void signal_tcpSendAuthentication(QString did,QString name,QString pwd);
    void signal_destoryTcpWork();
    //qml
    void signal_loginStatus(QString msg);
    void signal_waitingLoad(QString msgload);
    void signal_endLoad();
    void signal_authenticationFailue(QString str);
    //audio
    void signal_stopPlayAudio();
    void signal_startPlayAudio();
    void signal_playAudio(unsigned char * buff,int len,long pts);
    void signal_preparePlayAudio(int samplerate,int prenum,int bitwidth,int soundmode,long pts);
    //p2p
    void signals_p2pDowork();
    //
    void signal_update();
    //record
    void signal_recordAudio(char *buff,int len,long long tempTime);
    void signal_recordVedio(char *buff,int len,long long tempTime);
    void signal_startRecord(QString did,long long tempTime);
    void signal_endRecord();
    void signal_setRecordingFilePath(QString str);

public slots:
    void slot_trasfer_waitingLoad(QString msgload);
    void slot_trasfer_endLoad();

    void slot_sendToastMsg(MsgInfo *msg);//经过dispatchMsgManager后出来消息
    void slot_recMsg(MsgInfo *msg);//所有其他类的消息都先到此
    void slot_recH264(char *buff,int len,quint64 time);
    void slot_recPcmALaw(char *buff,int len,quint64 time);
    void slot_authenticationFailue(QString str);

    void slot_reconnectP2p();
    void slot_timeout();
    void sendWaitLoad(bool &isWaiting);


protected:
    QSGNode* updatePaintNode(QSGNode *old, UpdatePaintNodeData *);
private:

    void createTcpThread();
    void createP2pThread();
    void createMp4RecordThread();
    void createFFmpegDecodec();
    void creatDateProcessThread();
    void createPlayAudio();
    void createAviRecord();

    void initVariable();
    void writeDebugfile(QString filename,QString funname,int lineCount,QString strContent);

//    QThread *m_readThread;
//    TcpWorker *worker;

//    QThread *m_p2pThread;
//    P2pWorker *p2pWorker;

    FfmpegCodec *pffmpegCodec;

//    QThread *m_threadReadDate;
//    MediaDataProcess *m_dataProcess;

    PlayAudio *playAudio;
    QThread *playAudioThread;

    QThread *recordThread;
    AviRecord *aviRecord;

    QThread *mp4RecordThread;
    Mp4Format *mp4Record;


    QTimer timerUpdate;
    DispatchMsgManager *mpDispatchMsgManager;

    QList<ImageInfo> listImgInfo;
    QImage *m_Img;


    bool isImgUpdate;

    int minBuffLen;

    bool isPlayAudio;
    bool isRecord;
    bool isStartRecord;//是否启动录像
    bool isScreenShot;
    bool isAudioFirstPlay;
    bool isFirstData;


    quint64 preAudioTime;



    QString mTcpIp;
    int mTcpPort;
    QString mDid;
    QString mAccount;
    QString mPassword;

    QString mshotScreenFilePath;


    static int testIdIndex;
    int testID;
};

#endif // XVideo_H
