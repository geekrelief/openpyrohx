package com.cimians.openPyro.painters;

	import flash.display.Graphics;
	import com.cimians.openPyro.core.Padding;
	
	interface IPainter
	{
        var padding(getPadding, setPadding):Padding;
		function draw(gr:Graphics, w:Float, h:Float):Void;
	}
