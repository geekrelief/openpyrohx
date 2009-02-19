package com.cimians.openPyro.controls;

	import flash.events.FullScreenEvent;
	
	class Text extends Label {
		
		public function new()
		{
			super();
			//_textField.border = true
		}
		
		override function setTextFieldProperties():Void{
			_textField.autoSize = "left"
			_textField.wordWrap = true;
		}
	}
