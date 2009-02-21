package com.cimians.openPyro.controls.skins;

	import com.cimians.openPyro.skins.ISkin;
	
	interface ISliderSkin implements ISkin{
        var trackSkin(getTrackSkin, null):ISkin;
        var thumbSkin(getThumbSkin, null):ISkin;
	}
