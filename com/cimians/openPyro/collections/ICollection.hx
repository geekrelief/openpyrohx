package com.cimians.openPyro.collections;

	import flash.events.IEventDispatcher;
	
	interface ICollection implements IEventDispatcher{
		var length(getLength, null):Int;
		var normalizedArray(getNormalizedArray, null):Array<Dynamic>;
		var iterator(getIterator, null):IIterator;
		var filterFunction(null, setFilterFunction):Dynamic;
		function refresh():Void;
		
		/**
		 * The dataToIndex function returns the index
		 * of the data as it appears witin the ICollection's
		 * source after all filters have been applied
		 */ 
		function getItemIndex(data:Dynamic):Int;
		//function removeItem(data:Object):void;
	}
