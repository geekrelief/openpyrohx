package com.cimians.openPyro.collections;

	import com.cimians.openPyro.collections.events.CollectionEvent;
	import com.cimians.openPyro.collections.events.IteratorEvent;
	
	import flash.events.EventDispatcher;
	
	class ArrayIterator extends EventDispatcher, implements IIterator {
		
		public var cursorIndex(getCursorIndex, setCursorIndex) : Int;
		public var normalizedArray(getNormalizedArray, null) : Array<Dynamic>;
		var _array:Array<Dynamic>;
		var _collection:ICollection;
		var _cursorIndex:Int;
		
		public function new(collection:ICollection){
            super();
			_collection = collection;
			collection.addEventListener(CollectionEvent.COLLECTION_CHANGED, onCollectionChanged);
			setSource();
            _cursorIndex = -1;
		}
		
		function onCollectionChanged(event:CollectionEvent):Void{
			setSource();
		}
		
		function setSource():Void{
			_array = _collection.normalizedArray;
		}
		
        public function getCurrent():Dynamic{
			return _array[_cursorIndex];
		}
		
		
		public function hasNext():Bool{
			return _cursorIndex < (_array.length - 1);
		}
		public function getNext():Dynamic{
			_cursorIndex++;
			return _array[_cursorIndex];
		}	
		public function hasPrevious():Bool{
			return _cursorIndex > 0;
		}
		public function getPrevious():Dynamic{
			_cursorIndex--;
			return _array[_cursorIndex];
		}
		
		
		public function setCursorIndex(idx:Int):Int{
			if(_cursorIndex != idx){
				_cursorIndex = idx;
				dispatchEvent(new IteratorEvent(IteratorEvent.ITERATOR_MOVED));
			}
			return idx;
		}
		
		public function getCursorIndex():Int{
			return _cursorIndex;
		}
		
		public function getNormalizedArray():Array<Dynamic>{
			return _array;
		}
		
		public function reset():Void{
			_cursorIndex = -1;
			dispatchEvent(new IteratorEvent(IteratorEvent.ITERATOR_RESET));
		}
	}
