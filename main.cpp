#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFont>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("Declaration of VAR");
    app.setApplicationName("KodiRemote");
    app.setOrganizationDomain("decovar.io");
    app.setApplicationVersion("1.1");

    QFont font("Verdana", 16);
    app.setFont(font);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty()) { return -1; }

    return app.exec();
}
