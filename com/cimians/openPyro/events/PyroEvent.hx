package com.cimians.openPyro.events;

	import flash.events.Event;
	
	class PyroEvent extends Event {
		
		public static var CREATION_COMPLETE:String = "creationComplete";
		public static var PROPERTY_CHANGE:String = "propertyChange";
		public static var SIZE_VALIDATED:String = "sizeValidated";
		public static var SCROLLBARS_CHANGED:String = "scrollBarsChanged";
		public static var UPDATE_COMPLETE:String="updateComplete";
		
		public static var ENTER:String = "enter";
		
		public function new(type:String)
		{
			super(type);
		}

	}
