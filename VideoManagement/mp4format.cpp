#include "mp4format.h"
#include <QDebug>


/*
 * 只支持固定格式的封装，acc和H264
 * 不是这2种格式的音视频，可以先进行转换
*/
Mp4Format::Mp4Format(QObject *parent) : QObject(parent)
{

    fmt = nullptr;
    oc = nullptr;
    audio_codec = nullptr , video_codec = nullptr;
    int ret;
    have_video = false, have_audio = false ;
    encode_video = false , encode_audio = false ;
    opt = NULL;



//    pcmfile = new QFile("playAudioSrc111.pcm");
//    if (!pcmfile->open(QIODevice::ReadOnly  |QIODevice::WriteOnly))
//        return;
}

void Mp4Format::open_audio(AVFormatContext *oc, AVCodec *codec, OutputStream *ost, AVDictionary *opt_arg)
{
    AVCodecContext *c;
    int nb_samples;
    int ret;


    c = ost->enc;

    /* open it */

    ret = avcodec_open2(c, codec, NULL);

    if (ret < 0) {
        // fprintf(stderr, "Could not open audio codec: %s\n", av_err2str(ret));
        exit(1);
    }

    /* init signal generator */
    ost->t     = 0;
    ost->tincr = 2 * M_PI * 110.0 / c->sample_rate;
    /* increment frequency by 110 Hz per second */
    ost->tincr2 = 2 * M_PI * 110.0 / c->sample_rate / c->sample_rate;

    if (c->codec->capabilities & AV_CODEC_CAP_VARIABLE_FRAME_SIZE)
        nb_samples = 10000;
    else
        nb_samples = c->frame_size;

    qDebug()<<"nb_samples11    "<<nb_samples;
//    ost->frame     = av_frame_alloc();
//    ost->tmp_frame = av_frame_alloc();

    ost->frame     = alloc_audio_frame(c->sample_fmt, c->channel_layout,
                                       c->sample_rate, 1764);
    ost->tmp_frame = alloc_audio_frame(AV_SAMPLE_FMT_S16, c->channel_layout,
                                       c->sample_rate, 1764);

    /* copy the stream parameters to the muxer */
    ret = avcodec_parameters_from_context(ost->st->codecpar, c);
    if (ret < 0) {
        fprintf(stderr, "Could not copy the stream parameters\n");
        exit(1);
    }

    /* create resampler context */
    ost->swr_ctx = swr_alloc();
    if (!ost->swr_ctx) {
        fprintf(stderr, "Could not allocate resampler context\n");
        exit(1);
    }

    /* set options */
    av_opt_set_int       (ost->swr_ctx, "in_channel_count",   c->channels,       0);
    av_opt_set_int       (ost->swr_ctx, "in_sample_rate",     c->sample_rate,    0);
    av_opt_set_sample_fmt(ost->swr_ctx, "in_sample_fmt",      AV_SAMPLE_FMT_S16, 0);
    av_opt_set_int       (ost->swr_ctx, "out_channel_count",  c->channels,       0);
    av_opt_set_int       (ost->swr_ctx, "out_sample_rate",    c->sample_rate,    0);
    av_opt_set_sample_fmt(ost->swr_ctx, "out_sample_fmt",     c->sample_fmt,     0);


    qDebug()<<"resetSample :"<<c->channels<<"   "<<c->sample_rate<<"    "<<c->sample_rate;
    /* initialize the resampling context */
    if ((ret = swr_init(ost->swr_ctx)) < 0) {
        qDebug()<< "Failed to initialize the resampling context";

    }
}

void Mp4Format::open_video(AVFormatContext *oc, AVCodec *codec, OutputStream *ost, AVDictionary *opt_arg)
{
    int ret;
    AVCodecContext *c = ost->enc;
    AVDictionary *opt = NULL;

    av_dict_copy(&opt, opt_arg, 0);

    /* open the codec */
    ret = avcodec_open2(c, codec, &opt);
    av_dict_free(&opt);
    if (ret < 0) {
        qDebug()<<"Could not open video codec: %s\n";
        return;
    }


    /* copy the stream parameters to the muxer */
    ret = avcodec_parameters_from_context(ost->st->codecpar, c);
    if (ret < 0) {
        qDebug()<<"Could not copy the stream parameters";
        return;
    }
}


void Mp4Format::slot_createMp4(QString filenameStr,long long tempTime)
{
    //char* filename = filenameStr.toLatin1().data();
    char* filename = "hello1.mp4";
    qDebug()<<"MP4文件名:"<<filename;
    avformat_alloc_output_context2(&oc, NULL, NULL, filename);
    if (!oc) {
        qDebug()<<"Could not deduce output format from file extension: using MPEG.";
        avformat_alloc_output_context2(&oc, NULL, "mpeg", filename);
    }
    if (!oc)
        return ;

    fmt = oc->oformat;

    /* Add the audio and video streams using the default format codecs
         * and initialize the codecs. */
    if (fmt->video_codec != AV_CODEC_ID_NONE) {
        add_stream(&video_st, oc, &video_codec, fmt->video_codec);
        have_video = true;
        encode_video = true;
    }
    if (fmt->audio_codec != AV_CODEC_ID_NONE) {
        add_stream(&audio_st, oc, &audio_codec, fmt->audio_codec);
        have_audio = true;
        encode_audio = true;
    }


    if (have_video)
        open_video(oc, video_codec, &video_st, opt);

    if (have_audio)
        open_audio(oc, audio_codec, &audio_st, opt);

    av_dump_format(oc, 0, filename, 1);

    /* open the output file, if needed */
    if (!(fmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&oc->pb, filename, AVIO_FLAG_WRITE);
        if (ret < 0) {
            qDebug()<< "Could not open "<<filename;
            return ;
        }
    }

    ret = avformat_write_header(oc, &opt);
    if (ret < 0) {
        qDebug()<< "Error occurred when opening output file";
        return ;
    }
}

int Mp4Format::write_frame(AVFormatContext *fmt_ctx, const AVRational *time_base, AVStream *st, AVPacket *pkt)
{
    /* rescale output packet timestamp values from codec to stream timebase */
    av_packet_rescale_ts(pkt, *time_base, st->time_base);
    pkt->stream_index = st->index;

    /* Write the compressed frame to the media file. */
    //log_packet(fmt_ctx, pkt);
    return av_interleaved_write_frame(fmt_ctx, pkt);
}

/* Add an output stream. */
void Mp4Format::add_stream(OutputStream *ost, AVFormatContext *oc,AVCodec **codec,enum AVCodecID codec_id)
{
    AVCodecContext *c;
    int i;

    /* find the encoder */
    *codec = avcodec_find_encoder(codec_id);
    if (!(*codec)) {
        qDebug()<<"Could not find encoder for "<<avcodec_get_name(codec_id);
        return;
    }

    ost->st = avformat_new_stream(oc, NULL);
    if (!ost->st) {
        qDebug()<<"Could not allocate stream\n";
        return;;
    }
    ost->st->id = oc->nb_streams-1;
    c = avcodec_alloc_context3(*codec);
    if (!c) {
        qDebug()<< "Could not alloc an encoding context";
        return;;
    }
    ost->enc = c;

    switch ((*codec)->type) {
    case AVMEDIA_TYPE_AUDIO:
        c->sample_fmt  = AV_SAMPLE_FMT_FLTP;
        c->bit_rate    = 64000;
        c->sample_rate = 44100;
//        if ((*codec)->supported_samplerates) {
//            c->sample_rate = (*codec)->supported_samplerates[0];
//            for (i = 0; (*codec)->supported_samplerates[i]; i++) {
//                if ((*codec)->supported_samplerates[i] == 44100)
//                    c->sample_rate = 44100;
//            }
//        }
//        c->channels        = av_get_channel_layout_nb_channels(c->channel_layout);
        c->channel_layout = AV_CH_LAYOUT_MONO;
//        if ((*codec)->channel_layouts) {
//            c->channel_layout = (*codec)->channel_layouts[0];
//            for (i = 0; (*codec)->channel_layouts[i]; i++) {
//                if ((*codec)->channel_layouts[i] == AV_CH_LAYOUT_STEREO)
//                    c->channel_layout = AV_CH_LAYOUT_STEREO;
//            }
//        }
        c->channels        = av_get_channel_layout_nb_channels(c->channel_layout);

        ost->st->time_base = (AVRational){ 1, c->sample_rate };

        qDebug()<<"audio info "<<c->channel_layout <<"  "<<c->channels<<"   "<<c->sample_fmt;

        break;

    case AVMEDIA_TYPE_VIDEO:
        c->codec_id = codec_id;

        c->bit_rate = 400000;
        /* Resolution must be a multiple of two. */
        c->width    = 1920;
        c->height   = 1080;
        /* timebase: This is the fundamental unit of time (in seconds) in terms
         * of which frame timestamps are represented. For fixed-fps content,
         * timebase should be 1/framerate and timestamp increments should be
         * identical to 1. */
        ost->st->time_base = (AVRational){ 1, STREAM_FRAME_RATE };
        c->time_base       = ost->st->time_base;

        c->gop_size      = 12; /* emit one intra frame every twelve frames at most */
        c->pix_fmt       = STREAM_PIX_FMT;
        if (c->codec_id == AV_CODEC_ID_MPEG2VIDEO) {
            /* just for testing, we also add B-frames */
            c->max_b_frames = 2;
        }
        if (c->codec_id == AV_CODEC_ID_MPEG1VIDEO) {
            /* Needed to avoid using macroblocks in which some coeffs overflow.
             * This does not happen with normal video, it just happens here as
             * the motion of the chroma plane does not match the luma plane. */
            c->mb_decision = 2;
        }
        break;

    default:
        break;
    }

    /* Some formats want stream headers to be separate. */
    if (oc->oformat->flags & AVFMT_GLOBALHEADER)
        c->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
}

/**************************************************************/
/* audio output */

AVFrame *Mp4Format::alloc_audio_frame(enum AVSampleFormat sample_fmt,uint64_t channel_layout,int sample_rate, int nb_samples)
{

    AVFrame *frame = av_frame_alloc();
    int ret;

    if (!frame) {
        qDebug()<< "Error allocating an audio frame";
        return nullptr;
    }

    frame->format = sample_fmt;
    frame->channel_layout = channel_layout;
    frame->sample_rate = sample_rate;
    frame->nb_samples = nb_samples;

    if (nb_samples) {
        ret = av_frame_get_buffer(frame, 0);
        if (ret < 0) {
            qDebug()<< "Error allocating an audio buffer";
            return nullptr;
        }
    }

    return frame;
}

/* Prepare a 16 bit dummy audio frame of 'frame_size' samples and
 * 'nb_channels' channels. */
AVFrame *Mp4Format::get_audio_frame(OutputStream *ost)
{
    AVFrame *frame = ost->tmp_frame;
    int j, i, v;
    int16_t *q = (int16_t*)frame->data[0];

    /* check if we want to generate more frames */
    if (av_compare_ts(ost->next_pts, ost->enc->time_base,
                      STREAM_DURATION, (AVRational){ 1, 1 }) >= 0)
        return NULL;

    for (j = 0; j <frame->nb_samples; j++) {
        v = (int)(sin(ost->t) * 10000);
        for (i = 0; i < ost->enc->channels; i++)
            *q++ = v;
        ost->t     += ost->tincr;
        ost->tincr += ost->tincr2;
    }

    frame->pts = ost->next_pts;
    ost->next_pts  += frame->nb_samples;

    return frame;
}

/*
 * encode one audio frame and send it to the muxer
 * return 1 when encoding is finished, 0 otherwise
 */
int Mp4Format::slot_write_audio_frame(char* data,int bufflen,long long tempTime)
{
    // qDebug()<<"slot_write_audio_frame   "<<bufflen;

    //pcmfile->write(data,bufflen);

    if(!have_audio)
        return -1;
    AVCodecContext *c;
    AVPacket pkt = { 0 }; // data and size must be 0;

    int ret;
    int got_packet;
    int dst_nb_samples;
    av_init_packet(&pkt);

    OutputStream *ost = &audio_st;
    c = ost->enc;

    AVFrame *frame = ost->tmp_frame;

    frame->data[0] = (uint8_t*)data;
    frame->linesize[0] = bufflen;
    //    frame->pts = ost->next_pts;
    //    ost->next_pts  += frame->nb_samples;

    if (frame) {
        /* convert samples from native format to destination codec format, using the resampler */
        /* compute destination number of samples */
        dst_nb_samples = av_rescale_rnd(swr_get_delay(ost->swr_ctx, c->sample_rate) + frame->nb_samples,
                                        c->sample_rate, c->sample_rate, AV_ROUND_UP);

        //qDebug()<<"dst_nb_samples   "<<c->sample_rate<<"    "<<dst_nb_samples<<"    "<<frame->nb_samples;

        /* when we pass a frame to the encoder, it may keep a reference to it
         * internally;
         * make sure we do not overwrite it here
         */
        ret = av_frame_make_writable(ost->frame);
        if (ret < 0){
            qDebug()<<"2222    "<<ret;
            return -1;
        }
        /* convert to destination format */
        ret = swr_convert(ost->swr_ctx,
                          ost->frame->data, 1764,
                          (const uint8_t **)&data,bufflen);

        qDebug()<< "swr_convert info:"<<ret<<"  "<<dst_nb_samples<<"    "<<frame->nb_samples;
        if (ret < 0) {
            qDebug()<< "Error while converting";
            return -1;
        }

        frame = ost->frame;
        frame->linesize[0] = ret;
        frame->pts = av_rescale_q(ost->samples_count, (AVRational){1, c->sample_rate}, c->time_base);
        ost->samples_count += dst_nb_samples;
    }


    if(0 == avcodec_send_frame(c, frame)){

        if(0==avcodec_receive_packet(c, &pkt)){

            ret = write_frame(oc, &c->time_base, ost->st, &pkt);
            if (ret < 0) {
                qDebug()<< "Error while writing audio frame: ";
                return -1;
            }
        }
    }


    return  1;
}


/*
 * encode one video frame and send it to the muxer
 * return 1 when encoding is finished, 0 otherwise
 */
int Mp4Format::slot_write_video_frame( char* data,int bufflen,long long tempTime)
{

    return 0;
    if(!have_video)
        return 0;
    //qDebug()<<"slot_write_video_frame";
    int ret;
    AVCodecContext *c;
    int got_packet = 0;
    AVPacket pkt = { 0 };

    c = video_st.enc;

    av_init_packet(&pkt);

    pkt.data = (uint8_t*)data;
    pkt.size = bufflen;


    av_packet_rescale_ts(&pkt, c->time_base, video_st.st->time_base);
    pkt.stream_index = video_st.st->index;

    pkt.pts = av_rescale_q((ptsInc2++)*2, c->time_base,video_st.st->time_base);
    pkt.dts=av_rescale_q_rnd(pkt.dts, video_st.st->time_base,video_st.st->time_base,(AVRounding)(AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX));
    pkt.duration = av_rescale_q(pkt.duration,video_st.st->time_base, video_st.st->time_base);


    ret = av_interleaved_write_frame(oc, &pkt);

    if (ret < 0)
        qDebug()<< "Error while writing video frame "<<ret<<"   "<<pkt.dts<<"    "<<pkt.pts;

    return 1;
}

void Mp4Format::close_stream(AVFormatContext *oc, OutputStream *ost)
{
    avcodec_free_context(&ost->enc);
    av_frame_free(&ost->frame);
    av_frame_free(&ost->tmp_frame);
    sws_freeContext(ost->sws_ctx);
    swr_free(&ost->swr_ctx);
}

void Mp4Format::slot_closeMp4()
{

    have_video = false;
    have_audio = false;
    int ret = av_write_trailer(oc);

    qDebug()<<"MP4 文件 写尾巴   "<<ret;

    /* Close each codec. */
    //    if (have_video)
    //        close_stream(oc, &video_st);
    //    if (have_audio)
    //        close_stream(oc, &audio_st);
}

