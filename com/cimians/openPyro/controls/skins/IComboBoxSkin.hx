package com.cimians.openPyro.controls.skins;

	import com.cimians.openPyro.skins.ISkin;
	
	interface IComboBoxSkin implements ISkin{
		var buttonSkin(getButtonSkin, null):ISkin;
		var listSkin(getListSkin, null):ISkin;
	}
