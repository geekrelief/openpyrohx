package com.cimians.openPyro.managers.events;

	import flash.display.DisplayObject;
	import flash.events.Event;
	
	class DragEvent extends Event {
		
		public static var DRAG_COMPLETE:String = "dragComplete";
		
		public var stageX:Float;
		public var stageY:Float;
		public var dragInitiator:DisplayObject;
		public var mouseYDelta:Float;
		public var mouseXDelta:Float;
		
		public function new(type:String)
		{
			super(type);
		}

	}
