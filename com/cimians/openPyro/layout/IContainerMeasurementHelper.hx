package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;
	
	interface IContainerMeasurementHelper
	{
		function calculateSizes(children:Array<Dynamic>, container:UIContainer):Void;
	}
