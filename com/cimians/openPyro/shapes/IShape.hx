package com.cimians.openPyro.shapes;

	interface IShape
	{
		var mheight(getHeight, setHeight):Float;
		var mwidth(getWidth, setWidth):Float;
		function drawShape():Void;
	}
