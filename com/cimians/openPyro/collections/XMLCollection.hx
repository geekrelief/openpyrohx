package com.cimians.openPyro.collections;

	import com.cimians.openPyro.collections.events.CollectionEvent;
	import com.cimians.openPyro.collections.events.CollectionEventKind;
	import com.cimians.openPyro.utils.ArrayUtil;
	import com.cimians.openPyro.utils.XMLUtil;
	
	import flash.events.EventDispatcher;
	
	class XMLCollection extends EventDispatcher, implements ICollection {
		
		public var filterFunction(null, setFilterFunction) : Dynamic;
		public var iterator(getIterator, null) : IIterator
		;
		public var length(getLength, null) : Int
		;
		public var normalizedArray(getNormalizedArray, null) : Array<Dynamic>;
		public var source(getSource, setSource) : Dynamic;
		var _xml:XML;
		var _normalizedArray:Array<Dynamic>;
		var _unfilteredNormalizedArray:Array<Dynamic>;
		var _originalNormalizedArray:Array<Dynamic>;
		var _iterator:ArrayIterator;
		
		public function new(?xml:XML=null)
		{
			_xml = xml;
			_normalizedArray = new Array();
			parseNode(_xml, 0, null);
			_originalNormalizedArray = _normalizedArray.concat();
			_unfilteredNormalizedArray = _normalizedArray.concat();
			_iterator = new ArrayIterator(this);
		}
		
		
		function parseNode(node:XML, depth:Int, parentNodeDescriptor:XMLNodeDescriptor):Void{
			
			var desc:XMLNodeDescriptor = new XMLNodeDescriptor()
			desc.node = node
			desc.depth = depth
			desc.parent = parentNodeDescriptor;
			_normalizedArray.push(desc);
			depth++;
			for(i in 0...node.children().length()){
				parseNode(node.children()[i], depth, desc);
			}
		}
		
		public function getSource():Dynamic{
			return _xml;
		}
		
		public function setSource(x:Dynamic):Dynamic{
			_xml = x;
			_normalizedArray = new Array();
			parseNode(_xml, 0, null);
			_unfilteredNormalizedArray = _normalizedArray.concat();
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGED));
			return x;
		}
		
		public function getNormalizedArray():Array<Dynamic>{
			return _normalizedArray;
		}
		
		public function getLength():Int
		{
			return _xml.length();
		}
		
		public function getIterator():IIterator
		{
			return _iterator;
		}
		
		public function getItemIndex(item:Dynamic):Int{
			return _normalizedArray.indexOf(item);
		}
		
		public function getOpenChildNodes(item:XMLNodeDescriptor):Array<Dynamic>{
			var allChildNodes:Array<Dynamic> = getChildNodes(item);
			var visibleChildNodes:Array<Dynamic> = new Array()
			while(allChildNodes.length > 0){
				var newNode:XMLNodeDescriptor = allChildNodes.shift();
				visibleChildNodes.push(newNode);
				if(!newNode.isLeaf() && !newNode.open){
					var closedNodeChildren:Array<Dynamic> = getChildNodes(newNode);
					for(i in 0...closedNodeChildren.length){
						if(allChildNodes.indexOf(closedNodeChildren[i]) != -1){
							ArrayUtil.remove(allChildNodes, closedNodeChildren[i]);
						}
					}
				}
			}
			return visibleChildNodes;
		}
		
		/**
		 * Returns all children under a given node in the original
		 * XML.
		 */ 	
		public function getChildNodes(item:XMLNodeDescriptor):Array<Dynamic>{
			
			var idx:Float = _unfilteredNormalizedArray.indexOf(item);
			var foundAllChildren:Bool = false;
			var childNodesArray:Array<Dynamic> = new Array();
			while(!foundAllChildren){
				idx++;
				if(idx == this._unfilteredNormalizedArray.length){
					foundAllChildren = true;
					break;
				}
				else{
					var newNode:XMLNodeDescriptor = cast( getItemInUnfilteredAt(idx), XMLNodeDescriptor);
					if(XMLUtil.isItemParentOf(item.node, newNode.node)){
						childNodesArray.push(newNode);
					}
					else{
						foundAllChildren=true;
					}
				}
			}
			return childNodesArray;
		}
		
		
		public function getItemInUnfilteredAt(idx:Int):Dynamic{
			return _unfilteredNormalizedArray[idx];
		}
		public function getItemAt(idx:Int):Dynamic{
			return _normalizedArray[idx];
		}
		
		public function removeItems(items:Array<Dynamic>):Void{
			for(i in 0...items.length){
				ArrayUtil.remove(_normalizedArray,items[i])	
			}
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.delta = items;
			collectionEvent.kind = CollectionEventKind.REMOVE;
			dispatchEvent(collectionEvent);
		}
		
		public function addItems(items:Array<Dynamic>, parentNode:XMLNodeDescriptor):Void{
			var nodeIndex:Int = _normalizedArray.indexOf(parentNode);
			ArrayUtil.insertArrayAtIndex(_normalizedArray,items, (nodeIndex+1));
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.delta = items;
			collectionEvent.eventNode = parentNode; 
			collectionEvent.kind = CollectionEventKind.ADD;
			dispatchEvent(collectionEvent);	
		}
		
		var _filterFunction:Dynamic;
		
		public function setFilterFunction(f:Dynamic):Dynamic{
			this._filterFunction = f;
			return f;
		}
		
		public function refresh():Void{
			_normalizedArray = _originalNormalizedArray.filter(_filterFunction);
			_unfilteredNormalizedArray = _normalizedArray.concat();
			
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.kind = CollectionEventKind.RESET;
			dispatchEvent(collectionEvent);
			
			/*for(var i:int=0; i<_normalizedArray.length; i++){
				if(newNormalizedArray.indexOf(_normalizedArray[i])==-1){
					items.push(_normalizedArray[i]);
				}
			}
			collectionEvent.delta = items;
			_normalizedArray = newNormalizedArray;
			_unfilteredNormalizedArray = _normalizedArray.concat();
			collectionEvent.kind = CollectionEventKind.REMOVE;
			dispatchEvent(collectionEvent);
			*/
		}
		
	}
