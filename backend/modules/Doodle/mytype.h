#ifndef MYTYPE_H
#define MYTYPE_H

#include <QObject>

class Environ : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString appDir READ appDir)

public:
    explicit Environ(QObject *parent = 0);
    ~Environ();

Q_SIGNALS:
    void helloWorldChanged();

protected:
    QString appDir() { return m_message; }

    QString m_appdir;
};

#endif // MYTYPE_H

