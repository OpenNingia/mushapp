#pragma once

#include <QSqlTableModel>

class SqlCharacterModel : public QSqlTableModel
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

    Q_INVOKABLE bool addCharacter(const QString &name, const QString &title);
    Q_INVOKABLE bool delCharacter(const QString &name);

    // export all characters into a JSON file
    Q_INVOKABLE bool exportAll();
    // import characters from previous export
    Q_INVOKABLE bool importAll();

signals:
    void characterChanged();
private:
    QString activeCharacter;

    bool importCharacter(const QString &name, const QByteArray &content);
};

