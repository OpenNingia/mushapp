#include "gdrivewrapper.h"
#include "googleapps/jsonfile.h"

#include <algorithm>
#include <iterator>
#include <unordered_map>

#include <QDesktopServices>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QDir>

#include <QOAuthHttpServerReplyHandler>

GDriveWrapper::GDriveWrapper(IJsonImportExport* pIe, QObject *parent)
    : QObject(parent), oauth2(this), ie(pIe)
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
            return createRemoteFolder("MushApp", "#df2d2d", folderId);
        }

        return false;
    }

    return createRemoteFolder("MushApp", "#df2d2d", folderId);
}


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

bool GDriveWrapper::fileNameExists(const QString &fileName)
{
    return getFileIdByName(fileName).has_value();
}

stdexp::optional<QString> GDriveWrapper::getFileIdByName(const QString &fileName)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return stdexp::nullopt;

    GoogleDrive api(&oauth2);
    bool ok = false;

    QVariantMap vParams;
    vParams.insert("q", QString("name = '%1' and '%2' in parents").arg(fileName, folderId));

    auto list_reply = api.filesList(vParams);
    QJsonObject obj = GoogleDrive::waitReplyJson(list_reply, &ok);
    if ( !ok ) {
        return stdexp::nullopt;
    }

    if ( obj.contains("files") && obj["files"].isArray() && obj["files"].toArray().count() > 0 ) {
        return stdexp::make_optional<QString>(obj["files"].toArray().first().toObject()["fileId"].toString());
    }

    return stdexp::nullopt;
}

bool GDriveWrapper::upload(const QString &fileName, const QByteArray &content)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    if ( fileNameExists(fileName) ) {
        qInfo() << "file already exists: " << fileName;
        return false;
    }

    GoogleDrive api(&oauth2);
    bool ok = false;

    QJsonObject metadata;

    metadata.insert(QStringLiteral("mimeType"), "application/json");
    metadata.insert(QStringLiteral("name"), fileName);
    metadata.insert(QStringLiteral("parents"), QJsonArray() << folderId);
    metadata.insert(QStringLiteral("description"), QStringLiteral("MushApp export file"));

    //qDebug() << "metadata: " << QJsonDocument(metadata).toJson();

    auto obj = GoogleDrive::waitReplyJson(api.filesCreateMedia(metadata, content), &ok);
    if (ok) {
        //success
        QString id = obj.value("id").toString();
        qInfo() << "uploaded " << fileName << " with id:" << id;
    }
    return ok;
}

bool GDriveWrapper::update(const QString &fileId, const QByteArray &content)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    GoogleDrive api(&oauth2);
    bool ok = false;

    QJsonObject metadata;

    //metadata.insert(QStringLiteral("mimeType"), "application/json");
    //metadata.insert(QStringLiteral("name"), fileName);
    //metadata.insert(QStringLiteral("parents"), QJsonArray() << folderId);
    //metadata.insert(QStringLiteral("description"), QStringLiteral("MushApp export file"));

    //qDebug() << "metadata: " << QJsonDocument(metadata).toJson();

    auto obj = GoogleDrive::waitReplyJson(api.filesUpdateMedia(fileId, metadata, content), &ok);
    if (ok) {
        //success
        QString id = obj.value("id").toString();
        qInfo() << "updated file:" << id;
    }
    return ok;
}

/*bool GDriveWrapper::upload(const QString &filePath)
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
}*/

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

stdexp::optional<GDriveWrapper::RemoteFile> GDriveWrapper::get_remote_file(QString const & fileName)
{
    // 1. list remote files
    GoogleDrive api(&oauth2);
    bool ok = false;

    QVariantMap vParams;
    vParams.insert("q", QString("name = '%1' and '%2' in parents").arg(fileName, folderId));

    auto list_reply = api.filesList(vParams);
    QJsonObject obj = GoogleDrive::waitReplyJson(list_reply, &ok);
    if ( !ok ) {
        return stdexp::nullopt;
    }

    if ( !obj.contains("files") ) {
        qWarning("missing 'files' array in response");
        return stdexp::nullopt;
    }

    auto objFiles = obj["files"];
    if ( !objFiles.isArray() ) {
        qWarning("'files' element is not an array");
        return stdexp::nullopt;
    }

    auto arrayFiles = objFiles.toArray();
    if ( arrayFiles.count() == 0 ) {
        qWarning("'files' array is empty");
        return stdexp::nullopt;
    }

    auto fileElem = arrayFiles.first();
    if ( !fileElem.isObject() ) {
        qWarning("'file' element is not an object");
        return stdexp::nullopt;
    }

    auto fileObj = fileElem.toObject();
    if ( !fileObj.contains("id") ) {
        qWarning("missing expected 'id' field");
        return stdexp::nullopt;
    }

    QString file_id = fileObj["id"].toString();

    // 2. download file payload
    QByteArray payload;
    if ( !download(file_id, payload) ) {
        qWarning("content download failed");
        return stdexp::nullopt;
    }

    QJsonParseError jsonError;
    QJsonDocument doc = QJsonDocument::fromJson(payload, &jsonError);

    if ( jsonError.error != QJsonParseError::NoError) {
        qWarning() << "Could not parse remote file: " << jsonError.errorString();
        return stdexp::nullopt;
    }

    return stdexp::make_optional<RemoteFile>({std::move(file_id), std::move(doc)});
}

stdexp::optional<QJsonDocument> GDriveWrapper::generate_local_export()
{
    return ie->jsonExport();
}

QJsonDocument GDriveWrapper::merge_files(QJsonDocument const& remote, QJsonDocument const& local)
{
    auto aRemote = remote.array();
    auto aLocal = local.array();

    auto newer = [](QJsonObject const& a, QJsonObject const& b) -> QJsonObject const& {
        auto ts_key = QStringLiteral("timestamp");

        auto ats = a.value("timestamp").toDouble();
        auto bts = b.value("timestamp").toDouble();

        qDebug() << "compare " << a.value("name").toString() << "a: " << ats << "b: " << bts;

        return ats > bts ? a : b;
    };

    std::unordered_map<std::string, QJsonObject> characters_by_name;

    for(auto e: aLocal) {
        auto o = e.toObject();
        auto n = o.value("name").toString().toStdString();
        characters_by_name[n] = o;
    }

    qDebug() << "characters_by_name size: " << characters_by_name.size();

    for(auto e: aRemote) {
        auto o = e.toObject();
        auto n = o.value("name").toString().toStdString();
        auto i = characters_by_name.find(n);
        if ( i != characters_by_name.end() ) {
            qDebug() << "duplicate found with ts: " << i->second.value("timestamp");
            characters_by_name[n] = newer(o, i->second);
        }
        else
            characters_by_name[n] = o;
    }

    QJsonArray merged;
    for( auto k: characters_by_name )
        merged.append(k.second);

    return QJsonDocument{merged};
}

bool GDriveWrapper::update_remote_file(QString const & fileId, QString const& doc)
{
    return update(fileId, doc.toUtf8());
}

bool GDriveWrapper::upload_remote_file(QString const & fileName, QString const& doc)
{
    return upload(fileName, doc.toUtf8());
}

bool GDriveWrapper::syncAll(bool merge_remote)
{
    if ( !oauth2.isAuthorized() && !grant() )
        return false;

    // workflow
    // 1. get remote file musha-export.json
    // 2. generate local file musha-export.json
    // 3. somehow merge the two files
    // 4. update the remote file

    // 1. Get remote file
    qInfo("retrieving remote file...");
    auto remoteFile = get_remote_file("musha-export.json");
    if ( !remoteFile )
        qInfo("could not get remote file");

    qInfo("generating local export...");
    auto localFile = generate_local_export();
    if ( !localFile ) {
        qWarning("could not get local file");
        return false;
    }

    if ( remoteFile ) {
        qInfo() << "updating remote file: " << remoteFile->file_id;

        auto final = merge_remote ? merge_files(remoteFile->document, *localFile) : *localFile;

        if ( !update_remote_file(remoteFile->file_id, final.toJson()) ) {
            qWarning("could not update remote file!");
        }

        return ie->jsonImport(QJsonDocument{final});
    } else {
        qInfo("uploading local export...");
        return upload_remote_file("musha-export.json", localFile->toJson());
    }
}
