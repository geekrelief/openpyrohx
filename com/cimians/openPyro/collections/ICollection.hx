package com.cimians.openPyro.collections;

	import flash.events.IEventDispatcher;
	
	interface ICollection implements IEventDispatcher{
		function length():Int;
		function normalizedArray():Array<Dynamic>;
		function iterator():IIterator;
		function filterFunction(f:Dynamic):Void
		function refresh():Void;
		
		/**
		 * The dataToIndex function returns the index
		 * of the data as it appears witin the ICollection's
		 * source after all filters have been applied
		 */ 
		function getItemIndex(data:Dynamic):Int;
		//function removeItem(data:Object):void;
	}
