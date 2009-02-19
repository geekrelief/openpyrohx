package com.cimians.openPyro.painters;

	import com.cimians.openPyro.core.Padding;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	class StripesPainter implements IPainter {
		
		public var padding(getPadding, setPadding) : Padding
		;
		var _padding:Padding;
		var _stripeWidth:Float;
		
		public function new(?stripeWidth:Int=10){
			_stripeWidth = stripeWidth;		
		}
		
		public function draw(gr:Graphics, w:Float, h:Float):Void
		{
			var bdata:BitmapData = new BitmapData(2*_stripeWidth,2*_stripeWidth, true);
			var rect1:Rectangle = new Rectangle(0,0,_stripeWidth,2*_stripeWidth);
			var rect2:Rectangle = new Rectangle(_stripeWidth,0,_stripeWidth,2*_stripeWidth);
			
			//Create 2 black rectangles: one semitransparent and other invisible 
			bdata.fillRect(rect1, 0x00000000);
			bdata.fillRect(rect2, 0x10000000);
			
			//Create the skew-matrix
			var m:Matrix = new Matrix();
			m.c=-1;
			
			//Fill the MovieClip with the BitmapData.
			gr.beginBitmapFill(bdata, m)
			gr.drawRect(0,0,w,h);
			gr.endFill();
		}
		
		public function toString():String{
			return ("stripeWidth: "+_stripeWidth)
		}
		
		public function setPadding(p:Padding):Padding
		{
			_padding = p
			return p;
		}
		
		public function getPadding():Padding
		{
			return _padding;
		}

	}
