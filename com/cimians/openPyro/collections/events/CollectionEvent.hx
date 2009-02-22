package com.cimians.openPyro.collections.events;

	import flash.events.Event;

	class CollectionEvent extends Event {
		
		public static var COLLECTION_CHANGED:String = "collectionChanged";
		
		/**
		 * The difference between the old state and the new state
		 */ 
		public var delta:Array<Dynamic>;
		
        /**
		 * 
		 */
        public var kind:String; 
		 
        /**
         * The data node around near which this event happened.
         * For example, in case of elements added to a tree the property is used 
         * to find what the parentNode of the newly added 
         * branch is.
         * 
         * Note: This is not the DisplayObject associated with the data
         */ 
        public var eventNode:Dynamic;
    
        public function new(type:String, ?bubbles:Bool=false, ?cancelable:Bool=false)
        {
            super(type, bubbles, cancelable);
        }
	}
