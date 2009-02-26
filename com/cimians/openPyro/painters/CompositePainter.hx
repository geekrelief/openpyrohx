package com.cimians.openPyro.painters;

	import flash.display.Graphics;
	import com.cimians.openPyro.core.Padding;

	class CompositePainter implements IPainter {
		
		public var padding(getPadding, setPadding) : Padding ;

		var _padding:Padding;
		var _painters:Array<Dynamic> ;
		
		public function new()
		{
		    _painters = new Array();
		}
		
		public function setPadding(p:Padding):Padding
		{
			_padding = p;
			return p;
		}
		
		public function getPadding():Padding
		{
			return _padding;
		}
		
		public function addPainter(painter:IPainter):Void{
			_painters.push(painter);
		}

		public function draw(gr:Graphics, w:Float, h:Float):Void
		{
			for(i in 0..._painters.length)
			{
				if(_padding != null)
				{
					cast(_painters[i], IPainter).padding = _padding;
				}
				cast(_painters[i], IPainter).draw(gr,w,h);
			}
		}
		
	}
