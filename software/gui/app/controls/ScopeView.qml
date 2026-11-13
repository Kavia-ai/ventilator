import QtQuick 2.11
import QtQuick.Controls 2.4
import Respira 1.0
import ".."

Item {

    id: root
    width: 606; height: 144

    property double yMin: -1.5
    property double yMax: 1.5
    property double rangeInSeconds: 30
    property int alarmPriority: AlarmPriority.NONE
    property color signalColor: Style.theme.color.pressureGraphLine

    property alias name: nameLabel.text
    property alias unit: unitLabel.text

    property alias showBottomLine: bottomLine.visible
    property alias dataset: timeSeriesGraph.dataset

    Rectangle {
        anchors.fill: parent
        color: Style.theme.color.surface
        radius: 8
    }

    Repeater {
        model: 2
        Rectangle {
            x: timeSeriesGraph.x
            y: timeSeriesGraph.y + timeSeriesGraph.height * (index + 1) / 3
            width: timeSeriesGraph.width
            height: 1
            color: Style.theme.color.border
            opacity: 0.45
        }
    }

    Repeater {
        model: 4
        Rectangle {
            x: timeSeriesGraph.x + timeSeriesGraph.width * (index + 1) / 5
            y: timeSeriesGraph.y
            width: 1
            height: timeSeriesGraph.height
            color: Style.theme.color.border
            opacity: 0.25
        }
    }

    Text {
        id: yMaxLabel
        anchors {
            top: parent.top; topMargin: 8
            right: timeSeriesGraph.left; rightMargin: 8
            left: parent.left; leftMargin: 22
        }

        font: Style.theme.font.graphLabel
        horizontalAlignment: Text.AlignRight
        text: yMax.toFixed(0).toString()
        color: Style.theme.color.textAlternative
    }

    Text {
        id: yMinLabel
        anchors {
            left: parent.left; leftMargin: 8
            right: timeSeriesGraph.left; rightMargin: 8
            top: yMaxLabel.bottom; topMargin: 90
        }
        font: Style.theme.font.graphLabel
        horizontalAlignment: Text.AlignRight
        text: yMin.toFixed(0).toString()
        color: Style.theme.color.textAlternative
    }

    Rectangle {
        x: graphLabelRow.x - 5
        y: graphLabelRow.y - 2
        width: graphLabelRow.width + 10
        height: graphLabelRow.height + 4
        radius: 6
        color: Style.theme.color.windowBackground
        border.width: 1
        border.color: Style.theme.color.border
        z: 1
    }

    Row {
        id: graphLabelRow
        z: 2
        anchors {
            top: parent.top; topMargin: 8
            left: yMaxLabel.right; leftMargin: 8
        }
        spacing: 4

        Rectangle {
            width: 6
            height: 6
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            color: root.alarmPriority === AlarmPriority.NONE ?
                       root.signalColor :
                       Style.theme.color.timeSeries.lineByPriority(root.alarmPriority
                       )
        }

        Text {
            id: nameLabel
            color: Style.theme.color.textPrimary
            font: Style.theme.font.parameterDisplay
        }

        Text {
            id: unitLabel
            textFormat: Text.RichText
            color: Style.theme.color.textAlternative
            font: Style.theme.font.parameterDisplay
        }
    }

    TimeSeriesGraph {
        id: timeSeriesGraph
        lineColor: root.alarmPriority === AlarmPriority.NONE ?
                       root.signalColor :
                       Style.theme.color.timeSeries.lineByPriority(root.alarmPriority)
        areaColor: root.alarmPriority === AlarmPriority.NONE ?
                       Qt.rgba(root.signalColor.r, root.signalColor.g, root.signalColor.b, 0.06) :
                       Style.theme.color.timeSeries.areaByPriority(root.alarmPriority)
        anchors {
            top: parent.top; topMargin: 12
            left: parent.left; leftMargin: 48
            right: parent.right; rightMargin:4
            bottom: parent.bottom; bottomMargin: 4
        }
        minValue: root.yMin
        maxValue: root.yMax
        rangeInSeconds: root.rangeInSeconds
    }

    Rectangle {
        id: bottomLine
        anchors {
            bottom: parent.bottom; bottomMargin: 0
            left: parent.left; leftMargin: 4
            right: parent.right; rightMargin: 4
        }
        width: parent.width; height: 1
        color: Style.theme.color.border
    }
}
