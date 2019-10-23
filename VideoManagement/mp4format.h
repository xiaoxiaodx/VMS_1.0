#ifndef MP4FORMAT_H
#define MP4FORMAT_H

#include <QObject>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <QFile>

extern "C"{
#include "libavformat/avformat.h"
#include "libavutil/mathematics.h"
#include "libavutil/time.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavutil/opt.h"
#include "libavcodec/avcodec.h"

#include "libavutil/avassert.h"
#include "libavutil/channel_layout.h"

}


#define STREAM_DURATION   10.0
#define STREAM_FRAME_RATE 15 /* 15 images/s */
#define STREAM_PIX_FMT    AV_PIX_FMT_YUV420P /* default pix_fmt */
#define SCALE_FLAGS SWS_BICUBIC

// a wrapper around a single output AVStream
typedef struct OutputStream {
    AVStream *st;
    AVCodecContext *enc;

    /* pts of the next frame that will be generated */
    int64_t next_pts;
    int samples_count;

    AVFrame *frame;
    AVFrame *tmp_frame;

    float t, tincr, tincr2;

    struct SwsContext *sws_ctx;
    struct SwrContext *swr_ctx;
} OutputStream;

class Mp4Format : public QObject
{
    Q_OBJECT
public:
    explicit Mp4Format(QObject *parent = nullptr);

signals:

public slots:
    int slot_write_audio_frame(char* data,int bufflen,long long tempTime);
    int slot_write_video_frame(char* data,int bufflen,long long tempTime);

    void slot_createMp4(QString filenameStr,long long tempTime);
    void slot_closeMp4();
private:


    int write_frame(AVFormatContext *fmt_ctx, const AVRational *time_base, AVStream *st, AVPacket *pkt);
    void add_stream(OutputStream *ost, AVFormatContext *oc,AVCodec **codec,enum AVCodecID codec_id);
    AVFrame *alloc_audio_frame(enum AVSampleFormat sample_fmt,uint64_t channel_layout,int sample_rate, int nb_samples);

    AVFrame *get_audio_frame(OutputStream *ost);

    void close_stream(AVFormatContext *oc, OutputStream *ost);

    void open_video(AVFormatContext *oc, AVCodec *codec, OutputStream *ost, AVDictionary *opt_arg);
    void open_audio(AVFormatContext *oc, AVCodec *codec, OutputStream *ost, AVDictionary *opt_arg);


    OutputStream video_st , audio_st;
    AVOutputFormat *fmt;
    AVFormatContext *oc;
    AVCodec *audio_codec, *video_codec;
    int ret;
    bool have_video , have_audio ;
    bool encode_video , encode_audio ;
    AVDictionary *opt;


    int ptsInc2 ;
    int STREAM_FRAME_RATE2;
    AVFormatContext *ofmt_ctx ;
    AVStream *out_stream;


    QFile *pcmfile;

};

#endif // MP4FORMAT_H
