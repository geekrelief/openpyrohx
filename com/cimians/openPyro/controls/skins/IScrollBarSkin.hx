package com.cimians.openPyro.controls.skins;

	import com.cimians.openPyro.skins.ISkin;
	
	interface IScrollBarSkin implements ISkin{
        var incrementButtonSkin(getIncrementButtonSkin, null):ISkin;
        var decrementButtonSkin(getDecrementButtonSkin, null):ISkin;
        var sliderSkin(getSliderSkin, null):ISliderSkin;
	}
