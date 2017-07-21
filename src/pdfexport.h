#pragma once

#include <QObject>
#include <QImage>
#include <QString>

class PdfExport : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE void printPdf(const QString &characterName, QImage const& img);
};
