#ifndef IJSONIMPORTEXPORT_H
#define IJSONIMPORTEXPORT_H

#include "optional.hpp"
namespace stdexp = std::experimental;

// interface
class IJsonImportExport {
public:
    // creates a json document with all characters
    virtual stdexp::optional<QJsonDocument> jsonExport() const = 0;
    virtual bool jsonImport(QJsonDocument const& doc) = 0;
};

#endif // IJSONIMPORTEXPORT_H
