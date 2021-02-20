#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QtQuick/QQuickView>
#include <QQmlContext>
#include <QGeoRoute>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlProperty>
#include <QAbstractListModel>
MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);


    QQmlEngine engine;
    QQmlComponent component(&engine, QUrl("../mapProject/OSmap.qml"));
    QObject *object = component.create();
    QQuickView *view = new QQuickView();
    QWidget *container = QWidget::createWindowContainer(view, this);
    container->setMinimumSize(800, 800);
    container->setFocusPolicy(Qt::TabFocus);
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->setSource(QUrl("../mapProject/OSmap.qml"));
    ui->gridLayout->addWidget(container);

    QQmlProperty::write(object, "latitude", 35.6792);
    //qDebug() << "Property value:" << ;
    object->setProperty("longitude", 51.3990);
    QObject *mapRectangleID = object->findChild<QObject*>("mapRect");
    QAbstractListModel *pointList;
    if(mapRectangleID){
        qDebug() << "I am here";
    }else{
        qDebug() << "I am not here";
    }
    //qDebug() << "Property value:" << object->property("longitude");
}

MainWindow::~MainWindow()
{
    delete ui;
}
