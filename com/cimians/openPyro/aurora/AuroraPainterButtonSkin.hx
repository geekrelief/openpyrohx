package com.cimians.openPyro.aurora;

	import com.cimians.openPyro.controls.Button;
	import com.cimians.openPyro.controls.Label;
	import com.cimians.openPyro.controls.events.ButtonEvent;
	import com.cimians.openPyro.core.IStateFulClient;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.events.PyroEvent;
	import com.cimians.openPyro.painters.IPainter;
	import com.cimians.openPyro.painters.Stroke;
	
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	class AuroraPainterButtonSkin extends UIControl, implements IStateFulClient {
		
		
		
		public var icon(null, setIcon) : DisplayObject;
		public var labelAlign(null, setLabelAlign) : String; 
		public var labelFormat(getLabelFormat, setLabelFormat) : TextFormat ;
		public var painters(null, setPainters) : IPainter;
		public var skinnedControl(null, setSkinnedControl) : UIControl;
		
		public function new()
		{
			this.mouseChildren=false;
		}
		
		public override function setSkinnedControl(uic:UIControl):UIControl{
			if(_skinnedControl)
			{
				_skinnedControl.removeEventListener(PyroEvent.PROPERTY_CHANGE, onSkinnedControlPropertyChange)
			}
			super.setSkinnedControl(uic);
			_skinnedControl.addEventListener(PyroEvent.PROPERTY_CHANGE, onSkinnedControlPropertyChange)
			if(Std.is( uic, Button))
			{
				this.changeState(null, cast(uic, Button).currentState);
				updateLabel();
			}
			this.buttonMode = true;
			this.useHandCursor = true;
			
			return uic;
		}
		
		function onSkinnedControlPropertyChange(event:PyroEvent):Void
		{
			if(Std.is( _skinnedControl, Button))
			{
				updateLabel();
			}
		}
		
		/////////////////// ICON /////////////////
		
		var _icon:DisplayObject;
		public function setIcon(icn:DisplayObject):DisplayObject{
			_icon = icn;
			addChild(_icon);
			if(_skinnedControl != null){
				invalidateDisplayList();
			}
			return icn;
		}
		
		////////////////// LABEL /////////////////
		
		var _labelFormat:TextFormat ;
		
		public function setLabelFormat(fmt:TextFormat):TextFormat
		{
			_labelFormat = fmt;
			if(label != null)
			{
				label.textFormat = fmt;
			}
			if(_skinnedControl != null)
			{
				invalidateDisplayList();
			}
			return fmt;
		}
		
		public function getLabelFormat():TextFormat
		{
			return _labelFormat;
		}
		
		var label:Label;
		
		public function updateLabel():Void
		{
			if(Std.is( this._skinnedControl, Button))
			{
				var bttn:Button = Button(this._skinnedControl);
				if(bttn.label == null) return;
				if(label == null){
					label = new Label();
					label.textFormat = _labelFormat;
					addChild(label);
					
				}
				label.text = bttn.label;
			}
		}
		
		var _labelAlign:String ;
		public function setLabelAlign(direction:String):String{
			_labelAlign = direction;
			if(_skinnedControl != null){
				invalidateDisplayList();
			}
			return direction;
		}
	
		//////////// Colors ///////////////
		
		public var upPainter:IPainter;
		public var overPainter:IPainter;
		public var downPainter:IPainter;
		
		public function setPainters(painter:IPainter):IPainter{
			upPainter = overPainter = downPainter = painter;
			this.invalidateDisplayList();
			return painter;
		}
		
/*		public function set stroke(str:Stroke):void
		{
			_stroke = str;
			this.invalidateDisplayList();	
		} */
		
			
		///////////////// Button Behavior ////////
		
		public function changeState(fromState:String, toState:String):Void
		{
			if(toState==ButtonEvent.UP)
			{
				this.backgroundPainter = upPainter;
			}
			
			else if(toState==ButtonEvent.OVER)
			{
				this.backgroundPainter = overPainter;
			}
			
			else if(toState == ButtonEvent.DOWN)
			{
				this.backgroundPainter = downPainter;
			}
			else
			{
				this.backgroundPainter = upPainter;
			}
		}
		
		public override function dispose():Void
		{
			if(this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(label != null){
				
				label.textField.autoSize = "left";
				label.y = (unscaledHeight-label.mheight)/2;
				
				if(this._labelAlign == "center"){
					label.x = (unscaledWidth-label.mwidth)/2;
				}
				else if(_labelAlign == "left"){
					label.x = 10;
				}
			}
			
			if(_icon){
				if(label == null){
					_icon.x = (unscaledWidth-_icon.width)/2;
				}
				else{
					if(_labelAlign == "left"){
						_icon.x = label.x;
						label.x += _icon.width+5;
					}
					else{
						_icon.x = label.x-_icon.width-5;
					}
				}
				_icon.y = (unscaledHeight-_icon.height)/2;
			}
		}
		
	}
