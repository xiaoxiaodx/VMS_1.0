#ifndef DISPATCHMSGMANAGER_H
#define DISPATCHMSGMANAGER_H

#include <QObject>
#include <QList>
#include <QTimer>
#include <QDebug>
#include <QTextStream>

enum MsgType{
    UNDEFINE = -1,
    MSG_TOAST = 0,  //吐丝
    MSG_POPUP,      //弹窗
    MSG_LABEL,     //标签，固定在某一控件位置上
    MSG_DEBUGPRINT,//调试控制台打印
    MSG_DEBUGLOG,    //日志文件
};

class MsgInfo{

public:

    explicit MsgInfo(QString msgStr,bool isRepeat){
        this->msgContentStr = msgStr;
        this->isNeedRepeat = isRepeat;
    }

    void setMsgProductionPos(QString filename,QString funName,int codeline){
        this->msgProductionFileName = filename;
        this->msgProductionFunName = funName;
        this->msgProductionCodeLine = codeline;

    }
    void setMsgProductionInfo(MsgType type,bool isRepeat,int msgRepeatInterval,QString msgContentStr,int msgContentInt){
        this->msgType = type;
        this->isNeedRepeat = isRepeat;
        this->msgRepeatInterval = msgRepeatInterval/100;
        this->msgContentStr = msgContentStr;
        this->msgContentInt = msgContentInt;
    }

    int msgID = -1;
    QString msgDid = "";
    MsgType msgType = MSG_TOAST;
    qint64 msgProductionDate = 0;       //消息产生的时间
    QString msgProductionFileName = ""; //消息产生的文件名
    QString msgProductionFunName = "";   //消息产生的函数名
    int msgProductionCodeLine =-1;      //消息产生的代码行


    QString msgContentStr = "";             //消息内容，字符串  --- 纯粹显示
    int msgContentInt = -1;             //消息内容，字符串  --- 需要做一些逻辑控制

    qint64 msgSendTime = 0;             //消息发出的时间
    int msgRepeatInterval = 1000*60/100;

    bool isNeedRepeat = false;                  //是否需要控制重复
};


class DispatchMsgManager : public QObject
{
    Q_OBJECT
public:
    explicit DispatchMsgManager(QObject *parent = nullptr);

    void addMsg(MsgInfo *msg);


    static DispatchMsgManager *getInstance(){

        if(msgManager == nullptr){
            msgManager =  new DispatchMsgManager();
        }
        return msgManager;
    }
signals:

    void signal_sendToastMsg(MsgInfo *info);
public slots:
  //  void slot_recMsg(MsgInfo *info);
    void slot_timeOut();
private:

    void dispatchMsg(MsgInfo *info);
    void initVariant();


    static DispatchMsgManager *msgManager;

    //    void writeDebugLog(MsgInfo *info);
    //    void debugStrInConsole(MsgInfo *info);

    QTimer msgTimer;
    qint64 timeCount;
    QList<MsgInfo*> listMsg;
};

#endif // DISPATCHMSGMANAGER_H
