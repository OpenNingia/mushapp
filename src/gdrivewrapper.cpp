#include "gdrivewrapper.h"
#include "googleapps/jsonfile.h"

#include <QDesktopServices>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QDir>

#include <QOAuthHttpServerReplyHandler>

GDriveWrapper::GDriveWrapper(QObject *parent)
    : QObject(parent), oauth2(this)
{

}

bool GDriveWrapper::grant()
{
    QString cfgPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    cfgPath.append("/org.openningia.mushapp/");

    //read tokens
    JsonFile settingsFile("settings.json");
    settingsFile.setPath(cfgPath);
    QJsonObject settings = settingsFile.read();

    //authorization
    QOAuthHttpServerReplyHandler *replyHandler = new QOAuthHttpServerReplyHandler(8080);
    replyHandler->setCallbackPath("cb");
    oauth2.setReplyHandler(replyHandler);
    QObject::connect(&oauth2, &GoogleOAuth2::authorizeWithBrowser, &QDesktopServices::openUrl);
                     /*[&](const QUrl &url){
        qInfo() << "authorize URL:" << url.toString();

        QDesk
    });*/

    oauth2.setClientIdJson(":/client_id.json");
    oauth2.setScope(GoogleDrive::scope());
    if (!settings.isEmpty()) {
        oauth2.setTokenJson(settings);
    }

    if ( !oauth2.isAuthorized() ) {
        oauth2.grant();
        bool ok = oauth2.waitAuthorization();
        if (ok) {
            //write tokens
            settingsFile.write(oauth2.tokenJson());
            return true;
        }

        return false;
    }

    return createRemoteFolder("MushApp", "#df2d2d", folderId);
}

/*

QNetworkReply *GoogleDrive::filesCreate(const QJsonObject &fileResource, const QVariantMap &parameters)
{
    QNetworkRequest request = this->createRequest(QUrl(API::FilesCreate), parameters);
    request.setHeader(QNetworkRequest::ContentTypeHeader, ContentTypeHeaderJSON);

    QByteArray buffer(QJsonDocument(fileResource).toJson());
    QNetworkReply *reply = this->post(request, buffer);
    return reply;
}

*/

bool GDriveWrapper::createRemoteFolder(const QString &folderName, const QString& rgbColor, QString & folderId)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    folderId = QString();

    GoogleDrive api(&oauth2);
    bool ok = false;

    QVariantMap vParams;
    vParams.insert("q", QString("mimeType = 'application/vnd.google-apps.folder' and name = '%1'").arg(folderName));

    qDebug() << "listing folders";

    auto list_reply = api.filesList(vParams);
    QJsonObject obj = GoogleDrive::waitReplyJson(list_reply, &ok);
    if ( !ok ) {
        qDebug() << "listing folders failed";
        return false;
    }

    if ( obj.contains("files") && obj["files"].isArray() ) {
        auto files_ = obj["files"].toArray();
        if ( files_.count() > 0 ) {
            folderId = files_[0].toObject().value("id").toString();
            qInfo() << "folder id already existed:" << folderId;
        }
    }

    if ( !folderId.isEmpty() )
        return true;

    QJsonObject metadata;
    metadata.insert(QStringLiteral("name"), folderName);
    metadata.insert(QStringLiteral("title"), folderName);
    metadata.insert(QStringLiteral("mimeType"), "application/vnd.google-apps.folder");
    metadata.insert(QStringLiteral("folderColorRgb"), rgbColor);
    metadata.insert(QStringLiteral("description"), QStringLiteral("MushApp sync folder"));

    auto reply = api.filesCreate(metadata);
    obj = GoogleDrive::waitReplyJson(reply, &ok);

    if (ok) {
        //success
        folderId = obj.value("id").toString();
        qInfo() << "folder id:" << folderId;
    }

    return ok;
}

bool GDriveWrapper::upload(const QString &filePath)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    auto fileName = QFileInfo(filePath).fileName();

    GoogleDrive api(&oauth2);
    bool ok = false;

    QVariantMap vParams;
    vParams.insert("q", QString("name = '%1' and '%2' in parents").arg(fileName, folderId));

    auto list_reply = api.filesList(vParams);
    QJsonObject obj = GoogleDrive::waitReplyJson(list_reply, &ok);
    if ( !ok ) {
        return false;
    }

    if ( obj.contains("files") && obj["files"].isArray() && obj["files"].toArray().count() > 0 ) {
        qInfo() << "file already exists: " << fileName;
        return true;
    }

    QJsonObject metadata;

    metadata.insert(QStringLiteral("mimeType"), "application/json");
    metadata.insert(QStringLiteral("name"), fileName);
    metadata.insert(QStringLiteral("parents"), QJsonArray() << folderId);
    metadata.insert(QStringLiteral("description"), QStringLiteral("MushApp export file"));

    qDebug() << "metadata: " << QJsonDocument(metadata).toJson();


    obj = GoogleDrive::waitReplyJson(api.filesCreateMedia(metadata, filePath), &ok);
    if (ok) {
        //success
        QString id = obj.value("id").toString();
        qInfo() << "id:" << id;
    }
    return ok;
}

bool GDriveWrapper::download(const QString &id, QByteArray & outData)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    GoogleDrive api(&oauth2);
    outData.clear();
    outData = GoogleDrive::waitReplyRAW(api.filesGetMedia(id));
    return outData.size() > 0;
}

bool GDriveWrapper::deleteResource(const QString &id)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    GoogleDrive api(&oauth2);
    QJsonObject obj = GoogleDrive::waitReplyJson(api.filesDelete(id));
    //filesDelete returns NULL if success
    return obj.isEmpty();
}

bool GDriveWrapper::copy(const QString &id)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    GoogleDrive api(&oauth2);
    bool ok = false;
    QJsonObject resource;
    resource.insert(QStringLiteral("name"), QString("Copy of %1").arg(id));
    QJsonObject obj = GoogleDrive::waitReplyJson(api.filesCopy(id, resource), &ok);
    if (ok) {
        //success
        qInfo() << obj;
        QString id = obj.value("id").toString();
        qInfo() << "id:" << id;
    }
    return ok;
}


bool GDriveWrapper::syncAll()
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    QString inPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    inPath.append("/org.openningia.mushapp/ie");

    QDir inDir{inPath};
    if ( !inDir.exists() ) {
        qWarning("import/export directory does not exists");
        return false;
    }

    auto files = inDir.entryInfoList(QStringList() << "*.json", QDir::Files, QDir::Name);
    if ( files.empty() ) {
        qWarning("import/export directory is empty");
        return false;
    }

    foreach(QFileInfo entry, files) {
        if ( !upload(entry.absoluteFilePath()) )
            qWarning() << "uploading failed: " << entry.absoluteFilePath();
    }

    return true;
}
