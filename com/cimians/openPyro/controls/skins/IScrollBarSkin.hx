package com.cimians.openPyro.controls.skins;

	import com.cimians.openPyro.skins.ISkin;
	
	interface IScrollBarSkin implements ISkin{
		function incrementButtonSkin():ISkin;
		function decrementButtonSkin():ISkin;
		function sliderSkin():ISliderSkin;
			
	}
