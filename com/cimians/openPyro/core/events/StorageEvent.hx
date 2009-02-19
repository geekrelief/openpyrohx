package com.cimians.openPyro.core.events;
	import flash.events.Event;
	
	/**
	 * The StorageEvent is dispatched by any IStorage
	 * object when storage succeeds or fails.
	 */ 
	class StorageEvent extends Event {
		
		
		
		public function new(type:String){
			super(type);
		}
	}
