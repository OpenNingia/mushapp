#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QStandardPaths>
#include <QSqlDatabase>
#include <QSqlError>
#include <QtQml>
#include <QIcon>

#ifndef Q_OS_ANDROID
// WEB ENGINE
#   include <qtwebengineglobal.h>
#endif

#include "sqlcharactermodel.h"

static void connectToDatabase()
{
    QSqlDatabase database = QSqlDatabase::database();
    if (!database.isValid()) {
        database = QSqlDatabase::addDatabase("QSQLITE");
        if (!database.isValid())
            qFatal("Cannot add database: %s", qPrintable(database.lastError().text()));
    }

    const QDir writeDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!writeDir.mkpath("."))
        qFatal("Failed to create writable directory at %s", qPrintable(writeDir.absolutePath()));

    // Ensure that we have a writable location on all devices.
    const QString fileName = writeDir.absolutePath() + "/musha-db.sqlite3";
    // When using the SQLite driver, open() will create the SQLite database if it doesn't exist.
    database.setDatabaseName(fileName);
    if (!database.open()) {
        qFatal("Cannot open database: %s", qPrintable(database.lastError().text()));
        QFile::remove(fileName);
    }
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/appIcon.png"));

#ifndef Q_OS_ANDROID
    QtWebEngine::initialize();
#endif

    // install translators
    QTranslator qtTranslator;
    //qtTranslator.load("MushApp_" + QLocale::system().name(), "i18n/");

//#ifndef Q_OS_ANDROID
//    qtTranslator.load("MushApp_it", "i18n/");
//#else
    qtTranslator.load(":/i18n/MushApp_it.qm");
//#endif
    app.installTranslator(&qtTranslator);

/*
#ifndef Q_OS_ANDROID
    int fontId = QFontDatabase::addApplicationFont(QLatin1String("qrc:/fa/fontawesome-webfont.ttf"));
    qDebug() << "fontId: " << fontId;
    foreach(QString f,  QFontDatabase::applicationFontFamilies(fontId))
        qDebug() << f;
#endif
*/

    qmlRegisterType<SqlCharacterModel>("org.openningia.mushapp", 1, 0, "SqlCharacterModel");

    connectToDatabase();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dataModel", new SqlCharacterModel{});
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));    
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
