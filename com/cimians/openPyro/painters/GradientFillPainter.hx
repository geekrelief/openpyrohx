package com.cimians.openPyro.painters;

	import com.cimians.openPyro.core.Padding;
	
	import flash.display.Graphics;
	import flash.geom.Matrix;
    import flash.display.GradientType;
	
	class GradientFillPainter implements IPainter {
		
		public var colors(null, setColors) : Array<UInt>;
		public var cornerRadius(null, setCornerRadius) : Float;
		public var padding(getPadding, setPadding) : Padding ;
		public var rotation(null, setRotation) : Float;
		public var stroke(null, setStroke) : Stroke;
		var _colors:Array<UInt>;
		var _alphas:Array<Float>;
		var _ratios:Array<Dynamic>;
		var _type:GradientType;
		var _rotation:Float ;
		var _padding:Padding;
		var _stroke:Stroke;
		var _cornerRadius:Float;

        public function new(colors:Array<UInt>, ?alphas:Array<Float>=null, ?ratios:Array<Dynamic>=null, ?rotation:Float=0, ?cornerRadius:Float=0)
		{
			_type = GradientType.LINEAR;
			_colors = colors;
			_alphas = alphas;
			_ratios = ratios;
			_rotation = rotation;
			_cornerRadius = cornerRadius;
			if(_alphas == null){
				_alphas = new Array();
				for(i in 0..._colors.length){
					_alphas.push(1.0);	
				}
			}
			
			if(_ratios == null){
				_ratios = new Array();
				for(j in 0..._colors.length){
					_ratios.push(j*255/_colors.length);	
				}
				_ratios[0] = 0;
				_ratios[_ratios.length-1]=255;
			}	
		}
		
		public function setRotation(r:Float):Float{
			_rotation = r;	
			return r;
		}
		
		public function setStroke(str:Stroke):Stroke{
			_stroke = str;
			return str;
		}
		
		public function setCornerRadius(val:Float):Float{
			_cornerRadius = val;	
			return val;
		}
		
		public function setColors(clrs:Array<UInt>):Array<UInt>{
			_colors = clrs;
			return clrs;
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
			
			if(_stroke != null)
			{
				_stroke.apply(gr);
			}
			
			var m:Matrix = new Matrix();
			m.createGradientBox(w,h,_rotation);
			gr.beginGradientFill(_type,_colors,_alphas,_ratios,m);
			gr.drawRoundRect(drawX,drawY,drawW,drawH, _cornerRadius,_cornerRadius);
			gr.endFill();
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
