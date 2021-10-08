#!/bin/bash
 
#Checks if path arg was given

if	[[ $1 == "" ]];
then
	echo "you must run this with a path argument
	EX:FF-startpage /path/to/startpage.html"

fi

#Delete files in case they were already created

sudo rm /usr/lib/firefox/defaults/pref/channel-prefs.js 

sudo rm /usr/lib/firefox/mozilla.cfg

#Actually write data to the files

sudo echo '

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
//
// This pref is in its own file for complex reasons. See the comment in
// browser/app/Makefile.in, bug 756325, and bug 1431342 for details. Do not add
// other prefs to this file.

pref("app.update.channel", "release");
//
pref("general.config.filename", "mozilla.cfg");
pref("general.config.obscure_value", 0);
pref("general.config.sandbox_enabled", false);' >> /usr/lib/firefox/defaults/pref/channel-prefs.js

sudo echo '//
var {classes:Cc,interfaces:Ci,utils:Cu} = Components;
try {

 Cu.import("resource:///modules/AboutNewTab.jsm");
 var newTabURL = "file://'"$1"'";
 AboutNewTab.newTabURL = newTabURL;

} catch(e){Cu.reportError(e);} // report errors in the Browser Console

// Optional: Don't place the caret in the location bar. Useful if you want a page's search box to have focus instead.
function SetFocusOnPage () {

 setTimeout(function() {
 gBrowser.selectedBrowser.focus();
 }, 0);

}
gBrowser.tabContainer.addEventListener("TabOpen", SetFocusOnPage, false);' >> /usr/lib/firefox/mozilla.cfg


