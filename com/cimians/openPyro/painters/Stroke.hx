package com.cimians.openPyro.painters;

	import flash.display.Graphics;
	
	class Stroke
	 {
		
		public var thickness:Float ; 
		public var color:UInt ;
		public var alpha:Float ;
		public var pixelHinting:Bool ;
		public var scaleMode:String ;
		public var caps:String ;
		public var joints:String ;
		public var miterLimit:Int public function new(?thickness:Int=1, ?color:UInt=0x000000,?alpha:Int = 1, ?pixelHinting:Bool=false)
		{
			
			thickness = NaN;
			color = 0;
			alpha = 1.0;
			pixelHinting = false;
			scaleMode = "normal";
			caps = null;
			joints = null;
			miterLimit = 3
		
		;
			this.thickness = thickness;
			this.color = color;
			this.alpha = alpha;
			this.pixelHinting = pixelHinting;
		}
		
		public function apply(gr:Graphics):Void
		{
			gr.lineStyle(thickness, color, alpha, pixelHinting,
					scaleMode, caps, joints, miterLimit);	
		}
	}
