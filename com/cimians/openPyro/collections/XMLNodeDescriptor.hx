package com.cimians.openPyro.collections;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	class XMLNodeDescriptor extends EventDispatcher {
		
		public var nodeString(getNodeString, null) : String;
		public var open(getOpen, setOpen) : Bool;
		public var node:XML;
		public var depth:Int;
		
		public var parent:XMLNodeDescriptor;
		
		public static var BRANCH_VISIBILITY_CHANGED:String = "branchVisibilityChanged"
		
		public function new()
		{
		}
		
		var _open:Bool ;
		
		public function setOpen(b:Bool):Bool{
			_open = b;
			dispatchEvent(new Event(BRANCH_VISIBILITY_CHANGED))
			return b;
		}
		
		public function getOpen():Bool{
			return _open
		}
		
		public function isLeaf():Bool{
			if(!node) return false;
			if (node.children().length() > 0){
				return false
			}
			return true;
		}
		
		public function getNodeString():String{
			return node.toXMLString();
		}

	}
