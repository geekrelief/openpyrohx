package com.cimians.openPyro.collections;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	class XMLNodeDescriptor extends EventDispatcher {
		
		public static var BRANCH_VISIBILITY_CHANGED:String = "branchVisibilityChanged";

		public var nodeString(getNodeString, null) : String;
		public var open(getOpen, setOpen) : Bool;

		public var node:Xml;
		public var depth:Int;
		
		public var parent:XMLNodeDescriptor;
		
		var _open:Bool;
		
		public function new()
		{
            super();
            _open = true;
		}
		
		
		public function setOpen(b:Bool):Bool{
			_open = b;
			dispatchEvent(new Event(BRANCH_VISIBILITY_CHANGED));
			return b;
		}
		
		public function getOpen():Bool{
			return _open;
		}
		
		public function isLeaf():Bool{
			if(node == null) return false;
			return  node.elements().hasNext();
		}
		
		public function getNodeString():String{
			return Std.string(node);
		}

	}
