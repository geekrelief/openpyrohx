package com.cimians.openPyro.controls.skins;

	import com.cimians.openPyro.skins.ISkin;
	
	interface IComboBoxSkin implements ISkin{
		function buttonSkin():ISkin;
		function listSkin():ISkin;
	}
