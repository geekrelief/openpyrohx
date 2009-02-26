package com.cimians.openPyro.painters;

	import com.cimians.openPyro.core.Padding;
	
	import flash.display.Graphics;
	
	class StrokePainter implements IPainter {
		
		public var padding(getPadding, setPadding) : Padding ;

		var _stroke:Stroke;
		var _padding:Padding;
		
		var _top:Bool;
		var _right:Bool;
		var _bottom:Bool;
		var _left:Bool;
		
		public function new(stroke:Stroke, ?top:Bool=true, ?right:Bool=true, ?bottom:Bool=true, ?left:Bool=true ){
			_stroke = stroke;
			_top = top;
			_right = right;
			_bottom = bottom;
			_left = left;
		}
		
		public function setBorderSides( ?top:Bool=true, ?right:Bool=true, ?bottom:Bool=true, ?left:Bool=true):Void{
			_top = top;
			_right = right;
			_bottom = bottom;
			_left = left;
		}
		
		
		public function draw(gr:Graphics, w:Float, h:Float):Void
		{
			var drawX:Float = 0;
			var drawY:Float = 0;
			var drawW:Float = w;
			var drawH:Float = h;
			
			if(_padding != null)
			{
				drawX += _padding.left;
				drawY += _padding.top;
				drawW -= _padding.right + _padding.left;
				drawH -= padding.top + _padding.bottom;
			}
			
			gr.lineStyle(_stroke.thickness, 
						_stroke.color, 
						_stroke.alpha, 
						_stroke.pixelHinting, 
						_stroke.scaleMode, 
						_stroke.caps,
						_stroke.joints,
						_stroke.miterLimit);
			
			gr.moveTo(drawX, drawY);
			
			_top?gr.lineTo(drawW, drawY):gr.moveTo(drawW, drawY);
			_right?gr.lineTo(drawW, drawH):gr.moveTo(drawW, drawH);
			_bottom?gr.lineTo(drawX, drawH):gr.moveTo(drawX, drawH);
			_left?gr.lineTo(drawX, drawY):gr.moveTo(drawX, drawY);
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
