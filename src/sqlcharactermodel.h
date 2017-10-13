#pragma once

#include <QSqlTableModel>
#include "ijsonimportexport.h"

class SqlCharacterModel : public QSqlTableModel, public IJsonImportExport
{
    Q_OBJECT
    Q_PROPERTY(QString character READ character WRITE setCharacter NOTIFY characterChanged)
    Q_PROPERTY(QByteArray characterData READ characterData WRITE setCharacterData NOTIFY characterChanged)

public:
    SqlCharacterModel(QObject *parent = 0);

    QString character() const;
    void setCharacter(const QString & name);

    QByteArray characterData() const;
    void setCharacterData(const QByteArray & data);

    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
    QHash<int, QByteArray> roleNames() const Q_DECL_OVERRIDE;

    // creates a json document with all characters
    stdexp::optional<QJsonDocument> jsonExport() const override;
    bool jsonImport(QJsonDocument const& doc) override;

    Q_INVOKABLE bool addCharacter(const QString &name, const QString &title);
    Q_INVOKABLE bool delCharacter(const QString &name);

    // export all characters into a JSON file
    Q_INVOKABLE bool exportAll();
    // import characters from previous export
    Q_INVOKABLE bool importAll();
    // import one character, also useful for the rename feature
    Q_INVOKABLE bool importCharacter(const QString &name, const QByteArray &content);

signals:
    void characterChanged();
private:
    QString activeCharacter;   
};

