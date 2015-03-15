#include <QtQml>
#include <QtQml/QQmlContext>
#include "backend.h"


void BackendPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("Doodle"));

    qmlRegisterType<DoodleStore>(uri, 1, 0, "DoodleStore");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}

