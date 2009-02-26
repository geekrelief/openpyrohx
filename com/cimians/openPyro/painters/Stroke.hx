package com.cimians.openPyro.painters;

	import flash.display.Graphics;
	
	class Stroke
	 {
		
		public var thickness:Float ; 
		public var color:UInt ;
		public var alpha:Float ;
		public var pixelHinting:Bool ;
		public var scaleMode:flash.display.LineScaleMode ;
		public var caps:flash.display.CapsStyle ;
		public var joints:flash.display.JointStyle ;
		public var miterLimit:Int;

        public function new(?thickness:Float=1, ?color:UInt=0x000000,?alpha:Float = 1, ?pixelHinting:Bool=false)
		{
			scaleMode = flash.display.LineScaleMode.NORMAL;
			caps = flash.display.CapsStyle.ROUND;
			joints = flash.display.JointStyle.ROUND;
			miterLimit = 3;

			this.thickness = thickness;
			this.color = color;
			this.alpha = alpha;
			this.pixelHinting = pixelHinting;
		}
		
		public function apply(gr:Graphics):Void
		{
			gr.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);	
		}
	}
