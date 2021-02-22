import QtQuick 2.7
import QtQuick.Window 2.14
import QtQuick.Controls 1.4
import QtLocation 5.9
import QtPositioning 5.9

Item {
    objectName: "root"
    property var point1: QtPositioning.coordinate();
    property var point2: QtPositioning.coordinate();
    property int pointNumber: 0
    property int distance: 0
    TabView{
        objectName: "tabView"
        anchors.fill: parent
        Tab{
            objectName: "firstTab"
            anchors.fill:parent
            title: "Google maps"
                Rectangle {
                    visible: true
                    id: mapRectangleID2
                    objectName: "mapRect"
                    width: 1024
                    height: 800
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    ListModel {
                        id: markerModel2
                        dynamicRoles: true
                    }
                    ListModel {
                        id: pointModel2
                        dynamicRoles: true
                    }
                    Map {
                        id: map
                        objectName: "googleMap"
                        anchors.fill: parent
                        plugin: Plugin { name: "googlemaps" }
                        center: QtPositioning.coordinate(35.6892,51.3890)
                        zoomLevel: 15
                        MapItemView {
                            model: markerModel2
                            id: googlePoint
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
                        RouteModel {
                            id: googleRouteBetweenPoints
                            plugin: Plugin { name: "osm" }
                            query: RouteQuery {id: googleRouteQuery }
                        }
                        MapItemView {
                            model: pointModel2
                            id: mapPointer
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
                            model: googleRouteBetweenPoints
                            id: googleRoute
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
                                if (markerModel2.count < 2){
                                    var coordinate = map.toCoordinate(Qt.point(mouseX, mouseY))
                                    point1 = coordinate
                                    markerModel2.append({"position": coordinate})
                                    googleRouteQuery.addWaypoint(point1)
                                    googleRouteBetweenPoints.update()
                                    googleRoute.update()
                                    googlePoint.update()
                                    if(markerModel2.count == 2){
                                        distance = markerModel2.get(0).position.distanceTo(markerModel2.get(1).position)
                                        map.distanceSignal(distance)
                                        console.log(distance)
                                    }
                                }
                            }
                            onPressAndHold: {
                                markerModel2.clear()
                                googleRouteQuery.clearWaypoints()
                                var coordinate = map.toCoordinate(Qt.point(mouseX, mouseY))
                                markerModel2.append({"position": coordinate})
                                point1 = coordinate
                                googleRouteQuery.addWaypoint(point1)
                                googleRouteBetweenPoints.update()
                                googleRoute.update()
                                googlePoint.update()
                            }
                        }
                        function append(newElement) {
                            pointModel2.append({"position": QtPositioning.coordinate(newElement.lat, newElement.lon)})
                            pointNumber = pointModel2.count - 1
                            console.log(pointNumber)
                        }
                        signal distanceSignal(distance: int)
                        Button{
                            id: googleLastPoint
                            anchors {
                                right: parent.right
                                top: parent.verticalCenter
                                margins: 10
                            }
                            iconSource: "./center.png"
                            onClicked: {
                                if(pointModel2.count > 0){
                                    map.center = pointModel2.get(pointNumber).position
                                    map.zoomLevel = 18
                                }
                            }
                        }
                        Slider{
                            id: googleZoomSlider
                            anchors {
                                left: parent.left
                                leftMargin: 20
                                topMargin: 50
                                bottomMargin: 0
                            }
                            height: parent.height - 50
                            value: map.zoomLevel
                            maximumValue: 22.0
                            stepSize: 0.1
                            minimumValue: 8.0
                            orientation: Qt.Vertical
                            onPressedChanged: {
                                map.zoomLevel = googleZoomSlider.value
                            }
                        }
                    }
                }
            }
    }
}
