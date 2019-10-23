#ifndef AVIRECORD_H
#define AVIRECORD_H

#include <QObject>
#include "avformat.h"
#include <QDebug>
#include <QDateTime>
#include "mediaqueue/common.h"


class AviRecord : public QObject
{
    Q_OBJECT
public:
    explicit AviRecord(QString did);

   ~AviRecord();
signals:

public slots:
    void slot_writeAudio(char *buff,int len,long long tempTime);
    void slot_writeVedio(char *buff,int len,long long tempTime);
    void slot_endRecord();
    void slot_startRecord(QString did,long long pts);
    void slot_setAviSavePath(QString str);
private:
    int RecSetAVParam(MeidaVideo_T mediaInfo,void* pWriterHandle);
    int InitWriterHanle(void** pWriterHandle,MeidaVideo_T mediaInfo,char* fileName, char *idxName);
    int RecGetVideoAttr(MeidaVideo_T mediaInfo,VIDEO_PARAM_S*  bitMapInfo);



    void *pwriteHandle;
    QString mDid;
    qint64 startTime;
    bool isInitSucc;
    QString mRecordingFilePath;
};

#endif // AVIRECORD_H
