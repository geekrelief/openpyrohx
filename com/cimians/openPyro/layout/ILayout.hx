package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.UIContainer;
	
	interface ILayout
	{
        var initX(getInitX, setInitX):Float;
        var initY(getInitY, setInitY):Float;
        var container(null, setContainer):UIContainer;
		function layout(children:Array<Dynamic>):Void;
		function getMaxWidth(children:Array<Dynamic>):Float;
		function getMaxHeight(children:Array<Dynamic>):Float;
        var prepare(null, setPrepare):Dynamic;
	}
