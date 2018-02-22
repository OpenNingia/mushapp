#pragma once
#ifndef GDRIVE_WRAPPER_H
#define GDRIVE_WRAPPER_H

#include <QJsonDocument>

#include "googleapps/googleapps_global.h"
#include "googleapps/googleoauth2.h"
#include "googleapps/abstractgoogleapps.h"
#include "googleapps/googledrive.h"

#include "ijsonimportexport.h"
#include "optional.hpp"
namespace stdexp = std::experimental;

class GDriveWrapper : public QObject {
    Q_OBJECT
public:
    explicit GDriveWrapper(IJsonImportExport* ie, QObject* parent = nullptr);
    bool grant();

    // functions
    bool createRemoteFolder(const QString &folderName, const QString& rgbColor, QString & folderId);
    bool fileNameExists(const QString &fileName);
    stdexp::optional<QString> getFileIdByName(const QString &fileName);
    bool upload(const QString &fileName, const QByteArray &content);
    bool update(const QString &id, const QByteArray &content);
    bool download(const QString &id, QByteArray & outData);
    bool deleteResource(const QString &id);
    bool copy(const QString &id);

    // synchronize all characters with google drive
    Q_INVOKABLE bool syncAll(bool merge_remote = true);
private:
    GoogleOAuth2 oauth2;
    QString folderId;    
    IJsonImportExport* ie;

private:

    struct RemoteFile {
        QString file_id;
        QJsonDocument document;
    };

    stdexp::optional<RemoteFile> get_remote_file(const QString &fileName);
    stdexp::optional<QJsonDocument> generate_local_export();
    QJsonDocument merge_files(QJsonDocument const& remote, QJsonDocument const& local);
    bool update_remote_file(QString const & file_id, QString const& doc);
    bool upload_remote_file(QString const & fileName, QString const& doc);
};

#endif // GDRIVE_WRAPPER_H
