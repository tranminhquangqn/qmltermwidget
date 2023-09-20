import QtQuick 2.0
import QMLTermWidget 1.0


import QtQuick.Controls 2.12
Item {
    id:thumb
    property QMLTermWidget terminal
    property int value: terminal.scrollbarCurrentValue
    property int minimum: terminal.scrollbarMinimum
    property int maximum: terminal.scrollbarMaximum
    property int lines: terminal.lines
    property int totalLines: lines + maximum

    property bool isPressed: false
    property int heightValue:terminal.height * (lines / (totalLines - minimum))
    property int yValue:(terminal.height / (totalLines)) * (value - minimum)
    property int heightWhenClick
    property int yWhenClick

    anchors.right: terminal.right
    opacity: 1.0
    height: isPressed ? heightWhenClick:heightValue
    y:isPressed ? yWhenClick:yValue
    function moveThumb(value){
        isPressed=true
        terminal.setScrollbarValue((value-(heightValue/2))/(terminal.height / (totalLines)))
        isPressed=false
    }
    function pressedColor(){
        thumbView.color="orange"
    }
    function releasedColor(){
        thumbView.color=thumbView.defaultColor
    }
    Rectangle {
        id:thumbView
        opacity: 0.4
        anchors.margins: 5
        radius: width * 0.5
        anchors.fill: parent
        color: "#636363"
        property string defaultColor: "lightgray"
    }
    MouseArea {
        id: thumbArea
        anchors.fill:parent
        drag.target: termScrollBar
        cursorShape:Qt.SizeAllCursor
        drag.minimumY:0
        drag.maximumY:terminal.height-height
        hoverEnabled: true
        onEntered: {
            if(!isPressed){
                thumbView.color="white"
            }
        }
        onExited: {
            if(!isPressed){
                thumbView.color=thumbView.defaultColor
            }
        }
        onPressed: {
            thumbView.color="orange"
            heightWhenClick=heightValue
            yWhenClick=yValue
            isPressed=true
        }
        onReleased: {
            thumbView.color=thumbView.defaultColor
            isPressed=false
        }

    }
    onYChanged: {
        if(isPressed){
            terminal.setScrollbarValue(y/(terminal.height / (totalLines)))
        }
    }
}
