package com.cimians.openPyro.skins;

	import com.cimians.openPyro.core.UIControl;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	class FlaSymbolSkin implements ISkin {
		
		
		
		public var movieClipClass(null, setMovieClipClass) : Class<Dynamic>;
		
		public var selector(getSelector, null) : String
		;
		
		public var skinnedControl(null, setSkinnedControl) : UIControl;
		
		var _skin:MovieClip
		var _control:UIControl;
		
		public function new()
		{
			
		}
		
		public function setMovieClipClass(mcClass:Class<Dynamic>):Class<Dynamic>{
			_skin = new mcClass();
			return mcClass;
		}
		
		public function getSelector():String
		{
			return null;
		}
		
		public function setSkinnedControl(uic:UIControl):UIControl{
			_control = uic;
			_control.addChildAt(_skin, 0);
			if(!_skin) return;
			
			_skin.width = uic.width
			_skin.height = uic.height;
			_control.addEventListener(Event.RESIZE, onControlResize)
			return uic;
		}
		
		function onControlResize(event:Event):Void{
			_skin.width = event.target.width
			_skin.height = event.target.height;	
		}
		
		public function onState(fromState:String, toState:String):Void
		{
			this._skin.gotoAndPlay(toState)
		}
		
		public function dispose():Void
		{
			
		}
		
	}
