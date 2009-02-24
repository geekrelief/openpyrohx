package com.cimians.openPyro.controls;
	import com.cimians.openPyro.controls.events.ButtonEvent;
	import com.cimians.openPyro.core.IStateFulClient;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.events.PyroEvent;
	import com.cimians.openPyro.skins.ISkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/*[Event(name="up", type="com.cimians.openPyro.controls.events.ButtonEvent")]*/
	/*[Event(name="over", type="com.cimians.openPyro.controls.events.ButtonEvent")]*/
	/*[Event(name="down", type="com.cimians.openPyro.controls.events.ButtonEvent")]*/
	
	/**
	 * Dispatched when a toggleable button's state changes from selected to 
	 * deselected or vice versa. 
	 */ 
	/*[Event(name="change", type="flash.events.Event")]*/

	class Button extends UIControl {
		
		public var label(getLabel, setLabel) : String ;
		public var selected(getSelected, setSelected) : Bool; 
		public var toggle(getToggle, setToggle) : Bool; 

		var _buttonSkin:ISkin;
		
		/**
		 * Buttons by default return to their 'up' state when 
		 * the mouse moves out, but buttons can be used as elements
		 * in sliders, scrollbars etc where mouseOut should be
		 * handled differently. Having the function referenced like
		 * this lets you override the mouseOut behavior
		 * 
		 * @see	com.cimians.openPyro.controls.Slider#thumbButton 
		 */ 
		public var mouseOutHandler:Dynamic ;
		var _toggle:Bool;
		var _selected:Bool ;

		public var currentState:String;

		public function new(){
			
			mouseOutHandler = onMouseOut;
			super();
			_styleName = "Button";
            _toggle = false;
            _selected = false;
		}
		
		public override function initialize():Void{
			super.initialize();
			this.currentState = ButtonEvent.UP;
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
		}
		
		var _label:String;
		
		/**
		 * Sets the label property of the Button. How this
		 * property appears visually is upto the skin of
		 * this control
		 */ 
		public function setLabel(str:String):String
		{
			_label = str;
			dispatchEvent(new PyroEvent(PyroEvent.PROPERTY_CHANGE));
			return str;
		}
		
		public function getLabel():String
		{
			return _label;
		}
		
		public override function setSkin(skinImpl:ISkin):ISkin{
            super.setSkin(skinImpl);
			this._buttonSkin = skinImpl;
			return skinImpl;
		}
		
		/////////////// TOGGLE IMPLEMENTATION //////
		
		/**
		 * Sets whether a button is set as togglable or not.
		 * If true, the button can be set in a selected or deselected
		 * state
		 */ 
		public function setToggle(b:Bool):Bool{
			_toggle = b;
			return b;
		}
		
		/**
		 * @private
		 */ 
		public function getToggle():Bool{
			return _toggle;
		}
		
		/**
		 * Sets a button's state to selected or not. This value is
		 * ONLY set if the toggle property is set to true
		 */ 
		public function setSelected(b:Bool):Bool{
			if(_toggle){
				if(_selected != b){
					this._selected = b;
					dispatchEvent(new PyroEvent(PyroEvent.PROPERTY_CHANGE));
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			return b;
		}
		
		public function getSelected():Bool{
			return _selected;
		}
		
		//////////// States //////////////////////////
		
		
		public function changeState(fromState:String, toState:String):Void{}
		
		function onMouseOver(event:MouseEvent):Void{
			if(_buttonSkin != null && Std.is( _buttonSkin, IStateFulClient)){
				cast(this._buttonSkin, IStateFulClient).changeState(this.currentState,ButtonEvent.OVER);
			}
			this.currentState = ButtonEvent.OVER;
			dispatchEvent(new ButtonEvent(ButtonEvent.OVER));
		}
		
		function onMouseDown(event:MouseEvent):Void{
			if(_toggle){
				if(_selected){
					selected = false;
				}
				else{
					selected = true;
				}
			}
			if(_buttonSkin != null && Std.is( _buttonSkin, IStateFulClient)){
				cast(this._buttonSkin, IStateFulClient).changeState(this.currentState,ButtonEvent.DOWN);
			}
			this.currentState = ButtonEvent.DOWN;
			dispatchEvent(new ButtonEvent(ButtonEvent.DOWN));
		}
		
		function onMouseUp(event:MouseEvent):Void{
			if(_buttonSkin != null  && Std.is( _buttonSkin, IStateFulClient)){
				cast(this._buttonSkin, IStateFulClient).changeState(this.currentState, ButtonEvent.OVER);
			}
			this.currentState = ButtonEvent.UP;
			dispatchEvent(new ButtonEvent(ButtonEvent.UP));
		}
		
		function onMouseOut(event:MouseEvent):Void
		{
			if(_buttonSkin != null && Std.is( _buttonSkin, IStateFulClient)){
				cast(this._buttonSkin, IStateFulClient).changeState(this.currentState, ButtonEvent.UP);
			}
			this.currentState = ButtonEvent.UP;
			dispatchEvent(new ButtonEvent(ButtonEvent.UP));
		}
	}
