package com.cimians.openPyro.controls.skins;

	import com.cimians.openPyro.skins.ISkin;
	
	interface ISliderSkin implements ISkin{
		function trackSkin():ISkin;
		function thumbSkin():ISkin;
	}
