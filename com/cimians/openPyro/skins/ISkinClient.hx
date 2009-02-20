package com.cimians.openPyro.skins;

	interface ISkinClient
	{
        var skin(null, setSkin):ISkin;
		//function setSkin(skinImpl:ISkin):ISkin;
        var styleName(getStyleName, setStyleName):String;
		//function getStyleName():String;
	}
