#include "mediadataprocess.h"

MediaQueueHandle_T MediaDataProcess::m_mediaQueueHadnle = MediaQueueHandle_T();
bool MediaDataProcess::m_mediaQueueIsInit = false;
Enum_MediaType MediaDataProcess::mMediaAudioType = MediaType_G711A;
Enum_MediaType MediaDataProcess::mMediaVeidoType = MediaType_H264;//MediaType_H264;
QMutex MediaDataProcess::m_mutex;
MediaDataProcess::MediaDataProcess(QObject *parent) : QObject(parent)
{
    initVariable();
}


void MediaDataProcess::initVariable()
{
    qDebug()<<"MediaDataProcess thread thread:"<<QThread::currentThreadId();
    videofirstParse = true;
    audiofirstParse = true;
    isLoopRead = false;
    m_queueID = -1;
    m_registID = -1;


    m_pOutBuf = nullptr;
    m_pFrame = nullptr;
    pFrameBGR = nullptr;
    m_pCodecCtx = nullptr;
    pParserCtx = nullptr;
    m_pCodec = nullptr;

    img_convert_ctx  = nullptr;
    pCodecAudioDec = nullptr;
    pCodecCtxAudio = nullptr;
    pFrameAudio = nullptr;
}

void MediaDataProcess::slot_writeQueueVideoData(char *data,int len,QueueVideoInputInfo_T param,Enum_MediaType mediaType)
{

    //qDebug()<<"slot_writeQueueVideoData thread thread:"<<QThread::currentThreadId();
    if(m_queueID > -1)
    {
        getQueueHandle().pWriteVideoRawData(m_queueID,data,len,param,mediaType);
    }
    else
    {

        int id = getQueueHandle().pCreateQueue(maxFrameLen);

        if(id > -1 ){

            qDebug()<<"setup mediaqueue succ:"<<id;
            m_queueID = id;
            getQueueHandle().pWriteVideoRawData(m_queueID,data,len,param,mediaType);

            registReadHandle();

        }else {
            qDebug()<<"setup mediaqueue fail";
        }
    }

}

void MediaDataProcess::slot_writeQueueAudioData(char *data,int len,QueueAudioInputInfo_T param,Enum_MediaType mediaType)
{

    //qDebug()<<"slot_writeQueueAudioData thread thread:"<<QThread::currentThreadId();
    if(m_queueID > -1)
    {
        getQueueHandle().pWriteAudioRawData(m_queueID,data,len,param,mediaType);
    }
    else
    {

        int id = getQueueHandle().pCreateQueue(maxFrameLen);

        if(id > -1 ){

            qDebug()<<"setup mediaqueue succ:"<<id;
            m_queueID = id;
            getQueueHandle().pWriteAudioRawData(m_queueID,data,len,param,mediaType);

            registReadHandle();

        }else {
            qDebug()<<"setup mediaqueue fail";
        }
    }

}


void MediaDataProcess::registReadHandle()
{

    if(m_queueID > -1){
        m_mediaQueueRegistHadnle.queueID = m_queueID;

        m_registID = MediaQueueRegistReadHandle(&m_mediaQueueRegistHadnle);
        if(m_registID > -1)
            qDebug()<<"regist succ";

    }else {

        qDebug()<<"invalid m_queueID ";
    }

}

void MediaDataProcess::slot_stopRead()
{
    QMutexLocker locker(&readMutex);
    isLoopRead = false;
}

void MediaDataProcess::slot_loopReadQueueData()
{

    if(isLoopRead)
        return;

    isLoopRead = true;

    initVideoDecode();


    while(true){


        QThread::msleep(1);
        QMutexLocker locker(&readMutex);

        if(isLoopRead == false)
            break;

        //qDebug()<<"red";
        char *buff = new char[maxFrameLen];
        int readLen = -1;
        if(m_registID > -1 && m_queueID > -1){
            m_mediaQueueRegistHadnle.pReadData(m_registID,m_queueID,buff,maxFrameLen,&readLen);


            QString str = QString::fromLatin1(buff,readLen);


            if(readLen > 32){

                parseFrameData(buff,readLen);

            }

        }


        delete []buff;
    }

}



void MediaDataProcess::parseFrameData(char *buff,int len)
{

    int index=0;

    QByteArray readDataBuff;
    readDataBuff.append(buff,len);

    if(readDataBuff.at(index) == D_SYNCDATA_HEAD0 && readDataBuff.at(index+1)==D_SYNCDATA_HEAD1)
    {

        unsigned char mediaType = readDataBuff.at(index+3);
        index += 4;
        //qDebug()<<"MediaType_H264 数据长度:"<<readDataBuff.length()<< " mediaType:"<<mediaType;
        if (mediaType == MediaDataProcess::mMediaVeidoType) {

            //qDebug()<<"MediaType_H264 数据长度:"<<readDataBuff.length()<< " index:"<<index;
            //帧信息
            int fps = 0x000f & readDataBuff.at(index++);
            int rcmode = 0x000f & readDataBuff.at(index++);
            int frameType = 0x000f & readDataBuff.at(index++);
            int staty0 = 0x000f & readDataBuff.at(index++);
            //VideoReslution_T

            QByteArray arrW = readDataBuff.mid(index,4);
            int width = byteArr2Int(arrW);
            index += 4;

            QByteArray arrH = readDataBuff.mid(index,4);

            int height = byteArr2Int(arrH);
            index += 4;
            //  bitrate
            QByteArray arrBitrate = readDataBuff.mid(index,4);
            int bitrate =  byteArr2Int(arrBitrate);
            index += 4;
            //pts

            index += 8;
            //裸流数据长度

            QByteArray arrDatalen = readDataBuff.mid(index,4);

            int datalen = byteArr2Int(arrDatalen);

            index += 4;

            if(readDataBuff.length() >= (index + datalen) ){


                //qDebug()<<"读取一帧视频数据:    "<<m_registID<<"    "<<m_queueID;

                QByteArray arrH264;
                arrH264 = readDataBuff.mid(index,datalen);
                parseVideoCodec(arrH264);
            }
        }
        else if(MediaDataProcess::mMediaAudioType == mediaType)
        {
            //qDebug()<<"revice audio";

            //采样率率
            QByteArray arrS = readDataBuff.mid(index,4);
            int samplerate = byteArr2Int(arrS);
            index += 4;
            //采样点
            QByteArray arrP = readDataBuff.mid(index,4);
            int prenum = byteArr2Int(arrP);
            index += 4;
            //位宽
            QByteArray arrB = readDataBuff.mid(index,4);
            int bitwidth = byteArr2Int(arrB);
            index += 4;
            //声道总数
            QByteArray arrSoude = readDataBuff.mid(index,4);
            int soundmode = byteArr2Int(arrSoude);
            index += 4;
            //ms 级别
            QByteArray arrH = readDataBuff.mid(index,4);
            int highPts = byteArr2Int(arrH);
            index += 4;

            QByteArray arrL = readDataBuff.mid(index,4);
            int lowPts = byteArr2Int(arrL);
            index += 4;


            QByteArray arrDatalen = readDataBuff.mid(index,4);
            int datalen = byteArr2Int(arrDatalen);
            index += 4;


            if(readDataBuff.length() >= (index + datalen) )
            {

                QByteArray arrG711A;
                arrG711A = readDataBuff.mid(index,datalen);


                //qDebug()<<"读取一帧音频数据:    "<<m_registID<<"    "<<m_queueID;
//                if(audiofirstParse)
//                {
//                    audiofirstParse = false;

//                    if(MediaDataProcess::mMediaAudioType == MediaType_G711A)
//                        initAudioDecode(AV_CODEC_ID_PCM_ALAW, AV_SAMPLE_FMT_S16, samplerate,soundmode);
//                    else
//                        initAudioDecode(AV_CODEC_ID_PCM_ALAW, AV_SAMPLE_FMT_S16, samplerate,soundmode);

//                    emit signal_preparePlayAudio(samplerate,prenum,bitwidth,soundmode,256*256*256*highPts + lowPts);
//                }
//                else
//                    parseAudioCodec(arrG711A);

            }
        }
    }
}

void MediaDataProcess::parseAudioCodec(QByteArray arr)
{
    if(arr.isEmpty())
        return;
    //av_init_packet(&pPacketAudio);
    pPacketAudio.data = (uint8_t *)arr.data();
    pPacketAudio.size = arr.length();

    if(arr.length() != 160)
        qDebug()<<"arr.length() != 160  "<<arr.length();


    int ret = av_packet_from_data(&pPacketAudio, pPacketAudio.data, pPacketAudio.size);
    if (ret <0)
    {
        printf("av_packet_from_data error \n");
        return ;
    }

    int ret1 = avcodec_send_packet(pCodecCtxAudio,&pPacketAudio);
    if(ret1 != 0)
        qDebug()<<"ret1 !=0 :"<<ret1;
    int ret2 = avcodec_receive_frame(pCodecCtxAudio,pFrameAudio);

    if(ret2 != 0)
        qDebug()<<"ret2 !=0 :"<<ret1;

    int datasize = av_get_bytes_per_sample(pCodecCtxAudio->sample_fmt);

    //AVSampleFormat
    //pFrameAudio->format
    //qDebug()<<"pararms: "<<pFrameAudio->nb_samples<<"   "<<pCodecCtxAudio->channels<<"  "<<datasize<<"  "<<pFrameAudio->linesize[1];
    emit signal_playAudio(pFrameAudio->data[0],pFrameAudio->linesize[0]);

    QByteArray arr2;
    arr2.append((char*)pFrameAudio->data[0],640);

    // qDebug()<<"HEX:"<<arr2.toHex();
}


//耗时15ms
void MediaDataProcess::parseVideoCodec(QByteArray arr)
{

    if(arr.isEmpty())
        return;

    m_pPacket.data = (uint8_t *)arr.data();
    m_pPacket.size = arr.length();

    int gotPic = 0;

    if( avcodec_send_packet(m_pCodecCtx,&m_pPacket) == 0)
    {
        if(0 == avcodec_receive_frame(m_pCodecCtx,m_pFrame))
        {

            //解决：deprecated pixel format used, make sure you did set range correctly
            AVPixelFormat pixFormat;
            switch (m_pCodecCtx->pix_fmt)
            {
            case AV_PIX_FMT_YUVJ420P:
                pixFormat = AV_PIX_FMT_YUV420P;
                break;
            case AV_PIX_FMT_YUVJ422P:
                pixFormat = AV_PIX_FMT_YUV422P;
                break;
            case AV_PIX_FMT_YUVJ444P:
                pixFormat = AV_PIX_FMT_YUV444P;
                break;
            case AV_PIX_FMT_YUVJ440P:
                pixFormat = AV_PIX_FMT_YUV440P;
                break;
            default:
                pixFormat = m_pCodecCtx->pix_fmt;
            }
            //


            if (videofirstParse ){
                qDebug()<<"***first_time***";
                img_convert_ctx = sws_getContext(m_pCodecCtx->width, m_pCodecCtx->height, pixFormat, m_pCodecCtx->width, m_pCodecCtx->height, AV_PIX_FMT_RGB32, SWS_BICUBIC, NULL, NULL, NULL);
                int size = avpicture_get_size(AV_PIX_FMT_RGB32, m_pCodecCtx->width, m_pCodecCtx->height);
                m_pOutBuf = (uint8_t *)av_malloc(size);
                avpicture_fill((AVPicture *)pFrameBGR, m_pOutBuf, AV_PIX_FMT_RGB32, m_pCodecCtx->width, m_pCodecCtx->height); // allocator memory for BGR buffer
                videofirstParse = false;

            }
            else
            {
                sws_scale(img_convert_ctx, (const uint8_t* const*)m_pFrame->data, m_pFrame->linesize, 0, m_pCodecCtx->height, pFrameBGR->data, pFrameBGR->linesize);


               // qDebug()<<"FFmpeg 解析到一帧视频："<<m_queueID;
                QImage *pImage = nullptr;
                pImage = new QImage((uchar*)m_pOutBuf, m_pCodecCtx->width, m_pCodecCtx->height, QImage::Format_RGB32);
                emit signal_sendImg(pImage);

            }
        }
    }

}


int MediaDataProcess::initAudioDecode(AVCodecID codec_id, AVSampleFormat sample_fmt, int sample_rate, int channels)
{
    pCodecAudioDec = avcodec_find_decoder(codec_id);
    if (!pCodecAudioDec) {
        printf("Codec not found audio codec id\n");
        return -1;
    }

    pCodecCtxAudio = avcodec_alloc_context3(pCodecAudioDec);
    if (!pCodecCtxAudio) {
        printf("Could not allocate audio codec context\n");
        return -1;
    }
    pCodecCtxAudio->sample_fmt = sample_fmt;
    pCodecCtxAudio->sample_rate = sample_rate;
    pCodecCtxAudio->channels = channels;

    if (avcodec_open2(pCodecCtxAudio, pCodecAudioDec, NULL) < 0) {
        printf("Could not open codec\n");
        return -1;
    }


    av_init_packet(&pPacketAudio);

    pFrameAudio = av_frame_alloc();
    if (NULL == pFrameAudio)
        return -1;

    //    au_convert_ctx = swr_alloc();
    //    av_opt_set_int(au_convert_ctx, "in_channel_layout",  AV_CH_LAYOUT_MONO, 0);
    //    av_opt_set_int(au_convert_ctx, "out_channel_layout", AV_CH_LAYOUT_STEREO,  0);
    //    av_opt_set_int(au_convert_ctx, "in_sample_rate",     8000, 0);
    //    av_opt_set_int(au_convert_ctx, "out_sample_rate",    8000, 0);
    //    av_opt_set_sample_fmt(au_convert_ctx, "in_sample_fmt",  AV_SAMPLE_FMT_S16, 0);
    //    av_opt_set_sample_fmt(au_convert_ctx, "out_sample_fmt", AV_SAMPLE_FMT_S16,  0);
    //    swr_init(au_convert_ctx);
    //    m_pAudioOutBuf = (uint8_t *)av_malloc(640);

    return 0;
}



void MediaDataProcess::initVideoDecode()
{
    av_register_all();

    AVCodecID avCodec;
    if(MediaDataProcess::mMediaVeidoType == MediaType_H265)
        avCodec = AV_CODEC_ID_HEVC;
    else
        avCodec = AV_CODEC_ID_H264;
    m_pCodec = avcodec_find_decoder(avCodec);//找到编解码器类型，AVCodec         *m_pCodec，是存储解码器的信息的结构体

    if (!m_pCodec)
    {
        qDebug()<<"avcodec_find_encoder failed";
        return ;
    }

    m_pFrame = av_frame_alloc();
    if (!m_pFrame)
    {
        return ;
    }

    pFrameBGR = av_frame_alloc();

    if (!pFrameBGR)
    {

        return ;
    }

    m_pCodecCtx = avcodec_alloc_context3(m_pCodec);//为m_pCodecCtx分配内存空间，将解码器将解码器信息传入

    if (!m_pCodecCtx)
    {
        qDebug()<<"avcodec_alloc_context3 failed";
        return ;
    }

    pParserCtx = av_parser_init(avCodec);
    if (!pParserCtx) {
        perror("pParserctx err");
        return;
    }


    if (avcodec_open2(m_pCodecCtx, m_pCodec, NULL) < 0)//打开视频解码器 ,将解码器信息传入
    {
        qDebug()<<"avcodec_open2 failed";
        return ;
    }

    av_init_packet(&m_pPacket);
}


void MediaDataProcess::unInitVideoDecode()
{
    if(m_pOutBuf != nullptr)
        av_free(m_pOutBuf);
    if(m_pFrame != nullptr)
        av_frame_free(&m_pFrame);
    if(pFrameBGR != nullptr)
        av_frame_free(&m_pFrame);

    if(img_convert_ctx != nullptr)
        sws_freeContext(img_convert_ctx);
    if(m_pCodecCtx != nullptr)
        avcodec_close(m_pCodecCtx);
    if(pParserCtx != nullptr)
        av_parser_close(pParserCtx);
}

void MediaDataProcess::unInitAudioDecode()
{
    if(pFrameAudio != nullptr)
        av_frame_free(&pFrameAudio);

    if(pCodecCtxAudio != nullptr)
        avcodec_close(pCodecCtxAudio);
}

int MediaDataProcess::byteArr2Int(QByteArray arr)
{

    int index = 0;
    int i1 = 0x000000ff & arr.at(index++);
    int i2 = 0x000000ff & arr.at(index++);
    int i3 = 0x000000ff & arr.at(index++);
    int i4 = 0x000000ff & arr.at(index++);

    return (i1 + i2*256 + i3*65536 + i4*16777216);
}

MediaDataProcess::~MediaDataProcess()
{

    qDebug()<<"~MediaDataProcess()";


    if(m_queueID > -1)
        getQueueHandle().pDisdroyQueue(m_queueID);
    if(m_registID > -1)
        MediaQueueUnRegistReadHandle(&m_mediaQueueRegistHadnle);


    unInitVideoDecode();

    unInitAudioDecode();

}
