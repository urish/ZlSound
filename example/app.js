Titanium.UI.setBackgroundColor('#000');
Titanium.UI.iPhone.hideStatusBar();

var ZLSound = require('com.salsarhythmsoftware.zlsound');

function createNoteController(name, fileName, pitch, loop, rect) {
	var soundFile = Ti.Filesystem.getFile(fileName).nativePath;
	var sample = ZLSound.createSample({
        media: soundFile,
        loopIn: loop[0], 
        loopOut: loop[1],
        pitch: pitch
    });
	
	function play() {
		Ti.API.info("Playing: " + this.name);
		sample.loop(1000);
	}
	
	function stop() {
		Ti.API.info("Stopping: " + this.name);
		sample.stop();
	}
	
	return {
		name: name,
		rect: rect,
		play: play,
		stop: stop,
	};
}

var noteDatabaseFile = Ti.Filesystem.getFile("notes.json");
var noteDatabase = JSON.parse(noteDatabaseFile.read().toString());
var win = Ti.UI.createWindow({
	orientationModes: [Ti.UI.LANDSCAPE_RIGHT, Ti.UI.LANDSCAPE_LEFT]
});
var isiPad = (Ti.Platform.osname == "ipad");

var backgroundImage = Ti.UI.createImageView({
	image: isiPad ? "background@2x.png" : "background.png",
	height: isiPad ? 480 : 320,
	width: isiPad ? 720 : 480,
	top: isiPad ? 144 : 0,
	left: isiPad ? 142 : 0
});
win.add(backgroundImage);

var noteButtons = [];

noteDatabase.notes.map( function(note) {
	if (isiPad) {
		note.rect = note.rect.map( function (x) {
			return x * 1.5;
		});
	}

	var noteController = createNoteController(note.name, note.file, note.pitch, note.loop, note.rect)
	if (note.name.indexOf("#") >= 0) {
		// Since sharps appear on top of other notes, they have to be first
		noteButtons.unshift(noteController);
	} else {
		noteButtons.push(noteController);
	}
});

function findNoteIndex(x, y) {
	for (var i = 0; i < noteButtons.length; i++) {
		var r = noteButtons[i].rect;
		if ((r[0] <= x) && (r[1] <= y) && (r[0] + r[2] >= x) && (r[1] + r[3] >= y) ) {
			return i;
		}
	}
	return null;
}

var lastNoteIndex = null;

function windowTouchStart(e) {
	var noteIndex = findNoteIndex(e.x, e.y);
	if (noteIndex !== lastNoteIndex) {
		if (lastNoteIndex !== null) {
			noteButtons[lastNoteIndex].stop();
		}
		if (noteIndex !== null) {
			noteButtons[noteIndex].play();
		}
		lastNoteIndex = noteIndex;
	}
}

function windowTouchEnd(e) {
	if (lastNoteIndex !== null) {
		noteButtons[lastNoteIndex].stop();
	}
	lastNoteIndex = null;
}

win.addEventListener("touchstart", windowTouchStart);
win.addEventListener("touchmove", windowTouchStart);
win.addEventListener("touchcancel", windowTouchEnd);
win.addEventListener("touchend", windowTouchEnd);

/*** REVERB Controls ***/
var reverbLabel = Ti.UI.createLabel({
    text: "REVERB",
    color: 'white',
    bottom: 76,
    right: 10,
    width: 60,
    height: 'auto',
    font: {
        fontFamily:'Helvetica Neue',
        fontSize:12
    }
});
win.add(reverbLabel);

var reverbSwitch = Ti.UI.createSwitch({
    value: false,
    right: 8,
    bottom: 44
});
reverbSwitch.addEventListener("change", function(event) {
    ZLSound.reverb.enabled = reverbSwitch.value;
});
win.add(reverbSwitch);

var reverbConfigButton = Ti.UI.createButton({
    title: "Config",
    width: 80,
    height: 26,
    right: 8,
    bottom: 12
});
reverbConfigButton.addEventListener("click", function(event) {
    alert("TODO"); // TODO
});
win.add(reverbConfigButton);

/*** iPAD Customizations ***/

if (isiPad) {
	var footer = Ti.UI.createLabel({
		text: "Copyright (c) 2011, Uri Shaked",
		color: 'white',
		bottom: 10,
		left: 10,
		height: 'auto',
		font: {
			fontFamily:'Helvetica Neue',
			fontSize:16
		}
	});
	win.add(footer);
}

win.open({
	transition:Titanium.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT
});
