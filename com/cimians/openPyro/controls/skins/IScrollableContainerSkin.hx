package com.cimians.openPyro.controls.skins;

	import com.cimians.openPyro.skins.ISkin;
	
	interface IScrollableContainerSkin implements ISkin{
		var verticalScrollBarSkin(getVerticalScrollBarSkin, null):IScrollBarSkin;
		var horizontalScrollBarSkin(getHorizontalScrollBarSkin, null):IScrollBarSkin;
	}
