package com.cimians.openPyro.collections;

	import flash.events.IEventDispatcher;
	
	interface IIterator implements IEventDispatcher{
		function getCurrent():Dynamic;
		function hasNext():Bool;
		function getNext():Dynamic;
		function hasPrevious():Bool;
		function getPrevious():Dynamic;
        var cursorIndex(getCursorIndex, setCursorIndex):Int;
		function reset():Void;
	}
