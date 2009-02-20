package com.cimians.openPyro.painters;

	import flash.display.Graphics;
	import com.cimians.openPyro.core.Padding;
	
	interface IPainter
	{
		function setPadding(p:Padding):Padding;
		function getPadding():Padding;
		function draw(gr:Graphics, w:Float, h:Float):Void;
	}
