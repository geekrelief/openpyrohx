package com.cimians.openPyro.skins;

	interface ISkinClient
	{
		function skin(skinImpl:ISkin):Void;
		function styleName():String;
	}
