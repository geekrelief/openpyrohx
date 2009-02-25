package com.cimians.openPyro.controls;

	//import flash.events.FullScreenEvent;
	
	class Text extends Label {
		
		public function new()
		{
			super();
			//_textField.border = true
		}
		
		override function setTextFieldProperties():Void{
			_textField.autoSize =  flash.text.TextFieldAutoSize.LEFT;
			_textField.wordWrap = true;
		}
	}
