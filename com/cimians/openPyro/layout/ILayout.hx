package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.UIContainer;
	
	interface ILayout
	{
        var initX(null, setInitX):Float;
        var initY(null, setInitY):Float;
        var container(null, setContainer):UIContainer;
		function layout(children:Array<Dynamic>):Void;
		function getMaxWidth(children:Array<Dynamic>):Float;
		function getMaxHeight(children:Array<Dynamic>):Float;
        var prepare(null, setPrepare):Dynamic;
	}
