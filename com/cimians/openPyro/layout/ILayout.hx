package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.UIContainer;
	
	interface ILayout
	{
		function initX(n:Float):Void
		function initY(n:Float):Void;
		function container(c:UIContainer):Void
		function layout(children:Array<Dynamic>):Void;
		function getMaxWidth(children:Array<Dynamic>):Float;
		function getMaxHeight(children:Array<Dynamic>):Float;
		function prepare(f:Dynamic):Void;
	}
