package com.cimians.openPyro.controls.events;

	import flash.events.Event;
	
	class ListEvent extends Event {
		
		public static var CHANGE:String = "change";
		public static var ITEM_CLICK:String = "itemClick";
		
		public function new(type:String)
		{
			super(type);
		}
		
		public override function clone():Event
		{
			var listEvent:ListEvent =  new ListEvent(this.type);
			return listEvent;
		}
	}
