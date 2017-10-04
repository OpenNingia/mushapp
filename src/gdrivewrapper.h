#pragma once
#ifndef GDRIVE_WRAPPER_H
#define GDRIVE_WRAPPER_H

#include "googleapps/googleapps_global.h"
#include "googleapps/googleoauth2.h"
#include "googleapps/abstractgoogleapps.h"
#include "googleapps/googledrive.h"

class GDriveWrapper : public QObject {
    Q_OBJECT
public:
    explicit GDriveWrapper(QObject* parent = nullptr);
    bool grant();

    // functions
    bool createRemoteFolder(const QString &folderName, const QString& rgbColor, QString & folderId);
    bool upload(const QString &filename);
    bool download(const QString &id, QByteArray & outData);
    bool deleteResource(const QString &id);
    bool copy(const QString &id);

    // synchronize all characters with google drive
    Q_INVOKABLE bool syncAll();

private:
    GoogleOAuth2 oauth2;
    QString folderId;
};

#endif // GDRIVE_WRAPPER_H
