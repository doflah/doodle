#ifndef BACKEND_PLUGIN_H
#define BACKEND_PLUGIN_H

#include <QObject>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlExtensionPlugin>

class BackendPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
};

class DoodleStore : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appDir READ appDir)

protected:
    QString appDir() {
        QString dir = getenv("XDG_DATA_HOME");
        if (dir.isEmpty()) {
            return "/tmp";
        }
        return dir + "/doodle.doflah";
    }
};

#endif // BACKEND_PLUGIN_H
