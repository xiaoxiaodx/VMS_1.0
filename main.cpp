#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "XVideo.h"
#include "qmllanguage.h"
#include "ccrashstack.h"
#include "devicemanagerment.h"

#include <QFile>
#include <QFont>

long __stdcall   callback(_EXCEPTION_POINTERS*   excp)
{

    CCrashStack crashStack(excp);

    QString sCrashInfo = crashStack.GetExceptionInfo();

    QString sFileName = "testcrash.log";

    QFile file(sFileName);

    if (file.open(QIODevice::WriteOnly|QIODevice::Truncate))

    {

        file.write(sCrashInfo.toUtf8());

        file.close();

    }



    qDebug()<<"Error:\n"<<sCrashInfo;

    //MessageBox(0,L"Error",L"error",MB_OK);

    return   EXCEPTION_EXECUTE_HANDLER;
}


int main(int argc, char *argv[])
{


    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);


    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;


    app.setOrganizationName("Gaozhi"); //1
    app.setOrganizationDomain("gaozhi.com"); //2
    app.setApplicationName("VMS_V1.2"); //3


    QFont font("Microsoft Yahei",15);
    app.setFont(font);

    SetUnhandledExceptionFilter(callback);
    QmlLanguage qmlLanguage(app, engine);
    engine.rootContext()->setContextProperty("qmlLanguage", &qmlLanguage);

    // XVideo 为QPaint显示视频(光栅绘图)
    qmlRegisterType<XVideo>("XVideo", 1, 0, "XVideo");
    qmlRegisterType<DeviceManagerment>("DeviceManagerment", 1, 0, "DeviceManagerment");
//    qmlRegisterType<TcpWorker>("TcpWorker", 1, 0, "TcpWorker");
//    qmlRegisterType<P2pWorker>("P2pWorker", 1, 0, "P2pWorker");

    engine.load("qrc:/qml/main.qml");



    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}

