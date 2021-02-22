#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QtQuick>
#include <QQmlContext>
#include <QGeoRoute>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlProperty>
#include <QMessageBox>
#include "choosemap.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    Map();
    QQuickView *view = new QQuickView();
    QWidget *container = QWidget::createWindowContainer(view, this);
    container->setMinimumSize(800, 800);
    container->setFocusPolicy(Qt::TabFocus);
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    if(mapType == "OSM"){
        view->setSource(QUrl("../mapProject/OSmap.qml"));
        object = view->rootObject();
        map = object->findChild<QObject*>("map");
    }else{
        view->setSource(QUrl("../mapProject/googleMap.qml"));
        object = view->rootObject();
        map = object->findChild<QObject*>("googleMap");
    }
    QObject::connect(map, SIGNAL(distanceSignal(int)), this, SLOT(distanceMsgBox(int)));
    ui->gridLayout->addWidget(container);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::Map()
{
    chooseMap chooseMapWindow(this);
    chooseMapWindow.exec();
    mapType = chooseMapWindow.mapType;
}

void MainWindow::on_setPosition_clicked()
{
    QVariantMap newElement;
    double lat = ui->lat->text().toDouble();
    double lon = ui->lon->text().toDouble();
    newElement.insert("lat", lat);
    newElement.insert("lon", lon);
    QMetaObject::invokeMethod(map, "append", Q_ARG(QVariant, QVariant::fromValue(newElement)));
}


void MainWindow::distanceMsgBox(const int &distance){
    QMessageBox msgBox;
    msgBox.setText("The distance is about:");
    msgBox.setInformativeText(QString::number(distance) + " meters");
    msgBox.exec();
}
