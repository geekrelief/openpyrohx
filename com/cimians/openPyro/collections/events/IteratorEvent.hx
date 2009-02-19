package com.cimians.openPyro.collections.events;

	import flash.events.Event;

	class IteratorEvent extends Event {
		
		public static var ITERATOR_MOVED:String = "iteratorMoved";
		public static var ITERATOR_RESET:String = "iteratorReset";
		
		public function new(type:String, ?bubbles:Bool=false, ?cancelable:Bool=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
