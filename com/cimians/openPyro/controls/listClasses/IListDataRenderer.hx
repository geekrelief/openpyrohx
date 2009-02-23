package com.cimians.openPyro.controls.listClasses;

	import com.cimians.openPyro.controls.List;
	import com.cimians.openPyro.core.IDataRenderer;
	
	interface IListDataRenderer implements IDataRenderer{
        var baseListData(null, setBaseListData):BaseListData;
        var selected(getSelected, setSelected):Bool;
	}
