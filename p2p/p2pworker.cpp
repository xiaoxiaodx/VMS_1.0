#include "p2pworker.h"

P2pWorker::P2pWorker(QString name)
{
    sessionHandle = -1;

    isFindHead = false;
    isFindCmd = false;
    isWorking = false;
    isP2pInitSucc = false;
    isConnectDevSucc = false;

    isForceStopWorking = false;


    m_name = name;
    readDataBuff.clear();
    needLen = 2;

    m_serverKey = nullptr;

    m_validDatalen = 0;
    m_cmd = 0;
}


void P2pWorker::p2pinit()
{
    int ret;
    //ret = PPCS_Initialize((CHAR*)"EBGDEJBJKDJMGAJMEJGNFPEAHNMMHCNLGMEGBFCFBLIFLFLOCIBJCNOIHEKDJBKCBNNLLHCMPINOAEDHIHMKICBFNNOHBP");//ip
    ret = PPCS_Initialize((CHAR*)"EBGDEJBJKGJKGGJJEJGOFMEDHCMCHMNFGJEBBCCBBMJELILDCAAKCBODHILEJLKLBNMHLHCIOEMIANDPJFNMIDBCMA");

    if(ret >=0)
        isP2pInitSucc = true;

    qDebug()<<"PPCS_Initialize() ret = "<<ret;
    st_PPCS_NetInfo NetInfo;
    ret = PPCS_NetworkDetect(&NetInfo, 0);
    qDebug()<<"PPCS_NetworkDetect() ret = "<<ret;
    qDebug()<<"-------------- NetInfo: -------------------";
    qDebug()<<"Internet Reachable:     "<<((NetInfo.bFlagInternet == 1) ? "YES":"NO");
    qDebug()<<"P2P Server IP resolved :"<<((NetInfo.bFlagHostResolved == 1) ? "YES":"NO");
    qDebug()<<"P2P Server Hello Ack   : "<<((NetInfo.bFlagServerHello == 1) ? "YES":"NO");

    char nat_type[64];
    memset(nat_type,0x0,sizeof(nat_type));
    switch(NetInfo.NAT_Type)
    {
    case 1: strncpy(nat_type,"IP-Restricted Cone type",sizeof(nat_type));break;
    case 2: strncpy(nat_type,"Port-Restricted Cone type",sizeof(nat_type));break;
    case 3: strncpy(nat_type,"Symmetric  Cone type",sizeof(nat_type));break;
    case 0:
    default:
        strncpy(nat_type,"unknown",sizeof(nat_type));
        break;
    }
    qDebug()<<"NAT Type	: "<<nat_type;
    qDebug()<<"My LAN IP	: "<<NetInfo.MyLanIP;
    qDebug()<<"My WAN IP	: "<<NetInfo.MyWanIP;
}

void P2pWorker::stopWoring()
{
    isForceStopWorking = true;
}

void P2pWorker::slot_connectDev(QString deviceDid,QString name,QString pwd)
{

    qDebug()<<" slot_connectDev";
    if(deviceDid.contains("SST")){

        qDebug()<<"deviceDid  "<<deviceDid;

        QString tmpNumStr = deviceDid.mid(3,6);

        qDebug()<<"tmpNumStr  "<<tmpNumStr;

        QString tmpTrailStr = deviceDid.mid(10,5);

        qDebug()<<"tmpTrailStr  "<<tmpTrailStr;

        int tmpNum = tmpNumStr.toInt();

        qDebug()<<"tmpNum  "<<tmpNum;
        tmpNum += 7700;

        if(tmpNum <10000)
            m_did = "INEW-00"+QString::number(tmpNum)+"-"+tmpTrailStr;
        else if(tmpNum <100000)
            m_did = "INEW-0"+QString::number(tmpNum)+"-"+tmpTrailStr;
        else
            m_did = "INEW-"+QString::number(tmpNum)+"-"+tmpTrailStr;
    }else
        m_did = deviceDid;

    m_password = pwd;
    m_account = name;

    //qDebug()<<"m_did  "<<m_did<<"   "<<m_account<<"    "<<m_password;
    if(!isP2pInitSucc)
        p2pinit();

    sessionHandle = PPCS_Connect(deviceDid.toLatin1().data(),1,0);

    qDebug()<<"P2P connectDev   ret ="<<sessionHandle;
    if(sessionHandle >= 0){

        emit signal_p2pErr(m_name,"conenct succ");

        isWorking = true;
        isConnectDevSucc = true;


        emit signal_p2pConnectState(m_name,true);
        emit slot_startLoopRead();

    }else{
        QThread::msleep(500);

        emit signal_p2pErr(m_name,err2String(sessionHandle));

        slot_connectDev(m_did,m_account,m_password);
    }

}

void P2pWorker::slot_startLoopRead()
{
    qDebug()<<"P2P slot_startLoopRead";

    while(isWorking  && (!isForceStopWorking)){

        //8个通道
        for(int i=0;i<8;i++)
        {

            unsigned int readSize = 0;
            int ret = PPCS_Check_Buffer(sessionHandle,  i,  NULL, &readSize);


            if(ERROR_PPCS_SUCCESSFUL != ret){

                if(ERROR_PPCS_SESSION_CLOSED_TIMEOUT == ret){
                    qDebug()<<"长时间未收到数据，将断开";


                    emit signal_sendMsg(new MsgInfo("device is disconnect, try to reconnect",true));

                    isWorking = false;
                    break;
                }
            }else {
                char buff[1024*1024];
                ret = PPCS_Read(sessionHandle,i,buff,(int *)&readSize,5000);


                QByteArray arr;
                arr.append(buff,readSize);

                if(ERROR_PPCS_SUCCESSFUL == ret){
                    //  qDebug()<<"通道"<<i<<" 有"<<readSize<<"个数据："<<arr.toHex();
                    processUnPkg(buff,readSize);
                }
            }
        }

        QThread::msleep(10);
    }


    if(!isForceStopWorking){

        if(sessionHandle >=0)
            PPCS_Close(sessionHandle);

        if(m_serverKey !=nullptr){

            delete m_serverKey;
            m_serverKey = nullptr;
        }
        //如果在这里调用 slot_connectDev(),会导致在重新连上设备  进而调用slot_startLoopRead时报错，故而抛出去(可能是递归函数的调用思路出错)
        emit signal_loopEnd();

    }

}
void P2pWorker::test()
{

}

void P2pWorker::p2pSendData(QString cmd,QVariant map)
{
    qDebug()<<" p2pSendData:"<<cmd<<"   "<<map;

    //QByteArray loginArr = p2pProtrol.makeJsonPacket(cmd,map);
    if(cmd.compare("login")==0){
        for(int i=0;i<32;i++)
            m_appKey[i] = rand() % 0xFF;
        QByteArray arr;
        arr.append(m_appKey,32);
        qDebug()<<" m_appKey "<<arr.toHex();
        writeBuff1(CMD_USR_KEY, m_appKey, 32);


    }else if(cmd.compare("getVedio")==0)
    {

        writeBuff1(CMD_GET_VIDEO_INFO,"vlive -act list -para 0 ",strlen("vlive -act list -para 0 "));
        writeBuff1(CMD_VIDEO_REQ,"vlive -act set -speed 2 -audio 1 ",strlen("vlive -act set -speed 2 -audio 1"));

    }else{

        QByteArray arr = p2pProtrol.makeJsonPacket(cmd,map);
        writeBuff(CMD_NEW_PROTROL,arr.data(),arr.length());
    }
}

void P2pWorker::resetParseVariant()
{
    isFindHead = false;
    isFindCmd = false;
    needLen = 2;
    m_validDatalen = 0;
    m_cmd = 0;
}

void P2pWorker::processUnPkg(char *buff,int len)
{

    readDataBuff.append(buff,len);


    // qDebug()<<"processUnPkg "<<readDataBuff.length()<<" "<<needLen;
    while(readDataBuff.length() >= needLen)
    {

        if(!isFindHead)
        {

            unsigned short head = char2Short(readDataBuff.at(0),readDataBuff.at(1));

            if(head == MEIAN_HEAD || head == MEIAN_HEAD1)
            {

                //qDebug()<<"找到头";
                readDataBuff.remove(0,2);
                isFindHead = true;
                needLen = 6;
            }else {

                readDataBuff.remove(0,1);
                continue;
            }
        }


        if(!isFindCmd){

            if(readDataBuff.length() >= needLen){

                int DatalenL = char2Short(readDataBuff.at(0),readDataBuff.at(1));
                int DatalenH = char2Short(readDataBuff.at(4),readDataBuff.at(5));

                m_validDatalen = DatalenL + DatalenH * 256;

                m_cmd = char2Short(readDataBuff.at(2),readDataBuff.at(3));


                readDataBuff.remove(0,6);

                needLen = m_validDatalen;

                isFindCmd = true;

            }else
                break;
        }

        if(readDataBuff.length() >= needLen){

            if(m_cmd == CMD_USR_KEY){

                QByteArray arr ;
                arr.append(readDataBuff.data(),needLen);

                m_serverKey = new char[serverKeyLen];

                memcpy(m_serverKey,arr.data(),serverKeyLen);

                QString loginCmd = "authcfg -act checkuser -name "+m_account+" -passwd "+ m_password;

                //想要接收流必须要使用命令登录
                writeBuff1(CMD_LOGIN,loginCmd.toLatin1().data(),loginCmd.length());



                QVariantMap map;
                map.insert("username",m_account);
                map.insert("password",m_password);
                QByteArray arrLogin = p2pProtrol.makeJsonPacket("login",map);
                writeBuff(CMD_NEW_PROTROL,arrLogin.data(),arrLogin.length());

                qDebug()<<"找到 CMD_USR_KEY  内容:"<<m_serverKey<<"    ";

            }else if(m_cmd == CMD_LOGIN) {

                QByteArray arr ;
                arr.append(readDataBuff.data(),needLen);

                QJsonDocument jsDoc = QJsonDocument::fromJson(arr.data());

                if(jsDoc.isObject())
                    p2pProtrol.unJsonPacket(arr);
                else{

                    usr_decode(arr.data(), arr.length(),m_serverKey, serverKeyLen);

                    QString returnStr = QString(arr);

                    qDebug()<<"找到 CMD_LOGIN  内容:"<<returnStr;

                    if(returnStr.contains("error")){

                        emit signal_loginState(false,m_name,m_did,m_account,m_password,"fail");

                    }else
                        emit signal_loginState(true,m_name,m_did,m_account,m_password,"succ");

                }



            }else if(m_cmd == CMD_VIDEO_TRNS){


                QByteArray arr;
                arr.append(readDataBuff.data(),needLen);

                video_frame_header *frameHeader = (video_frame_header *)arr.data();

                int vstreamLen = frameHeader->frame_len;

                //qDebug()<<"找到  视频信息 1:"<<vstreamLen;//<<"  "<<arr.toHex();

                emit signal_sendH264(m_name,arr.data() + sizeof(video_frame_header), vstreamLen,1000);

            }else if(m_cmd == CMD_AUDIO_TRNS){
                //qDebug()<<"找到  音频信息:"<<needLen<<"   "<<readDataBuff.length();
                QByteArray arr ;
                arr.append(readDataBuff.data(),needLen);

                video_frame_header *video_pack= (video_frame_header*)(readDataBuff.data());

                emit signal_sendPcmALaw(arr.data(), arr.length(),1000);

            }else if(m_cmd == CMD_NEW_PROTROL){

                QByteArray arr ;
                arr.append(readDataBuff.data(),needLen);
                QVariantMap map = p2pProtrol.unJsonPacket(arr);

                emit signal_p2pReplyData(m_name,map);

            }

            readDataBuff.remove(0,needLen);
            resetParseVariant();

        }else
            break;



        //  qDebug()<<"finish loop :"<<readDataBuff.length() <<"    "<<needLen;
    }

}

void P2pWorker::writeBuff(unsigned int cmd,char* buff,int bufflen)
{

    char sendBuff[1500];
    int sendBufflen = 0;

    processReqPkg(cmd,buff,bufflen,sendBuff,&sendBufflen,false);

    int ret = PPCS_Write(sessionHandle,0,sendBuff,sendBufflen);


    QByteArray arr;
    arr.append(sendBuff,sendBufflen);

    //qDebug()<<"writeBuff   "<<ret<<"    "<<arr.toHex();
}

void P2pWorker::writeBuff1(unsigned int cmd,char* buff,int bufflen)
{

    char sendBuff[1500];
    int sendBufflen = 0;

    processReqPkg(cmd,buff,bufflen,sendBuff,&sendBufflen,true);

    int ret = PPCS_Write(sessionHandle,0,sendBuff,sendBufflen);


    QByteArray arr;
    arr.append(sendBuff,sendBufflen);

    //qDebug()<<"writeBuff1   "<<ret<<"    "<<arr.toHex();
}

void P2pWorker::processReqPkg(unsigned int cmd,  char* inBuff, int inbuffSize, char * outBuff,int *outBuffSize,bool isNeedEncrypt)
{
    struct meian_pkg_head_type m_pkg_head;

    memset(&m_pkg_head, 0, sizeof(m_pkg_head));
    if(isNeedEncrypt)
        m_pkg_head.head = (unsigned short)(MEIAN_HEAD1);
    else
        m_pkg_head.head = (unsigned short)(MEIAN_HEAD);
    m_pkg_head.cmd = (unsigned short)(cmd&0xFFFF);

    m_pkg_head.len =(unsigned short)(inbuffSize&0xFFFF);
    if(inbuffSize>0x10000)
    {
        m_pkg_head.reslv=(unsigned short)((inbuffSize&0xFFFF0000)>>16);
    }

    memcpy(outBuff, &m_pkg_head, sizeof(m_pkg_head));
    memcpy(outBuff + sizeof(m_pkg_head), (char *)inBuff, inbuffSize);

    *outBuffSize=inbuffSize+ sizeof(m_pkg_head);

    if(isNeedEncrypt && m_serverKey != nullptr)
        usr_decode(outBuff + sizeof(m_pkg_head), inbuffSize, m_serverKey, serverKeyLen);
}


void P2pWorker::usr_decode(char *pIn, int inLen, char *pKey, int keyLen)
{
    int i = 0;

    for (i = 0; i < inLen; i++)
    {
        *(pIn + i) = (char)(*(pIn + i) ^ *(pKey + (i % keyLen)));
    }
}


unsigned short P2pWorker::char2Short(char ch1,char ch2){

    unsigned short head0 = 0x00ff &  ch1;
    unsigned short head1 = 0x00ff &  ch2;

    return  head0 + head1*256;

}

QString P2pWorker::err2String(int ret)
{


    QString errStr = "";
    if(ret >= 0){
        errStr = "succ";
    }else if (ret == ERROR_PPCS_NOT_INITIALIZED) {
        errStr = "not initialized";
    }else if (ret == ERROR_PPCS_ALREADY_INITIALIZED) {
        errStr = "already initialized";
    }else if (ret == ERROR_PPCS_TIME_OUT) {
        errStr = "time out";
    }else if (ret == ERROR_PPCS_INVALID_ID) {
        errStr = "invalid id";
    }else if (ret == ERROR_PPCS_INVALID_PARAMETER) {
        errStr = "invalid parameter";
    }else if (ret == ERROR_PPCS_DEVICE_NOT_ONLINE) {
        errStr = "device not online";
    }else if (ret == ERROR_PPCS_FAIL_TO_RESOLVE_NAME) {
        errStr = "fail to resolve name";
    }else if (ret == ERROR_PPCS_INVALID_PREFIX) {
        errStr = "invalid prefix";
    }else if (ret == ERROR_PPCS_ID_OUT_OF_DATE) {
        errStr = "id out of date";
    }else if (ret == ERROR_PPCS_NO_RELAY_SERVER_AVAILABLE) {
        errStr = "no relay server available";
    }else if (ret == ERROR_PPCS_INVALID_SESSION_HANDLE) {
        errStr = "invalid session handle";
    }else if (ret == ERROR_PPCS_SESSION_CLOSED_REMOTE) {
        errStr = "session closed remote";
    }else if (ret == ERROR_PPCS_SESSION_CLOSED_TIMEOUT) {
        errStr = "session closed timeout";
    }else if (ret == ERROR_PPCS_SESSION_CLOSED_CALLED) {
        errStr = "session closed called";
    }else if (ret == ERROR_PPCS_REMOTE_SITE_BUFFER_FULL) {
        errStr = "remote site buffer full";
    }else if (ret == ERROR_PPCS_USER_LISTEN_BREAK) {
        errStr = "user listen break";
    }else if (ret == ERROR_PPCS_MAX_SESSION) {
        errStr = "max session";
    }else if (ret == ERROR_PPCS_UDP_PORT_BIND_FAILED) {
        errStr = "udp port bind failed";
    }else if (ret == ERROR_PPCS_USER_CONNECT_BREAK) {
        errStr = "user connect break";
    }else if (ret == ERROR_PPCS_SESSION_CLOSED_INSUFFICIENT_MEMORY) {
        errStr = "session closed insufficient memory";
    }else if (ret == ERROR_PPCS_INVALID_APILICENSE) {
        errStr = "invalid apilicense";
    }else if (ret == ERROR_PPCS_FAIL_TO_CREATE_THREAD) {
        errStr = "fail to create thread";
    }

    return  "p2p err:"+errStr;
}

P2pWorker::~P2pWorker()
{
    qDebug()<< " 析构   P2pWorker";

    if(sessionHandle >=0)
        PPCS_Close(sessionHandle);

    PPCS_DeInitialize();

    if(m_serverKey != nullptr)
        delete m_serverKey;
}





