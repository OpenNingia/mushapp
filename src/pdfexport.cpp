#include "pdfexport.h"

#include <QPdfWriter>
#include <QPainter>
#include <QStandardPaths>
#include <QDir>
#include <QUrl>
#include <QImage>
#include <QDesktopServices>
#include <QRegularExpression>
#include <QDebug>

static QString& sanitizePath(QString& in)
{
#ifdef Q_OS_ANDROID
    // RESERVED "|\\?*<\":>/'";
    QRegularExpression rx{"["+QRegularExpression::escape("|\\?*<\":>/'")+"]"};
#else
    // RESERVED "<>:\"/\\|?*";
    QRegularExpression rx{"["+QRegularExpression::escape("<>:\"/\\|?*")+"]"};
#endif

    return in.replace(rx, "_");
}

void PdfExport::printPdf(QString const& characterName, QImage const& img)
{
    qDebug() << "img size px: " << img.width() << " x " << img.height();
    qDebug() << "img size mm: " << img.widthMM() << " x " << img.heightMM();

    const auto dpi = 300;

    QString fileName{characterName};
    fileName = sanitizePath(fileName);

    QString outPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    outPath.append("/org.openningia.mushapp/pdf");

    // create directory if not exists
    QDir().mkpath(outPath);

    QString outPdf = QString("%1/%2.pdf")
            .arg(outPath)
            .arg(fileName);

    QPdfWriter writer{outPdf};
    writer.setResolution(dpi);
    writer.setPageSize(QPdfWriter::A6);
    writer.setPageMargins(QMarginsF(0, 0, 0, 0));

    QPainter painter;
    painter.begin(&writer);
    painter.drawImage(0, 0, img);
    painter.end();

    QUrl urlToLocalFile{QUrl::fromLocalFile(outPdf)};
    bool success = QDesktopServices::openUrl(urlToLocalFile);
    if( !success )
        qCritical("openUrl failed?");
}
