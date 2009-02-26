package com.cimians.openPyro.painters;

	import com.cimians.openPyro.core.Direction;
	import com.cimians.openPyro.core.Padding;
	
	import flash.display.Graphics;
	
	class TrianglePainter implements IPainter {
		
		public var padding(getPadding, setPadding) : Padding;
		var _fillColor:UInt ;
		var _fillAlpha:Float ;
		var _stroke:Stroke;
		var _padding:Padding;
		var _direction:String;
		var _w:Float;
		var _h:Float;
		
		public static var CENTERED:String = "centered";
		
		var graphics:Graphics;
		
		public function new(?direction:String){
            if(direction == null){
                direction = Direction.UP;
            }
			_fillColor = 0;
			_fillAlpha = 1;
			_direction = direction;	
		}
		
		public function setFill(color:UInt, ?alpha:Float=1, ?stroke:Stroke=null):Void{
			_fillColor = color;
			_fillAlpha = alpha;
			_stroke = stroke;	
		}
		
		public function setStroke(thickness:Float, ?color:UInt=0x000000, ?alpha:Float=1, ?pixelHinting:Bool=true):Void{
			_stroke = new Stroke(thickness, color, alpha, pixelHinting);
		}
		
		public function draw(gr:Graphics, w:Float, h:Float):Void
		{
			graphics = gr;
			_w = w;
			_h = h;
			gr.clear();
			if(_stroke != null){
				_stroke.apply(gr);
			}
			gr.beginFill(_fillColor, _fillAlpha);
			
			switch (_direction){
				case Direction.UP:		
                    drawUpArrow();
				case Direction.DOWN:	
                    drawDownArrow();
				case Direction.LEFT:	
                    drawLeftArrow();
				case Direction.RIGHT:	
                    drawRightArrow();
				case CENTERED:			
                    drawCenteredArrow();
			}
			gr.endFill();
		}
		
		function drawDownArrow():Void
		{
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(Math.floor(_w/2), _h);
			this.graphics.lineTo(_w, 0);
			this.graphics.lineTo(0, 0);
		}
		
		
		function drawLeftArrow():Void
		{					
			_w = Math.round(_w);
			this.graphics.moveTo(_w,0);
			this.graphics.lineTo(_w, _h);
			this.graphics.lineTo(0, Math.round(_h/2));
			this.graphics.lineTo(_w, 0);
		
		}
		
		function drawRightArrow():Void
		{			
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(_w, _h/2);
			this.graphics.lineTo(0, _h);
			this.graphics.lineTo(0, 0);
		}
		
		function drawUpArrow():Void
		{			
			this.graphics.moveTo(0,_h);
			this.graphics.lineTo(_w/2, 0);
			this.graphics.lineTo(_w, _h);
			this.graphics.lineTo( 0, _h);
		}
		
		function drawCenteredArrow():Void{
			this.graphics.moveTo(-_w/2,-_h/2);
			this.graphics.lineTo(_w/2, 0);
			this.graphics.lineTo(-_w/2, _h/2);
			this.graphics.lineTo(-_w/2, -_h/2);
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

	}
