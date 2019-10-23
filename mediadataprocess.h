#ifndef MEDIADATAPROCESS_H
#define MEDIADATAPROCESS_H

extern "C"{
#include "libavformat/avformat.h"
#include "libavutil/mathematics.h"
#include "libavutil/time.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavutil/opt.h"
}

#include <QObject>
#include "mediaqueue/mediaqueue.h"
#include <QDebug>
#include <QImage>
#include <QThread>

#include <QTimer>
#include <QMutex>
#include <QMutexLocker>
#define maxFrameLen 1024*4*100

class MediaDataProcess : public QObject
{
    Q_OBJECT
public:
    explicit MediaDataProcess(QObject *parent = nullptr);
    ~MediaDataProcess();

    static MediaQueueHandle_T getQueueHandle(){

         QMutexLocker locker(&m_mutex);
        if(!m_mediaQueueIsInit){

            int ret = MediaQueueInit(&m_mediaQueueHadnle);
            if(ret == 0){

                m_mediaQueueIsInit = true;
                qDebug()<<"MediaQueueInit Succ";
            }
        }
        return m_mediaQueueHadnle;
    };

    static Enum_MediaType mMediaVeidoType;
    static Enum_MediaType mMediaAudioType;
signals:
    void signal_sendImg(QImage *pImg);
    void signal_playAudio(unsigned char * buff,int len);
    void signal_preparePlayAudio(int samplerate,int prenum,int bitwidth,int soundmode,long pts);

public slots:

    void slot_loopReadQueueData();
    void slot_stopRead();

    void slot_writeQueueVideoData(char *data,int len,QueueVideoInputInfo_T param,Enum_MediaType mediaType);
    void slot_writeQueueAudioData(char *data,int len,QueueAudioInputInfo_T param,Enum_MediaType mediaType);


private:
    void initVariable();
    void initVideoDecode();
    void unInitVideoDecode();
    int  initAudioDecode(AVCodecID codec_id, AVSampleFormat sample_fmt, int sample_rate, int channels);
    void unInitAudioDecode();
    void parseVideoCodec(QByteArray arr);
    void parseAudioCodec(QByteArray arr);

    void parseFrameData(char* buff,int len);
    int byteArr2Int(QByteArray arr);

    void registReadHandle();

    uint8_t *m_pOutBuf;
    AVFrame *m_pFrame;
    AVFrame* pFrameBGR ;
    AVCodecContext  *m_pCodecCtx;
    AVCodecParserContext *pParserCtx;
    AVCodec         *m_pCodec;
    AVPacket        m_pPacket;
    SwsContext *img_convert_ctx ;
    bool videofirstParse;


    AVCodec         *pCodecAudioDec;
    AVCodecContext  *pCodecCtxAudio;
    AVFrame         *pFrameAudio;
    AVPacket        pPacketAudio;

    SwrContext *au_convert_ctx;
    uint8_t *m_pAudioOutBuf;
    bool audiofirstParse;



    static MediaQueueHandle_T m_mediaQueueHadnle;
    static bool m_mediaQueueIsInit;

    MediaQueueRegistHandle_T m_mediaQueueRegistHadnle;


    int m_queueID;
    int m_registID;
    bool isLoopRead;


    QTimer *timer;

    QMutex readMutex;
    static QMutex m_mutex;

};

#endif // MEDIADATAPROCESS_H
