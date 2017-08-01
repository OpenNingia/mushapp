#include "sqlcharactermodel.h"

#include <QDateTime>
#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>
#include <QSqlQuery>

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QDesktopServices>

static const char *charactersTableName = "Characters";

static void createTable()
{
    QSqlQuery query;
    if (!query.exec(
        "CREATE TABLE IF NOT EXISTS 'Characters' ("
        "'name' TEXT PRIMARY KEY,"
        "'content' BLOB"
        ")")) {
        qFatal("Failed to query database: %s", qPrintable(query.lastError().text()));
    }
}

SqlCharacterModel::SqlCharacterModel(QObject *parent) :
    QSqlTableModel(parent)
{
    createTable();
    setTable(charactersTableName);
    setSort(0, Qt::DescendingOrder);
    select();
    // Ensures that the model is sorted correctly after submitting a new row.
    setEditStrategy(QSqlTableModel::OnManualSubmit);
}

QVariant SqlCharacterModel::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const auto column = role - Qt::UserRole;
    const auto sqlRecord = record(index.row());
    auto raw_value = sqlRecord.value(column);

    // content
    if ( column == 1 ) {
        // return json string
        return QJsonDocument::fromBinaryData(raw_value.toByteArray()).toJson();
    } else {
        return raw_value;
    }

    return sqlRecord.value(role - Qt::UserRole);
}

QHash<int, QByteArray> SqlCharacterModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[Qt::UserRole + 0] = "name";
    names[Qt::UserRole + 1] = "content";
    return names;
}

bool SqlCharacterModel::addCharacter(const QString &name, const QString &title)
{
    bool ret = true;

    beginInsertRows(QModelIndex{}, rowCount(), rowCount());

    const QString timestamp = QDateTime::currentDateTime().toString(Qt::ISODate);

    QJsonObject o;
    o["name"] = name;
    o["title"] = title;
    o["speed"] = 0;
    o["attack"] = 0;
    o["defence"] = 0;
    o["balance"] = 0;
    o["willpower"] = 0;
    o["exp"] = 0;

    QJsonObject aura;
    aura["tag"] = QString{"none"};
    aura["special"] = QString{"none"};
    aura["level"] = 0;
    aura["points"] = 0;
    o["aura"] = aura;

    QJsonObject armor;
    armor["name"] = QString{};
    armor["speed"] = 0;
    armor["attack"] = 0;
    armor["defence"] = 0;
    armor["build"] = 0;
    armor["integrity"] = 0;
    armor["symbols"] = QJsonArray{};
    o["armor"] = armor;

    QJsonObject weapon;
    weapon["name"] = QString{};
    weapon["speed"] = 0;
    weapon["attack"] = 0;
    weapon["defence"] = 0;
    weapon["build"] = 0;
    weapon["integrity"] = 0;
    weapon["symbols"] = QJsonArray{};
    o["weapon"] = weapon;

    o["moves"] = QJsonArray{};
    o["superMoves"] = QJsonArray{};

    QSqlRecord newRecord = record();
    newRecord.setValue("name", name);
    newRecord.setValue("content", QJsonDocument{o}.toBinaryData());

    qDebug() << "current rowCount: " << rowCount();

    if (!insertRecord(rowCount(), newRecord) || !submitAll()) {
        qWarning() << "Failed to add character:" << lastError().text();
        ret = false;
    }

    qDebug() << "after addCharacter rowCount: " << rowCount();

    endInsertRows();

    setTable(charactersTableName);
    setSort(0, Qt::DescendingOrder);
    select();
    // Ensures that the model is sorted correctly after submitting a new row.
    setEditStrategy(QSqlTableModel::OnManualSubmit);

    return ret;
}

bool SqlCharacterModel::importCharacter(const QString &name, const QByteArray &content)
{
    bool ret = true;

    beginInsertRows(QModelIndex{}, rowCount(), rowCount());

    const QString timestamp = QDateTime::currentDateTime().toString(Qt::ISODate);

    QSqlRecord newRecord = record();
    newRecord.setValue("name", name);
    newRecord.setValue("content", content);

    if (!insertRecord(rowCount(), newRecord) || !submitAll()) {
        qWarning() << "Failed to import character:" << lastError().text();
        ret = false;
    }

    endInsertRows();

    setTable(charactersTableName);
    setSort(0, Qt::DescendingOrder);
    select();
    // Ensures that the model is sorted correctly after submitting a new row.
    setEditStrategy(QSqlTableModel::OnManualSubmit);

    return ret;
}

bool SqlCharacterModel::delCharacter(const QString& name)
{
    setCharacter(name);

    if ( !removeRow(0) ) {
        qWarning("could not remove record");
        qWarning() << lastError().driverText();
        qWarning() << lastError().databaseText();
        return false;
    }

    if ( !submitAll() ) {
        qWarning("could not submit data");
        qWarning() << lastError().driverText();
        qWarning() << lastError().databaseText();
        return false;
    }

    setCharacter(QString{});
    return true;
}

QString SqlCharacterModel::character() const {
    return activeCharacter;
}

void SqlCharacterModel::setCharacter(const QString & name)
{
    if (name == activeCharacter)
        return;

    activeCharacter = name;

    if ( name.isNull() || name.isEmpty() ) {
        setFilter(QString{});
    } else {
        const QString filterString = QString::fromLatin1(
            "(name = '%1')").arg(activeCharacter);
        setFilter(filterString);
    }
    select();

    emit characterChanged();
}

QByteArray SqlCharacterModel::characterData() const
{
    if ( activeCharacter.isNull() || activeCharacter.isEmpty() )
        return {};
    return data(index(0, 0), Qt::UserRole + 1).toByteArray();
}
void SqlCharacterModel::setCharacterData(const QByteArray & data)
{
    if ( activeCharacter.isNull() || activeCharacter.isEmpty() )
        return;

    auto rec = record(0);
    rec.setValue("content", QJsonDocument::fromJson(data).toBinaryData());

    if ( !setRecord(0, rec) ) {
        qWarning("could not update record");
        qWarning() << lastError().driverText();
        qWarning() << lastError().databaseText();
    }

    if ( !submitAll() ) {
        qWarning("could not submit data");
        qWarning() << lastError().driverText();
        qWarning() << lastError().databaseText();
    }
}


// export all characters into a JSON file
bool SqlCharacterModel::exportAll()
{
    // should not export a single character
    if ( !(activeCharacter.isNull() || activeCharacter.isEmpty()) )
        return false;

    QString outPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    outPath.append("/org.openningia.mushapp/ie");

    // create directory if not exists
    QDir().mkpath(outPath);

    auto timeStamp = QDateTime::currentDateTimeUtc().toString(Qt::ISODate)
            .replace(":", "")
            .replace("-", "");

    QString outJson = QString("%1/export_%2.json")
            .arg(outPath)
            .arg(timeStamp);

    QJsonArray lst;

    for(int i = 0; i < rowCount(); i++) {
        auto json_value = QJsonDocument::fromBinaryData(record(i).value("content").toByteArray());
        lst.append(json_value.object());
    }

    QFile writer{outJson};
    if ( writer.open(QFile::WriteOnly) )
        return writer.write(QJsonDocument(lst).toJson()) != 0;
    return false;
}

// import characters from previous export
bool SqlCharacterModel::importAll()
{
    QString inPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    inPath.append("/org.openningia.mushapp/ie");

    QDir inDir{inPath};
    if ( !inDir.exists() )
        return false;

    auto files = inDir.entryInfoList(QStringList() << "*.json", QDir::Files, QDir::Name);
    if ( files.empty() )
        return false;

    auto importFrom = files.last();


    QFile reader(importFrom.absoluteFilePath());
    if ( reader.open(QFile::ReadOnly) ) {
        auto doc = QJsonDocument::fromJson(reader.readAll());

        if ( !doc.isArray() )
            return false;

        QJsonArray lst{doc.array()};
        for(auto c: lst) {
            if ( c.isObject() ) {
                auto o = c.toObject();
                QJsonDocument d{o};
                importCharacter(o["name"].toString(), d.toBinaryData());
            }
        }

        return true;
    }

    return false;
}
