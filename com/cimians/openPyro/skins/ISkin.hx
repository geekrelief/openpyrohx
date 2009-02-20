package com.cimians.openPyro.skins;
	import com.cimians.openPyro.core.UIControl;
	
	import flash.display.IBitmapDrawable;
	
	interface ISkin implements IBitmapDrawable{
		
		//var selector(getSelector, null):String;
	    var skinnedControl(getSkinnedControl, setSkinnedControl):UIControl;	
		function dispose():Void;
		
	}
