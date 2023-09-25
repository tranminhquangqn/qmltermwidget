import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Controls 1.2

Rectangle {
    width: 640
    height: 480

    Action{
        onTriggered: terminal1.copyClipboard();
        shortcut: "Ctrl+Shift+C"
    }

    Action{
        onTriggered: terminal1.pasteClipboard();
        shortcut: "Ctrl+Shift+V"
    }

    Action{
        onTriggered: searchButton.visible = !searchButton.visible
        shortcut: "Ctrl+F"
    }

    Action{
        onTriggered:{
            console.log('open new terminal window in:'+mainsession.currentDir)
        }
        shortcut: "Ctrl+Shift+T"
    }

    QMLTermWidget {
        id: terminal1
        anchors.top: parent.top
        anchors.left:parent.left
        width:parent.width-scrollField.width
        height:parent.height
        font.family: "Monospace"
        font.pointSize: 12
        colorScheme: "cool-retro-term"
        session: QMLTermSession{
            id: mainsession
            initialWorkingDirectory: "$HOME"
            onMatchFound: {
                console.log("found at: %1 %2 %3 %4".arg(startColumn).arg(startLine).arg(endColumn).arg(endLine));
            }
            onNoMatchFound: {
                console.log("not found");
            }
        }
//        onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
//        onTerminalSizeChanged: console.log(terminalSize);
        Component.onCompleted: mainsession.startShellProgram();
    }
	 Rectangle{
	    id:scrollField
	    width: 20
	    height:parent.height
	    anchors.right:parent.right
	    color: "#373737"
	    QMLTermScrollbar {
		id: termScrollBar
		z:1
		terminal: terminal1
		anchors.right:parent.right
		width: 20
	    }
	    MouseArea{
		anchors.fill: parent
		onPressed: {
		    termScrollBar.pressedColor()
		    termScrollBar.moveThumb(mouseY)
		}
		onReleased: {
		    termScrollBar.releasedColor()
		}
		onPositionChanged: {
		    termScrollBar.moveThumb(mouseY)
		}
	    }
	}

    Button {
        id: searchButton
        text: "Find version"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: false
        onClicked: mainsession.search("version");
    }
    Component.onCompleted: terminal1.forceActiveFocus();
}
