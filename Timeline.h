#ifndef TIMELINE_H
#define TIMELINE_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QPointF>
#include <QDebug>
#include <QPolygon>
#include <QTimer>

class TimeLine : public QQuickPaintedItem
{
    Q_OBJECT
public:
    TimeLine();



    Q_INVOKABLE void setTimeWarn(QVariant timeInfo);


protected:
    void paint(QPainter *painter);



    void mousePressEvent(QMouseEvent* event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);
    void wheelEvent(QWheelEvent *event);


    virtual void drawAxis(QPainter *painter);
    virtual void drawChart(QPainter *painter);




private:


    int SencondsPerPix;//每10个像素代表多少秒 ,10个像素为1个小刻度，60个像素为一个大刻度

    bool isMousePress;
    QPointF mouseDragPt;



    int midValueTime ;
    QList<QMap<QString,int>> listTimeType;
};

#endif // CHARTBASE_H
