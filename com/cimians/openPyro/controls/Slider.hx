package com.cimians.openPyro.controls;

	import com.cimians.openPyro.controls.events.ButtonEvent;
	import com.cimians.openPyro.controls.events.SliderEvent;
	import com.cimians.openPyro.controls.skins.ISliderSkin;
	import com.cimians.openPyro.core.Direction;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.skins.ISkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/*[Event(name="thumbDrag", type="com.cimians.openPyro.controls.events.SliderEvent")]*/
	
	class Slider extends UIControl {
		
		
		
		public var direction(getDirection, null) : String
		;
		
		public var maximum(getMaximum, setMaximum) : Float;
		
		public var minThumbHeight(null, setMinThumbHeight) : Float;
		
		public var minimum(getMinimum, setMinimum) : Float;
		
		public var skin(null, setSkin) : ISkin;
		
		public var thumbButton(getThumbButton, setThumbButton) : Button
		;
		
		public var thumbButtonHeight(null, setThumbButtonHeight) : Float;
		
		public var thumbButtonWidth(null, setThumbButtonWidth) : Float;
		
		public var thumbSkin(null, setThumbSkin) : ISkin;
		
		public var trackSkin(null, setTrackSkin) : DisplayObject;
		
		public var value(getValue, setValue) : Float;
		
		var _direction:String;
		var _thumbButton:Button;
		var _trackSkin:DisplayObject;
		var _isThumbPressed:Bool ;
		var _thumbButtonHeight:Int;
		var _thumbButtonWidth:Int ;
		
		public function new(direction:String)
		{
			
			_isThumbPressed = false;
			_thumbButtonHeight =50;
			_thumbButtonWidth = 50;
			super();
			this._direction = direction;
			this._styleName = "Slider";
		}
		
		public function getDirection():String
		{
			return _direction;
		}
		
		public override function initialize():Void
		{
			super.initialize()
			if(!_thumbButton)
			{
				thumbButton = new Button();
			}
		}
		
		public override function setSkin(skinImpl:ISkin):ISkin{
			super.skin = skinImpl;
			if(Std.is( skinImpl, ISliderSkin))
			{
				var sliderSkin:ISliderSkin = ISliderSkin(skinImpl);
				if(sliderSkin.trackSkin && Std.is( sliderSkin.trackSkin, DisplayObject)) 
						this.trackSkin = DisplayObject(sliderSkin.trackSkin);
				if(sliderSkin.thumbSkin)
				{
					if(!this._thumbButton)
					{
						thumbButton = new Button();
					}
					this.thumbSkin = sliderSkin.thumbSkin;
				}
						
			}
			this.invalidateSize()
			return skinImpl;
		}
		
		public function setThumbButton(button:Button):Button
		{
			if(_thumbButton){
				_thumbButton.removeEventListener(ButtonEvent.DOWN, onThumbDown);
				removeChild(_thumbButton)
				_thumbButton =null;
			}
			_thumbButton = button;
			_thumbButton.x = 0;
			_thumbButton.addEventListener(ButtonEvent.DOWN, onThumbDown);
			
			/*
			Buttons by default return to their 'up' state when
			the mouse moves out, but slider buttons do not.
			*/
			_thumbButton.mouseOutHandler = function(event:MouseEvent):Void{}
			
			if(_direction == Direction.VERTICAL)
			{
				if(isNaN(_thumbButton.explicitWidth) && isNaN(_thumbButton.percentUnusedWidth))
				{
					_thumbButton.percentUnusedWidth = 100;
				}
				_thumbButton.height = _thumbButtonHeight;	
			}
			else if(_direction == Direction.HORIZONTAL)
			{
				if(isNaN(_thumbButton.explicitHeight) && isNaN(_thumbButton.percentUnusedHeight))
				{
					_thumbButton.percentUnusedHeight = 100;
				}	
				_thumbButton.width = 100;
			}
			
			addChild(_thumbButton);
			
			if(this._thumbSkin)
			{
				_thumbButton.skin = _thumbSkin;
			}
			
			
			/*
			set the state 
			*/
			if(_isThumbPressed){
				// _thumbButton.setState
			}	
			return button;
		}
		
		public function getThumbButton():Button
		{
			return _thumbButton;
		}
		
		var _thumbSkin:ISkin
		public function setThumbSkin(skin:ISkin):ISkin{
			_thumbSkin = skin;
			if(this._thumbButton)
			{
				_thumbButton.skin = skin
			}
			return skin;
		}
		
		var _value:Int ;
		var _minimum:Int ;
		var _maximum:Int ;
		
		
		public function getMinimum():Float{
			return _minimum;
		}
		
		public function setMinimum(value:Float):Float{
			_minimum = value;
			return value;
		}
		
		public function getMaximum():Float{
			return _maximum;
		}
		
		public function setMaximum(value:Float):Float{
			_maximum = value;
			return value;
		}
		
		var boundsRect:Rectangle;
		
		function onThumbDown(event:ButtonEvent):Void{
			this._isThumbPressed = true;
			if(_direction == Direction.HORIZONTAL)
			{
				boundsRect = new Rectangle(0,0,width-_thumbButton.width, 0);
			}
			else
			{
				boundsRect = new Rectangle(0,0,0, height-_thumbButton.height);
			}
			_thumbButton.startDrag(false,boundsRect)
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_thumbButton.addEventListener(ButtonEvent.UP, onThumbUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			
		}
		
		function onEnterFrame(event:Event):Void{
			if(_isThumbPressed){
				//compute slider value
				dispatchScrollEvent()
			}
		}
		
		public function dispatchScrollEvent():Void
		{
			var computedValue:Float
			if(_direction == Direction.HORIZONTAL)
			{
				computedValue = (_thumbButton.x/(this.width-_thumbButton.width))*(_maximum-_minimum);
				thumbButtonX = _thumbButton.x;
			}
			else
			{
				computedValue = (_thumbButton.y/(this.height-_thumbButton.height))*(_maximum-_minimum);
				thumbButtonY = _thumbButton.y;
			}
			if(computedValue != _value)
			{
				_value = computedValue;
				dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAG));
				dispatchEvent(new SliderEvent(SliderEvent.CHANGE));
			}
		}
		
		function onThumbUp(event:Event):Void{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			_thumbButton.stopDrag();
			this._isThumbPressed=false;
		}
		
		public function setTrackSkin(trackSkin:DisplayObject):DisplayObject{
			if(_trackSkin)
			{
				_trackSkin.removeEventListener(MouseEvent.CLICK, onTrackSkinClick);
			}
			_trackSkin = trackSkin;
			_trackSkin.addEventListener(MouseEvent.CLICK, onTrackSkinClick);
			_trackSkin.x = 0;
			addChildAt(_trackSkin,0);
			this.invalidateDisplayList();
			return trackSkin;
		}
		
		var thumbButtonX:Int var thumbButtonY:Int public function onTrackSkinClick(event:MouseEvent):Void
		{
			if(_direction == Direction.HORIZONTAL)
			{
				thumbButtonX = Math.min(event.localX, (this.width-_thumbButton.width))
				_thumbButton.x = thumbButtonX
			}
			else if(_direction == Direction.VERTICAL)
			{
				thumbButtonY =  Math.min(event.localY, (this.height - _thumbButton.height))
				_thumbButton.y = thumbButtonY
			}
			dispatchScrollEvent()
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);	
			if(_trackSkin)
			{
				_trackSkin.width = unscaledWidth;
				_trackSkin.height = unscaledHeight;	
				if(Std.is( _trackSkin, UIControl))
				{
					UIControl(_trackSkin).validateSize();
					UIControl(_trackSkin).validateDisplayList()
				}
				
				/*
				Position the thumb button wherever it was supposed to
				be. For some reason updateDisplaylist keeps sending the button 
				to 0,0
				*/ 
				this._thumbButton.y = this.thumbButtonY; 
				this._thumbButton.x = this.thumbButtonX;
			}
        
		
		}
		
		public function getValue():Float{
			return _value;
		}
		
		public function setValue(v:Float):Float{
			_value = v;
			if(!thumbButton) return;
			if(_direction == Direction.HORIZONTAL)
			{
				_thumbButton.x = v*(this.width-_thumbButton.width)/(_maximum-_minimum) ;
				thumbButtonX = _thumbButton.x;
			}
			else
			{
				_thumbButton.y = v*(this.height-_thumbButton.height)/(_maximum-_minimum) ;
				thumbButtonY = _thumbButton.y;
			}
			dispatchEvent(new SliderEvent(SliderEvent.CHANGE));
			return v;
		}
		
		public function setThumbButtonHeight(value:Float):Float{
			_thumbButtonHeight = value;
			if(_thumbButton)
			{
				_thumbButton.height = Math.max(value,_minThumbHeight);
			}
			return value;
		}
		
		var _minThumbHeight:Int ;
		public function setMinThumbHeight(value:Float):Float{
			this._minThumbHeight = value;	
			return value;
		}
		
		
		public function setThumbButtonWidth(value:Float):Float{
			_thumbButtonWidth = value;
			if(_thumbButton)
			{
				_thumbButton.width = value;
			}
			return value;
		}
		

	}
