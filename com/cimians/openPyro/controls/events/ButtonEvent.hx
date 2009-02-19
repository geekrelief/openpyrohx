package com.cimians.openPyro.controls.events;

	import flash.events.Event;
	
	class ButtonEvent extends Event {
		
		public static var UP:String = "up";
		public static var OVER:String = "over";
		public static var DOWN:String = "down";
		
		public function new(type:String)
		{
			super(type)
		}
	}
