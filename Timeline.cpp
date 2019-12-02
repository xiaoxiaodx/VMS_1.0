/*              图表基类
 * 描述：自定义绘制图表的基类（折线图，饼图，条形图）
 *
 * 功能：1、图表之外的一切绘制，包括背景绘制，坐标轴的绘制(子类提供具体的图表绘制)
 *      2、坐标变换（将显示的坐标转换为屏幕像素坐标）,坐标自由伸缩，平移
 *      3、轴的尺寸动画
 *
 * 作者：DMJ
 *
*/

#include "Timeline.h"
#include <QTransform>

TimeLine::TimeLine()
{

    setAcceptedMouseButtons(Qt::LeftButton
                            | Qt::RightButton
                            | Qt::MiddleButton);
    setFlag(QQuickItem::ItemHasContents);

    SencondsPerPix = 1;

    listTimeType.clear();

    midValueTime = 60;
    emit midValueChange(secondsToStr(midValueTime));

    commonColor = "#80818282";
    warningColor = "#80FF1B1B";
}





void TimeLine::paint(QPainter *painter)
{

    painter->setRenderHint(QPainter::Antialiasing);

    drawAxis(painter);

}



void TimeLine::drawAxis(QPainter *painter)
{

    painter->setPen(QPen(QBrush("#FFFFFF"),1));


    //字体
    QFont newFont;
    newFont.setPixelSize(10);
    newFont.setFamily("Microsoft Yahei");
    QFontMetrics fontMetrics(newFont);


    //假设中间值为0点0分0秒

    int midPix = width()/2;

    int axisBottomPix = height() - 22;

    //qDebug()<<" midValueTime:"<<midValueTime<<" SencondsPerPix:"<<SencondsPerPix<<" midPix:"<<midPix<<" width:"<<width();

    int minTime = midValueTime-midPix*SencondsPerPix;
    int maxTime = midValueTime + midPix*SencondsPerPix;

    for (int tmpTime= minTime;tmpTime<=maxTime;tmpTime++) {
        int i = (tmpTime-minTime)/SencondsPerPix;
        int time = tmpTime%(DAYSECONDS);
        if(time < 0)
            time = DAYSECONDS+time;

        if(time%(SencondsPerPix*60)==0){

            painter->drawLine(i,axisBottomPix,i,axisBottomPix-19);

            //字体
            QFont newFont;
            newFont.setPixelSize(10);
            newFont.setFamily("Microsoft Yahei");
            QFontMetrics fontMetrics(newFont);


            int timeH = time/3600;
            int timeM = (time%3600)/60;
            // int timeS = (time%3600)%60;
            QString timeStrH;
            QString timeStrM;

            if(timeH<10)
                timeStrH = QString::number(0)+QString::number(timeH);
            else
                timeStrH = QString::number(timeH);

            if(timeM<10)
                timeStrM = QString::number(0)+QString::number(timeM);
            else
                timeStrM = QString::number(timeM);



            QString timeStr = timeStrH+":"+timeStrM;

            //qDebug()<<"大刻度:"<<i<<"  "<<timeStr;
            QRect rect = fontMetrics.boundingRect(timeStr);

            painter->setFont(newFont);
            painter->drawText(i-rect.width()/2,axisBottomPix+rect.height(),timeStr);


        }else if (time%(SencondsPerPix*10)==0) {

            painter->drawLine(i,axisBottomPix,i,axisBottomPix-9);
        }
    }


    drawChart(painter,minTime,maxTime);


    // qDebug()<<midValueTime;
}
void TimeLine::setTimeWarn(QVariant timeInfo)
{

    QString time = timeInfo.toMap().value("time").toString();
    QString timeTypeStr =  timeInfo.toMap().value("data").toString();

    int sendcondH = time.mid(8,2).toInt();

    //qDebug()<<" timeTypeStr:"<<sendcondH<<"  "<<timeTypeStr;
    for(int i=0;i<timeTypeStr.size();i++){


        int tmpstartS = sendcondH*3600 + i*20;
        int tmpendS = sendcondH*3600 + (1+i)*20;
        QString timeTypeItem = timeTypeStr.at(i);
        int timeType = timeTypeItem.toInt();

        bool isDataIntersect = false;
        for (int j=0;j<listTimeType.size();j++) {

            QMap<QString,int > *map=listTimeType.at(j);
            int startT = map->value("startTime");
            int endT = map->value("endTime");
            int type = map->value("timeType");

            if(timeType == type){

                if(tmpendS<startT || tmpstartS>endT)
                    continue;

                if(tmpendS>=startT && tmpstartS<=startT){
                    map->insert("startTime",tmpstartS);
                    isDataIntersect = true;
                    break;

                }

                if(tmpstartS<=endT && tmpendS>= endT){
                    map->insert("endTime",tmpendS);
                    isDataIntersect = true;
                    break;

                }

                if(tmpstartS>=startT && tmpendS<=endT){
                    isDataIntersect = true;
                    break;
                }

            }
        }

        if(!isDataIntersect){

            QMap<QString,int > *map = new QMap<QString,int >();
            map->insert("startTime",tmpstartS);
            map->insert("endTime",tmpendS);
            map->insert("timeType",timeType);
            listTimeType.append(map);

        }
    }



    update();
    //    qDebug()<<" listTimeType:"<<listTimeType.size();
    //    for (int num =0;num <listTimeType.size();num++) {

    //         QMap<QString,int > *map = listTimeType.at(num);

    //         qDebug()<<"startTime:"<<map->value("startTime")<<"  endTime:"<<map->value("endTime")<<"    timeType:"<<map->value("timeType");

    //    }

    //listTimeType.append();
}


void TimeLine::mousePressEvent(QMouseEvent* event)
{

    if(event->button() == Qt::LeftButton){
        isMousePress = true;
        mouseDragPt.setX(event->x());
        mouseDragPt.setY(event->y());

    }else if(event->button() == Qt::RightButton){


    }

}

void TimeLine::mouseMoveEvent(QMouseEvent *event)
{

    if(isMousePress){

        int dx = event->x() - mouseDragPt.rx();
        int detime = dx*SencondsPerPix;


        //qDebug()<<" midValueTime    "<<midValueTime;
        midValueTime -= detime;

        emit midValueChange(secondsToStr(midValueTime));

        mouseDragPt.setX(event->x());

        update();

    }

}



void TimeLine::mouseReleaseEvent(QMouseEvent *event)
{
    isMousePress = false;
}

void TimeLine::wheelEvent(QWheelEvent *event)
{


    if(event->delta()<0){

        if(SencondsPerPix == 1)
            SencondsPerPix = 5;
        else if(SencondsPerPix == 5)
            SencondsPerPix = 10;
        else if(SencondsPerPix == 10)
            SencondsPerPix = 30;
        else if(SencondsPerPix == 30)
            SencondsPerPix = 60;



    }else {

        if(SencondsPerPix == 5)
            SencondsPerPix = 1;
        else if(SencondsPerPix == 10)
            SencondsPerPix = 5;
        else if(SencondsPerPix == 30)
            SencondsPerPix = 10;
        else if(SencondsPerPix == 60)
            SencondsPerPix = 30;

    }

    update(QRect(0,0,width(),height()));


}

void TimeLine::drawChart(QPainter *painter,int timeMin,int timeMax){



    painter->setPen(Qt::NoPen);

    //左边界和右边界时间跨度
    int timeSpan = timeMax - timeMin;


    int mintime = timeMin%(DAYSECONDS);
    int maxtime = timeMax%(DAYSECONDS);

    int timeLeft;//最左边的时间值（24小时制）
    if(mintime < 0)
        timeLeft = DAYSECONDS +mintime;
    else
        timeLeft = mintime;

    int timeRight;//最右边的时间值（24小时制）
    if(maxtime < 0)
        timeRight = DAYSECONDS+maxtime;
    else
        timeRight = maxtime;




    //qDebug()<<"drawChart:"<<mintime<<"    "<<maxtime<<"    "<<timeLeft<<"    "<<timeRight<<"   "<<secondsToStr(timeLeft)<<"   "<<secondsToStr(timeRight);



    //对时间轴分区间,最多3个区间
    QList<QMap<QString,qreal >> listBlock;

    if((timeLeft + timeSpan)> 2*DAYSECONDS){//意味着出现24时 到 0时的中间状态,有3个区间



        int zeroX1 = (DAYSECONDS-timeLeft)/SencondsPerPix;
        int zeroX2 = (DAYSECONDS*2-timeLeft)/SencondsPerPix;
        QMap<QString,qreal > map;
        map.insert("startT",0);
        map.insert("startTX",zeroX1);
        map.insert("endT",DAYSECONDS);
        map.insert("endTX",zeroX2);
        listBlock.append(map);



        painter->setBrush(QBrush(QColor("#131415")));
        painter->drawRect(0,0,zeroX1,height());
        painter->drawRect(zeroX2,0,width()-zeroX2,height());

        //qDebug()<<"三区间：     "<<zeroX1<<" "<<zeroX2;

    }else if((timeLeft + timeSpan)> DAYSECONDS){//意味着出现24时 到 0时的中间状态,有2个区间
        QMap<QString,qreal > map;
        map.insert("startT",timeLeft);
        map.insert("startTX",0);

        qreal zeroX = (DAYSECONDS-timeLeft)/SencondsPerPix;
        map.insert("endT",DAYSECONDS);
        map.insert("endTX",zeroX);
        listBlock.append(map);
        QMap<QString,qreal > map1;
        map1.insert("startT",0);
        map1.insert("startTX",zeroX);
        map1.insert("endT",timeRight);
        map1.insert("endTX",width());
        listBlock.append(map1);


        // qDebug()<<"双区间：     1："<<timeLeft<<" "<<DAYSECONDS<<"   "<<"2:"<<0<<" "<<timeRight;
    }else {

        QMap<QString,qreal > map;
        map.insert("startT",timeLeft);
        map.insert("startTX",0);
        map.insert("endT",timeRight);
        map.insert("endTX",width());
        listBlock.append(map);


        //qDebug()<<"单区间：   "<<timeLeft<<" "<<timeRight;
    }


    for (int index=0;index<listTimeType.size();index++) {

        QMap<QString,int > *map = listTimeType.at(index);

        qreal startTime = map->value("startTime");
        qreal endTime = map->value("endTime");
        qreal type = map->value("timeType");

        for (int i=0;i<listBlock.size();i++) {
            QMap<QString,qreal > blockmap = listBlock.at(i);
            qreal blockStartT = blockmap.value("startT");
            qreal blockEndT = blockmap.value("endT");
            qreal blockStartTX = blockmap.value("startTX");
            qreal blockEndTX = blockmap.value("endTX");

            if(endTime>=blockStartT && startTime<=blockStartT){

                if(type == 1)
                    painter->setBrush(QBrush(QColor(commonColor)));
                else if(type ==2)
                    painter->setBrush(QBrush(QColor(warningColor)));

                qreal dx = (endTime-blockStartT)/SencondsPerPix;

                painter->drawRect(QRectF(blockStartTX,0,dx,height()));
                break;
            }

            if(startTime<=blockEndT && endTime>=blockEndT){

                if(type == 1)
                    painter->setBrush(QBrush(QColor(commonColor)));
                else if(type ==2)
                    painter->setBrush(QBrush(QColor(warningColor)));


                qreal dx = (blockEndT-startTime)/SencondsPerPix;

                painter->drawRect(QRectF(blockEndTX-dx,0,dx,height()));
                break;
            }

            if(startTime>=blockStartT && endTime<= blockEndT){

                if(type == 1)
                    painter->setBrush(QBrush(QColor(commonColor)));
                else if(type ==2)
                    painter->setBrush(QBrush(QColor(warningColor)));


                qreal dx = (endTime-startTime)/SencondsPerPix;

                qreal dxleft = (startTime-blockStartT)/SencondsPerPix;


                painter->drawRect(QRectF(blockStartTX+dxleft,0,dx,height()));
                break;
            }

            if(startTime <= blockStartT && endTime>= blockEndT){

                if(type == 1)
                    painter->setBrush(QBrush(QColor(commonColor)));
                else if(type ==2)
                    painter->setBrush(QBrush(QColor(warningColor)));

                painter->drawRect(QRectF(0,0,width(),height()));
                break;
            }
        }
    }

    int midPix = width()/2;
    painter->setPen(QPen(QBrush("#409EFF"),4));
    painter->drawLine(midPix,0,midPix,height());
}

QString TimeLine::secondsToStr(int sec1)
{

    int sec = sec1%DAYSECONDS;
    if(sec<0)
        sec = DAYSECONDS+ sec;
    int timeH = sec/3600;
    int timeM = (sec%3600)/60;
    int timeS = (sec%3600)%60;
    QString timeStrH;
    QString timeStrM;
    QString timeStrS;

    if(timeH<10)
        timeStrH = QString::number(0)+QString::number(timeH);
    else
        timeStrH = QString::number(timeH);

    if(timeM<10)
        timeStrM = QString::number(0)+QString::number(timeM);
    else
        timeStrM = QString::number(timeM);


    if(timeS<10)
        timeStrS = QString::number(0)+QString::number(timeS);
    else
        timeStrS = QString::number(timeS);
    QString timeleftStr = timeStrH+":"+timeStrM+":"+timeStrS;


    return timeleftStr;
}


