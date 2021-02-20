import QtQuick 2.7
import QtQuick.Window 2.14
import QtQuick.Controls 1.4
import QtLocation 5.9
import QtPositioning 5.9

Item{
    property double latitude: 0.0
    property double longitude: 0.0
    property var point1: QtPositioning.coordinate();
    property var point2: QtPositioning.coordinate();
    TabView{
        objectName: "tabView"
        anchors.fill: parent
        Tab{
            objectName: "firstTab"
            anchors.fill:parent
            title: "OS maps"    
                Rectangle {                    
                    visible: true
                    id: mapRectangleID
                    objectName: "mapRect"
                    width: 1024
                    height: 800
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    ListModel {
                        id: markerModel
                        dynamicRoles: true
                    }
                    ListModel {
                        id: pointModel
                        ListElement {lat:35.6792; lon:51.3990}
                        ListElement {lat:35.6892; lon:51.3690}
                    }

                    Map {
                        id: map_id
                        anchors.fill: parent
                        plugin: Plugin { name: "osm" }
                        center: QtPositioning.coordinate(35.6892,51.3890)
                        zoomLevel: 15
                        PluginParameter {
                            name: "osm.mapping.providersrepository.disabled"
                            value: "true"
                        }
                        PluginParameter {
                            name: "osm.mapping.providersrepository.address"
                            value: "http://maps-redirect.qt.io/osm/5.8"
                        }
                        MapQuickItem {
                            id: marker_id
                            sourceItem: Image {
                                id: endPointImage
                                source: "./marker2.png"
                                width: 50
                                height: 50
                            }
                            anchorPoint.x: endPointImage.width / 2
                            anchorPoint.y: endPointImage.height
                        }
                        MapQuickItem {
                            id: marker_id2
                            sourceItem: Image {
                                id: endPointImage2
                                source: "./marker2.png"
                                width: 50
                                height: 50
                            }
                            anchorPoint.x: endPointImage.width / 2
                            anchorPoint.y: endPointImage.height
                        }
                        RouteModel {
                            id: routeBetweenPoints
                            plugin: Plugin { name: "osm" }
                            query: RouteQuery {id: routeQuery }
                        }
                        MapItemView {
                            model: markerModel
                            id: point
                            delegate: Component {
                                MapQuickItem {
                                    coordinate: model.position
                                    sourceItem: Image {
                                        width: 50
                                        height: 50
                                        source: "./marker2.png"
                                    }
                                }

                            }

                        }
                        MapItemView {
                            model: pointModel
                            delegate: Component {
                                MapQuickItem {
                                    coordinate: QtPositioning.coordinate(lat, lon)
                                    anchorPoint: Qt.point(35.6792,51.3990)
                                    sourceItem: Image {
                                        width: 50
                                        height: 50
                                        source: "./marker2.png"
                                    }
                                }
                            }
                        }
                        MapItemView {
                            model: routeBetweenPoints
                            id: route
                            delegate: Component {
                                MapRoute {
                                    route: routeData
                                    line.color: "red"
                                    line.width: 10
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (markerModel.count < 2){
                                    var coordinate = map_id.toCoordinate(Qt.point(mouseX, mouseY))
                                    point1 = coordinate
                                    point2 = coordinate
                                    markerModel.append({"position": coordinate})
                                    routeQuery.addWaypoint(point1)
                                    routeQuery.addWaypoint(point2)
                                    routeBetweenPoints.update()
                                    route.update()
                                    point.update()
                                }
                            }
                            onPressAndHold: {
                                markerModel.remove({"position": point2})
                                var coordinate = map_id.toCoordinate(Qt.point(mouseX, mouseY))
                                markerModel.append({"position": coordinate})
                                point2 = coordinate
                                routeQuery.addWaypoint(point1)
                                routeQuery.addWaypoint(point2)
                                routeBetweenPoints.update()
                                route.update()
                                point.update()
                            }



                            /*
                            onPressed: {
                                var coordinate = map_id.toCoordinate(Qt.point(mouseX, mouseY))
                                marker_id2.coordinate = coordinate
                                routeBetweenPoints.point1 = coordinate
                                update()
                            }
                            onPressAndHold: {
                                var coordinate = map_id.toCoordinate(Qt.point(mouseX, mouseY))
                                marker_id.coordinate = coordinate
                                routeBetweenPoints.point2 = coordinate
                                update()
                            }*/
                        }

                        Button{
                            id: zoom
                            anchors {
                                right: parent.right
                                bottom: parent.bottom
                                margins: 10
                            }
                            iconSource: "./zoomIn.png"
                            onClicked: map_id.zoomLevel += 0.5
                        }
                        Button{
                            id:zoomOut
                            anchors {
                                right: parent.right
                                top: parent.top
                                margins: 10
                            }
                            iconSource: "./zoomOut.png"
                            onClicked: map_id.zoomLevel -= 0.5
                        }
                    }

            }
        }
        Tab{
            title: "Google maps"
            Rectangle { color: "blue" }
        }
    }
}
