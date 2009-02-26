package com.cimians.openPyro.controls;

	import com.cimians.openPyro.events.PyroEvent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	/*[Event(name="enter", type="com.cimians.openPyro.events.PyroEvent")]*/
	/*[Event(name="change", type="flash.events.Event")]*/
	
	class TextInput extends Text {
		
		public var password(null, setPassword) : Bool;
		var _displayAsPassword:Bool ;

		public function new()
		{
			super();
            _displayAsPassword = false;
		}
		
		override function setTextFieldProperties():Void{
			//_textField.border = true;
			_textField.addEventListener(KeyboardEvent.KEY_UP, onKeyUp)
			_textField.type = TextFieldType.INPUT;
			_textField.addEventListener(Event.CHANGE, onTextInputChange);
			_textField.displayAsPassword = _displayAsPassword;
			_textField.wordWrap = true;
			_textField.multiline = false;
		}
		
		public function setPassword(b:Bool):Bool{
			_displayAsPassword = b;
			return b;
		}
		
		function onTextInputChange(event:Event):Void{
			_text = _textField.text;
			dispatchEvent(event);
		}
		
		function onKeyUp(event:KeyboardEvent):Void{
			if(event.keyCode == Keyboard.ENTER){
				dispatchEvent(new PyroEvent(PyroEvent.ENTER));
			}
		}
		
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_textField.width = mwidth;
			_textField.height = mheight;
		}
		
	}
