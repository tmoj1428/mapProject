import QtQuick 2.7
import QtLocation 5.9

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
