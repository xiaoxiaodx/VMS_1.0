#ifndef TIMELINE_H
#define TIMELINE_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QPointF>
#include <QDebug>
#include <QPolygon>
#include <QTimer>


#define DAYSECONDS 86400
class TimeLine : public QQuickPaintedItem
{
    Q_OBJECT
public:
    TimeLine();


    Q_INVOKABLE void setTimeWarn(QVariant timeInfo);
    Q_INVOKABLE void addMidValueTime(qreal ms);


signals:
    void midValueChange(QString value);

    void requestReply(QString value);

protected:
    void paint(QPainter *painter);
    void mousePressEvent(QMouseEvent* event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);
    void wheelEvent(QWheelEvent *event);


    virtual void drawAxis(QPainter *painter);
    virtual void drawChart(QPainter *painter,int timeMin,int timeMax);




private:

    QString secondsToStr(int seconds);

    int SencondsPerPix;//每10个像素代表多少秒 ,10个像素为1个小刻度，60个像素为一个大刻度

    bool isMousePress;
    QPointF mouseDragPt;



    qreal midValueTime ;
    QList<QMap<QString,int> *> listTimeType;

    QString commonColor;
    QString warningColor;
};

#endif // CHARTBASE_H
