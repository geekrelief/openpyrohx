package com.cimians.openPyro.aurora;

	import com.cimians.openPyro.controls.Button;
	import com.cimians.openPyro.controls.Label;
	import com.cimians.openPyro.controls.events.ButtonEvent;
	import com.cimians.openPyro.core.IStateFulClient;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.events.PyroEvent;
	import com.cimians.openPyro.painters.GradientFillPainter;
	import com.cimians.openPyro.painters.Stroke;
	
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	class AuroraButtonSkin extends UIControl, implements IStateFulClient {
		
		public var colors(null, setColors) : Array<UInt>;
		public var cornerRadius(null, setCornerRadius) : Float;
		public var downColors(null, setDownColors) : Array<UInt>;
		public var icon(null, setIcon) : DisplayObject;
		public var labelAlign(null, setLabelAlign) : String;
		public var labelFormat(getLabelFormat, setLabelFormat) : TextFormat ;
		public var overColors(null, setOverColors) : Array<UInt>;
		public var stroke(null, setStroke) : Stroke;
		public var upColors(null, setUpColors) : Array<UInt>;

		var _cornerRadius:Float;
        var gradientPainter:GradientFillPainter;
		var _stroke:Stroke ;
		
		var _labelFormat:TextFormat ;

		var _labelAlign:String ;

		var _upColors:Array<UInt> ;
		var _overColors:Array<UInt> ;
		var _downColors:Array<UInt> ;
	
		var label:Label;

		public function new()
		{
            super();
			_cornerRadius = 0 ;
			_stroke = new Stroke(1,0x777777,1,true);
			this.mouseChildren=false;
            _labelFormat = new TextFormat("Arial", 11, 0x111111, true);
            _labelAlign = "center";

            _upColors = [0xdfdfdf, 0xffffff];
            _overColors = [0xffffff, 0xdfdfdf];
            _downColors = [0xdfdfdf, 0xdfdfdf];
		}
		
		public override function setSkinnedControl(uic:UIControl):UIControl{
			if(_skinnedControl != null)
			{
				_skinnedControl.removeEventListener(PyroEvent.PROPERTY_CHANGE, onSkinnedControlPropertyChange);
			}

			super.setSkinnedControl(uic);
			_skinnedControl.addEventListener(PyroEvent.PROPERTY_CHANGE, onSkinnedControlPropertyChange);
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
		
		
		public function updateLabel():Void
		{
			if(Std.is( this._skinnedControl, Button))
			{
				var bttn:Button = cast(this._skinnedControl, Button);
				if(bttn.label == null) return;
				if(label == null){
					label = new Label();
					label.textFormat = _labelFormat;
				    label.text = bttn.label;
					addChild(label);
				} else {
				    label.text = bttn.label;
                }
			}
		}
		
		public function setLabelAlign(direction:String):String{
			_labelAlign = direction;
			if(_skinnedControl != null){
				invalidateDisplayList();
			}
			return direction;
		}
	
		//////////// Colors ///////////////
		
	
		public function setUpColors(clrs:Array<UInt>):Array<UInt>{
			this._upColors = clrs;
			if(this._skinnedControl != null)
			{
				invalidateDisplayList();
			}
			return clrs;
		}
		
		public function setOverColors(clrs:Array<UInt>):Array<UInt>{
			this._overColors = clrs;
			if(this._skinnedControl != null)
			{
				invalidateDisplayList();	
			}
			return clrs;
		}
		
		public function setDownColors(clrs:Array<UInt>):Array<UInt>{
			this._downColors = clrs;
			if(this._skinnedControl != null)
			{
				invalidateDisplayList();
			}	
			return clrs;
		}
		
		/**
		 * Shortcut function for setting colors of all 3 button states
		 * in one pass. Not recommended since there is no feedback to
		 * the user on rollover and rollout states.
		 */ 
		public function setColors(clrs:Array<UInt>):Array<UInt>{
			this._upColors = clrs;
			this._overColors = clrs;
			this._downColors = clrs;
			if(this._skinnedControl != null)
			{
				invalidateDisplayList();
			}	
			return clrs;
		}
		
		public function setStroke(str:Stroke):Stroke{
			_stroke = str;
			this.invalidateDisplayList();
			return str;
		}
		
		
		public function setCornerRadius(cr:Float):Float{
			this._cornerRadius = cr;
			if(this.gradientPainter != null){
				gradientPainter.cornerRadius = cr;
			}
			if(this._skinnedControl != null){
				this.invalidateDisplayList();
			}
			return cr;
		}
		
		///////////////// Button Behavior ////////
		
		public function changeState(fromState:String, toState:String):Void
		{
			this.gradientPainter = new GradientFillPainter([0,0]);
			if(toState==ButtonEvent.UP)
			{
				gradientPainter.colors = _upColors;
				gradientPainter.stroke = _stroke;
			}
			
			else if(toState==ButtonEvent.OVER)
			{
				gradientPainter.colors = _overColors;
				gradientPainter.stroke = _stroke;
			}
			
			else if(toState == ButtonEvent.DOWN)
			{
				gradientPainter.colors = _downColors;
				// draw the focus stroke
				gradientPainter.stroke = new Stroke(1,0x559DE6);
			}
			else
			{
				gradientPainter.colors = _upColors;
				gradientPainter.stroke = _stroke;
			}
			gradientPainter.cornerRadius = _cornerRadius;
			gradientPainter.rotation = Math.PI/2;
			
			this.backgroundPainter = gradientPainter;
			invalidateDisplayList();
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
				
				label.textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
				label.y = (unscaledHeight-label.mheight)/2;
				
				if(this._labelAlign == "center"){
					label.x = (unscaledWidth-label.mwidth)/2;
				}
				else if(_labelAlign == "left"){
					label.x = 10;
				}
			}
			
			if(_icon != null){
				if(label == null){
					_icon.x = (unscaledWidth-_icon.width)/2;
					_icon.y = (unscaledHeight-_icon.height)/2;
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
			}
		}
		
	}
