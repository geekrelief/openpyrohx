package com.cimians.openPyro.painters;

	import flash.display.Graphics;
	import com.cimians.openPyro.core.Padding;
	
	interface IPainter
	{
		function padding(p:Padding):Void;
		function padding():Padding;
		function draw(gr:Graphics, w:Float, h:Float):Void;
	}
