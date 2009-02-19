package com.cimians.openPyro.skins;
	import com.cimians.openPyro.core.UIControl;
	
	import flash.display.IBitmapDrawable;
	
	interface ISkin implements IBitmapDrawable{
		
		//function get selector():String;
		
		function skinnedControl(uic:UIControl):Void;
		function dispose():Void;
		
	}
