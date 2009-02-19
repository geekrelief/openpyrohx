package com.cimians.openPyro.controls.events;

	import flash.events.Event;

	class SliderEvent extends Event {
		
		public static var CHANGE:String = "change";
		public static var THUMB_PRESS:String = "thumbPress";
		public static var THUMB_DRAG:String = "thumbDrag";
		public static var THUMB_RELEASE:String = "thumbRelease";
		
		public function new(type:String, ?bubbles:Bool=false, ?cancelable:Bool=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
