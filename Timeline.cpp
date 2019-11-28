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
}





void TimeLine::paint(QPainter *painter)
{

    painter->setRenderHint(QPainter::Antialiasing);

    drawAxis(painter);
    //drawChart(painter);
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
        int time = tmpTime%(24*3600);
        if(time < 0)
            time = 24*3600+time;

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
    painter->setPen(QPen(QBrush("#409EFF"),2));
    painter->drawLine(midPix,0,midPix,height());
    // qDebug()<<midValueTime;
}
void TimeLine::setTimeWarn(QVariant timeInfo)
{

    QString time = timeInfo.toMap().value("time").toString();
    QString timeTypeStr =  timeInfo.toMap().value("data").toString();




    int sendcondH = time.mid(8,2).toInt();
    qDebug()<<" setTimeWarn:"<<time<<"  "<<time.mid(8,2)<<"   "<<sendcondH<<" "<<timeTypeStr;

    for(int i=0;i<timeTypeStr.size();i++){

        int tmpstartS = sendcondH*3600 + i*20;
        int tmpendS = sendcondH*3600 + (1+i)*20;
        QString timeTypeStr = timeTypeStr.at(i);
        int timeType = timeTypeStr.toInt();


        bool isDataIntersect = false;
        for (int j=0;j<listTimeType.size();j++) {

            QMap<QString,int > map=listTimeType.at(i);
            int startT = map.value("startTime");
            int endT = map.value("endTime");
            int type = map.value("timeType");

            if(timeType == type){

                if(tmpendS<startT || tmpstartS>endT)
                    continue;

                if(tmpendS>=startT && tmpstartS<=startT){
                    map.insert("startTime",tmpstartS);
                    break;

                }

                if(tmpstartS<=endT || tmpendS>= endT){
                    map.insert("endTime",tmpstartS);
                    break;

                }
            }
        }

        if(!isDataIntersect){

            QMap<QString,int > map;
            map.insert("startTime",tmpstartS);
            map.insert("endTime",tmpstartS);
            map.insert("timeType",timeType);

        }
    }


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


        qDebug()<<" midValueTime    "<<midValueTime;
        midValueTime -= detime;


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
        else if(SencondsPerPix == 60)
            SencondsPerPix = 120;


    }else {

        if(SencondsPerPix == 120)
            SencondsPerPix = 60;
        else if(SencondsPerPix == 5)
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

void TimeLine::drawChart(QPainter *painter){}


