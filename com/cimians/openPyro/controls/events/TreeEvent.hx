package com.cimians.openPyro.controls.events;

	import com.cimians.openPyro.collections.XMLNodeDescriptor;

	class TreeEvent extends ListEvent {
		
		public static var ROTATOR_CLICK:String = "rotatorClick";
		
		public var nodeDescriptor:XMLNodeDescriptor;
		
		public function new(type:String, ?bubbles:Bool=false, ?cancelable:Bool=false)
		{
			super(type);
		}
		
	}
