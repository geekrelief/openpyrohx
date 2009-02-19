package com.cimians.openPyro.controls.events;

	import flash.events.Event;
	
	class DropDownEvent extends Event {
		
		public static var OPEN:String = "open";
		public static var CLOSE:String = "close";
		
		public function new(type:String)
		{
			super(type);
		}
	}
