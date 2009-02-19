package com.cimians.openPyro.controls.listClasses;

	import com.cimians.openPyro.controls.List;
	import com.cimians.openPyro.core.IDataRenderer;
	
	interface IListDataRenderer implements IDataRenderer{
		function baseListData(data:BaseListData):Void;
		function selected(b:Bool):Void;
		function selected():Bool;
		
	}
