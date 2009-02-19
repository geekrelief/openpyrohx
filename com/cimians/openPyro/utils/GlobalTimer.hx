package com.cimians.openPyro.utils;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	class GlobalTimer extends EventDispatcher {
		
		
		
		var _stage:Stage
		
		static var frameNumber:Int=0;
		
		public function new(stage:Stage)
		{
			_stage = stage
		}
		
		
		public function start():Void
		{
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		function onEnterFrame(event:Event):Void
		{
			frameNumber++;	
		}
		
		public static function getFrameNumber():Float
		{
			return frameNumber;
		}

	}
