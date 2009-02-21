package com.cimians.openPyro.controls.events;

	import flash.events.Event;

	class ScrollEvent extends Event {
		
		public static var SCROLL:String = "scroll";
		public static var CHANGE:String = "change";
		
		public var direction:String;
		public var delta:Float;
		public var value:Float;
		
		public function new(type:String, ?bubbles:Bool=false, ?cancelable:Bool=false)
		{
			super(type, bubbles, cancelable);
		}
	}
