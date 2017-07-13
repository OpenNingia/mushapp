#include "sqlcharactermodel.h"

#include <QDateTime>
#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>
#include <QSqlQuery>

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

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
    o["auraLvl"] = 0;
    o["auraPoints"] = 0;
    o["moves"] = QJsonArray{};
    o["superMoves"] = QJsonArray{};

    QSqlRecord newRecord = record();
    newRecord.setValue("name", name);
    newRecord.setValue("content", QJsonDocument{o}.toBinaryData());

    qDebug() << "current rowCount: " << rowCount();

    if (!insertRecord(rowCount(), newRecord)) {
        qWarning() << "Failed to add character:" << lastError().text();
        return false;
    }

    if ( !submitAll() ) {
        return false;
    }    

    qDebug() << "after addCharacter rowCount: " << rowCount();

    endInsertRows();

    setTable(charactersTableName);
    setSort(0, Qt::DescendingOrder);
    select();
    // Ensures that the model is sorted correctly after submitting a new row.
    setEditStrategy(QSqlTableModel::OnManualSubmit);

    return true;
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

    setCharacter(QString::null);
    return true;
}

/*void SqlCharacterModel::updCharacter(const QModelIndex &index, const QByteArray & data)
{
    if ( !setData(index, data, Qt::UserRole+1) ) {
        qWarning("could not update character data");
    }
    submitAll();
}*/

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

    //updCharacter(index(0,0), QJsonDocument::fromJson(data).toBinaryData());
}
