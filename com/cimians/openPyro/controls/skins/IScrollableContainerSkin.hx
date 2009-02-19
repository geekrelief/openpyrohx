package com.cimians.openPyro.controls.skins;

	import com.cimians.openPyro.skins.ISkin;
	
	interface IScrollableContainerSkin implements ISkin{
		function verticalScrollBarSkin():IScrollBarSkin;
		function horizontalScrollBarSkin():IScrollBarSkin;
	}
