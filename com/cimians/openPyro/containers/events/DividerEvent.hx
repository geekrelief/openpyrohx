package com.cimians.openPyro.containers.events;

	import flash.display.DisplayObject;
	import flash.events.Event;

	class DividerEvent extends Event {
		
		
		
		public static var DIVIDER_DOUBLE_CLICK:String = "dividerDoubleClick";
		public static var DIVIDER_CLICK:String = "dividerClick";
		
		public var divider:DisplayObject;
		public var dividerIndex:Float;
		
		public function new(type:String, ?bubbles:Bool=false, ?cancelable:Bool=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
