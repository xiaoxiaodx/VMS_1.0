/*
 *
 *  消息分发管理类，是一个单例类，在这里对整个系统的信息做管理，所有的信息都应该进入该类
 *
 *  消息类型已经在头文件注释说明
 *
 *  所有消息的时间都是以在该类的定时器为标准，当前系统的消息时间基准没有采用本地时间
 *
 *  特殊要说明的是：控制重复的消息 的意思是：在某一时间类同样的消息不应该重复发出，例如提示网络断连
 *
*/




#include "dispatchmsgmanager.h"




DispatchMsgManager* DispatchMsgManager::msgManager = nullptr;
DispatchMsgManager::DispatchMsgManager(QObject *parent) : QObject(parent)
{
    initVariant();
}


void DispatchMsgManager::initVariant(){

    listMsg.clear();
    timeCount = 0;

    connect(&msgTimer,&QTimer::timeout,this,&DispatchMsgManager::slot_timeOut);
    msgTimer.start(100);
}


//100ms 一循环
void DispatchMsgManager::slot_timeOut()
{

    for(int i=0;i<listMsg.size();i++){

        MsgInfo *msg = listMsg.at(i);


        if(msg->isNeedRepeat){

            if(msg->msgSendTime == 0){

                dispatchMsg(msg);
                msg->msgSendTime = timeCount;
                continue;
            }

            if((timeCount - msg->msgSendTime)>=msg->msgRepeatInterval && (qAbs(timeCount - msg->msgProductionDate)<=2)){


                dispatchMsg(msg);

                msg->msgSendTime = timeCount;

            }

        }else {

            dispatchMsg(msg);
            listMsg.removeAt(i);
            continue;
        }
    }

    timeCount++;

}
void DispatchMsgManager::dispatchMsg(MsgInfo *msg){



//    qDebug()<<"****** dispatchMsg *******    "<<timeCount<<","<<msg->msgContentStr ;

    if(msg->msgType == MSG_TOAST)
        emit signal_sendToastMsg(msg);
    else if(msg->msgType == MSG_DEBUGLOG){


        qDebug()<<"MSG_DEBUGLOG" ;
        QFile debugFile(msg->msgDid+".txt");


        if(!debugFile.isOpen())
            if (!debugFile.open(QIODevice::ReadOnly  |QIODevice::WriteOnly))
                return;


        QString str = "debuglog:"+msg->msgProductionFileName + "---"+msg->msgProductionFunName+"---"+QString::number(msg->msgProductionCodeLine) + "    "+msg->msgContentStr;
        QTextStream txtOutput(&debugFile);
        txtOutput << str<< endl;
    }

}

void DispatchMsgManager::addMsg(MsgInfo *info)
{

    // qDebug()<<"****** addMsg *******    "<<info->msgContentStr;

    if(info->isNeedRepeat){

        for(int i=0;i<listMsg.size();i++){

            MsgInfo *msg = listMsg.at(i);
            //函数名，代码行，消息内容 相同 则判断为同一消息
            //子串比较可能会存在bug,因为没有区分大小写，同时也没有对中文比较进行测试
            if(msg->msgProductionFunName.compare(info->msgProductionFunName)==0 && msg->msgProductionCodeLine == info->msgProductionCodeLine){

                //qDebug()<<"已经存在该消息:"<<info->msgContentStr;

                //更新消息生产时间
                listMsg.at(i)->msgProductionDate = timeCount;
                return;
            }

        }

    }

    info->msgProductionDate = timeCount;

    listMsg.append(info);
}




