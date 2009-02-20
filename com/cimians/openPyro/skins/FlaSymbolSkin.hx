package com.cimians.openPyro.skins;

	import com.cimians.openPyro.core.UIControl;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	class FlaSymbolSkin implements ISkin {
		
		public var movieClipClass(null, setMovieClipClass) : Class<Dynamic>;
		public var selector(getSelector, null) : String ;
		public var skinnedControl(getSkinnedControl, setSkinnedControl) : UIControl;
		
		var _skin:MovieClip;
		var _control:UIControl;
		
		public function new()
		{
			
		}
		
		public function setMovieClipClass(mcClass:Class<Dynamic>):Class<Dynamic>{
			_skin = Type.createInstance(mcClass, []);
			return mcClass;
		}
		
		public function getSelector():String
		{
			return null;
		}

        public function getSkinnedControl():UIControl {
            return _control;
        }
		
		public function setSkinnedControl(uic:UIControl):UIControl{
			_control = uic;
			_control.addChildAt(_skin, 0);
			if(_skin == null) return null;
			
			_skin.width = uic.mwidth;
			_skin.height = uic.mheight;
			_control.addEventListener(Event.RESIZE, onControlResize);
			return uic;
		}

		function onControlResize(event:Event):Void{
			_skin.width = event.target.mwidth;
			_skin.height = event.target.mheight;	
		}
		
		public function onState(fromState:String, toState:String):Void
		{
			this._skin.gotoAndPlay(toState);
		}
		
		public function dispose():Void
		{
			
		}
		
	}
