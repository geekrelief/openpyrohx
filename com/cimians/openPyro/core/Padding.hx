package com.cimians.openPyro.core;

	class Padding
	 {
		
		
		
		public var bottom(getBottom, null) : Float ;
		public var left(getLeft, null) : Float ;
		public var right(getRight, null) : Float ;
		public var top(getTop, null) : Float ;
		
		var _top:Float;
		var _right:Float;
		var _bottom:Float;
		var _left:Float;
		
		public function new(?top:Float=0, ?right:Float=0, ?bottom:Float=0, ?left:Float=0)
		{
			_top = top;
			_right = right;
			_bottom = bottom;
			_left = left;
		}
		
		public function getTop():Float
		{
			return _top;
		}
		
		public function getRight():Float
		{
			return _right;
		}
		
		public function getLeft():Float
		{
			return _left;
		}
		
		public function getBottom():Float
		{
			return _bottom;	
		}

	}
