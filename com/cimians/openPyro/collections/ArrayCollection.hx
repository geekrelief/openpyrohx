package com.cimians.openPyro.collections;

	import com.cimians.openPyro.collections.events.CollectionEvent;
	
	import flash.events.EventDispatcher;
	
	class ArrayCollection extends EventDispatcher, implements ICollection {
		
		public var filterFunction(null, setFilterFunction) : Dynamic;
		public var iterator(getIterator, null) : IIterator
		;
		public var length(getLength, null) : Int
		;
		public var normalizedArray(getNormalizedArray, null) : Array<Dynamic>;
		public var source(getSource, setSource) : Dynamic
		;
		var _originalSource:Array<Dynamic>;
		
		public function new(?source:Array<Dynamic> = null)
		{
			_source = source;
			_originalSource = source;
			_iterator = new ArrayIterator(this);
		}
		
		var _source:Array<Dynamic>;
		var _iterator:ArrayIterator;
		
		public function setSource(array:Dynamic):Dynamic
		{
			_source = array;
			_originalSource = array;
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGED));
			return array;
		}
		
		public function getSource():Dynamic
		{
			return _source;	
		}
		
		public function getNormalizedArray():Array<Dynamic>{
			return _source;
		}
		
		public function getLength():Int
		{
			if(_source){
				return _source.length;
			}
			return 0;
		}
		
		public function getIterator():IIterator
		{
			return _iterator;
		}
		
		public function getItemIndex(ob:Dynamic):Int
		{
			return _source.indexOf(ob);
		}
		
		public function removeItems(items:Array<Dynamic>):Void{
			
		}
		
		public function setFilterFunction(f:Dynamic):Dynamic{
			
			return f;
			
	}
		
		public function refresh():Void{
		
		}
		
	}
