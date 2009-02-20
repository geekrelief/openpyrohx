package com.cimians.openPyro.painters;

	import com.cimians.openPyro.core.Padding;
	
	import flash.display.Graphics;
	
	class FillPainter implements IPainter {
		
		public var cornerRadius(null, setCornerRadius) : Float;
		public var padding(getPadding, setPadding) : Padding ;
		var _color:UInt;
		var _alpha:Float;
		var _stroke:Stroke;
		var _padding:Padding;
		var _cornerRadius:Float;
		
		public function new(color:UInt, ?alpha:Float=1, ?stroke:Stroke=null, ?cornerRadius:Float=0){
			_color = color;
			_alpha = alpha;
			_stroke = stroke;
			_cornerRadius = cornerRadius;	
		}
		
		public function setCornerRadius(r:Float):Float{
			_cornerRadius = r;
			return r;
		}
		
		public function draw(gr:Graphics, w:Float, h:Float):Void
		{
			var drawX:Float = 0;
			var drawY:Float = 0;
			var drawW:Float = w;
			var drawH:Float = h;
			
			if(_padding != null){
				drawX += _padding.left;
				drawY += _padding.top;
				drawW -= _padding.right + _padding.left;
				drawH -= padding.top + _padding.bottom;
			}

			if(_stroke != null){
				gr.lineStyle(_stroke.thickness, 
							_stroke.color, 
							_stroke.alpha, 
							_stroke.pixelHinting, 
							_stroke.scaleMode, 
							_stroke.caps,
							_stroke.joints,
							_stroke.miterLimit);
			}
			gr.beginFill(_color,_alpha);
			gr.drawRoundRect(drawX,drawY,drawW,drawH,_cornerRadius, _cornerRadius);
			gr.endFill();
		}
		
		public function toString():String{
			return ("color: "+StringTools.hex(_color, 16)+"\n stroke: "+_stroke+"\n"+_alpha);
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
