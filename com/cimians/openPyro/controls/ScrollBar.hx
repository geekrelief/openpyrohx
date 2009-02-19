package com.cimians.openPyro.controls;

	import com.cimians.openPyro.controls.events.ScrollEvent;
	import com.cimians.openPyro.controls.events.SliderEvent;
	import com.cimians.openPyro.controls.scrollBarClasses.HScrollBarLayout;
	import com.cimians.openPyro.controls.scrollBarClasses.VScrollBarLayout;
	import com.cimians.openPyro.controls.skins.IScrollBarSkin;
	import com.cimians.openPyro.core.Direction;
	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.events.PyroEvent;
	import com.cimians.openPyro.skins.ISkin;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/*[Event(name="scroll",type="com.cimians.openPyro.controls.events.ScrollEvent")]*/
	
	class ScrollBar extends UIContainer {
		
		
		
		public var decrementButton(getDecrementButton, setDecrementButton) : Button
		;
		
		public var decrementButtonSkin(null, setDecrementButtonSkin) : ISkin;
		
		public var direction(getDirection, null) : String
		;
		
		public var incrementButton(getIncrementButton, setIncrementButton) : Button
		;
		
		public var incrementButtonSkin(null, setIncrementButtonSkin) : ISkin;
		
		public var maximum(getMaximum, setMaximum) : Float
		;
		
		public var minimum(getMinimum, setMinimum) : Float
		;
		
		public var skin(null, setSkin) : ISkin;
		
		public var slider(getSlider, setSlider) : Slider
		;
		
		public var value(getValue, setValue) : Float
		;
		
		var _direction:String;
		var _slider:Slider;
		
		public function new(direction:String)
		{
			this._direction = direction;
			super();
			_styleName = "ScrollBar"
		}
		
		/**
		 * At the very least, a scrollBar needs a slider
		 * or some subclass of it.
		 * Increment and Decrement Buttons are created
		 * automatically when a skin is applied.
		 */ 
		public override function initialize():Void
		{
			if(!_slider)
			{
				slider = new Slider(_direction);
				slider.addEventListener(PyroEvent.UPDATE_COMPLETE, onSliderUpdateComplete)
				slider.minimum = _minimum
				slider.maximum = _maximum;
			}
			//if(!_layout)
			//{
				if(this._direction == Direction.HORIZONTAL)
				{
					_layout = new HScrollBarLayout()
				}
				else if(this._direction == Direction.VERTICAL)
				{
					_layout = new VScrollBarLayout();
				}
			//}
			this._layout.container = this;
			super.initialize();
			
		}
		
		public function getDirection():String
		{
			return _direction;
		}
		
		public override function setSkin(skinImpl:ISkin):ISkin{
			super.skin = skinImpl;
			if(Std.is( _skin, IScrollBarSkin))
			{
				var scrollBarSkin:IScrollBarSkin = IScrollBarSkin(skinImpl);
				if(scrollBarSkin.sliderSkin)
				{
					if(!_slider)
					{
						slider = new Slider(this._direction);
						slider.minimum = _minimum
						slider.maximum = _maximum
						slider.addEventListener(PyroEvent.UPDATE_COMPLETE, onSliderUpdateComplete)
					}
					_slider.skin = scrollBarSkin.sliderSkin;
				}
				if(scrollBarSkin.incrementButtonSkin)
				{
					this.incrementButtonSkin = scrollBarSkin.incrementButtonSkin;
				}
				if(scrollBarSkin.decrementButtonSkin)
				{
					this.decrementButtonSkin = scrollBarSkin.decrementButtonSkin;
				}
			}
			return skinImpl;
		}
		
		function onSliderUpdateComplete(event:PyroEvent):Void
		{
			updateScrollUI()
		}
		
		var _incrementButton:Button;
		public function setIncrementButton(b:Button):Button
		{
			_incrementButton = b;
			/*if(_direction == Direction.VERTICAL)
			{
				b.percentUnusedWidth=100
			}
			if(_direction == Direction.HORIZONTAL)
			{
				b.percentUnusedHeight = 100;
			}*/
			_incrementButton.addEventListener(MouseEvent.CLICK, onIncrementButtonClick);
			_S_addChild(b);
			invalidateSize();
			//invalidateDisplayList();
			return b;
		}
		
		public function getIncrementButton():Button
		{
			return _incrementButton;	
		}
		
		var _incrementButtonSkin:ISkin;
		public function setIncrementButtonSkin(skin:ISkin):ISkin{
			_incrementButtonSkin = skin;
			if(!_incrementButton)
			{
				incrementButton = new Button();
				// trigger invalidateDL to retrigger the layout
				//this.invalidateDisplayList();
			}
			_incrementButton.skin = skin;
			invalidateSize();
			//invalidateDisplayList();	
			return skin;
		}
		
		var _decrementButton:Button;
		public function setDecrementButton(b:Button):Button
		{
			_decrementButton = b;
			/*if(_direction == Direction.VERTICAL)
			{
				b.percentUnusedWidth=100;
			}
			if(_direction == Direction.HORIZONTAL)
			{
				b.percentUnusedHeight = 100;
			}*/
			_decrementButton.addEventListener(MouseEvent.CLICK, onDecrementButtonClick)
			_S_addChild(b);
			invalidateSize()
			//invalidateDisplayList();
			return b;
		}
		
		/**
		 * The height/width the scrollbar must scroll
		 * when one of the scroll buttons is clicked on.
		 */ 
		public var incrementalScrollDelta:Int;
		function onDecrementButtonClick(event:Event):Void{
			if(_slider.direction == Direction.HORIZONTAL){
				_slider.thumbButton.x = Math.max(0, _slider.thumbButton.x - incrementalScrollDelta)	
			}
			else if(slider.direction == Direction.VERTICAL){
				_slider.thumbButton.y = Math.max(0, _slider.thumbButton.y - incrementalScrollDelta)
			}
			_slider.dispatchScrollEvent()
			
		}
		function onIncrementButtonClick(event:Event):Void{
			//_slider.value = Math.min(1, _slider.value + incrementalScrollDelta/_slider.height)
			if(_slider.direction == Direction.HORIZONTAL){
				_slider.thumbButton.x = Math.min(_slider.height-_slider.thumbButton.height, _slider.thumbButton.x + incrementalScrollDelta)	
			}
			else if(slider.direction == Direction.VERTICAL){
				_slider.thumbButton.y = Math.min(_slider.height-_slider.thumbButton.height, _slider.thumbButton.y + incrementalScrollDelta)
			}
			_slider.dispatchScrollEvent()
		}
		
		public function getDecrementButton():Button
		{
			return _decrementButton;
		}
		
		var _decrementButtonSkin:ISkin;
		public function setDecrementButtonSkin(skin:ISkin):ISkin{
			_decrementButtonSkin = skin;
			if(!_decrementButton)
			{
				decrementButton = new Button()
			}
			_decrementButton.skin = skin;
			invalidateSize();
			//invalidateDisplayList();
			return skin;
		}
		
		public function setSlider(sl:Slider):Slider
		{
			
			if(_slider)
			{
				_slider.removeEventListener(SliderEvent.CHANGE, onSliderThumbDrag);
				removeChild(_slider);
				_slider = null;
			}
			
			_slider = sl;
			_slider.addEventListener(SliderEvent.CHANGE, onSliderThumbDrag);
			this._S_addChild(_slider);
			if(_direction == Direction.HORIZONTAL){
				_slider.explicitWidth = NaN;
				_slider.percentUnusedWidth = 100;
				_slider.percentUnusedHeight = 100;
			}
			else if(_direction==Direction.VERTICAL){
				_slider.explicitHeight = NaN;
				_slider.percentUnusedWidth = 100;
				_slider.percentUnusedHeight = 100;
			}
			_slider.minimum = 0;
			_slider.maximum = 1;
			this.invalidateSize()
			//this.invalidateDisplayList()	
			return sl;
			
		}
		
		public function getSlider():Slider
		{
			return _slider;
		}
		
		var _sliderThumbPosition:Int ;
		function onSliderThumbDrag(event:SliderEvent):Void
		{
			var scrollEvent:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
			scrollEvent.direction = this._direction;
			scrollEvent.delta = _slider.value - _sliderThumbPosition;
			scrollEvent.value = this._slider.value;
			dispatchEvent(scrollEvent);
			_sliderThumbPosition = _slider.value;
		}
		
		/**
		 * For scrollBars, unless the dimension properites of the 
		 * buttons are set, the button's width and heights are 
		 * set to the same as the each other to create square 
		 * buttons
		 */ 
		public override function validateSize():Void
		{
			super.validateSize();
			
		}
		
		
		var _value:Int ;
		var _minimum:Int ;
		var _maximum:Int ;
		
		public function setMinimum(value:Float):Float
		{
			_minimum = value;
			if(_slider)
			{
				_slider.minimum = value;
			}
			return value;
		}
		
		public function getMinimum():Float
		{
			return _minimum;
		}
		
		public function setMaximum(value:Float):Float
		{
			_maximum = value;
			if(_slider)
			{
				_slider.maximum = value
			}
			return value;
		}
		
		public function getMaximum():Float
		{
			return _maximum;
		}
		
		public function setValue(v:Float):Float
		{
			_value = v;
			if(_slider){
				_slider.value = v;
			}
			return v;
		}
		
		public function getValue():Float
		{
			return _slider.value
		}
		
		
		var _visibleScroll:Float ;
		var _maxScroll:Float;
		var _scrollButtonSize:Float ;
		
		public function setScrollProperty(visibleScroll:Float, maxScroll:Float):Void
		{
			
			//trace("Setting scroll py >> "+visibleScroll, maxScroll, _slider.height, this.height);
			//trace(">> "+this.height, this.incrementButton.height, this.decrementButton.height);
			//if(visibleScroll == _visibleScroll && maxScroll == _maxScroll) return;
			
			_visibleScroll = visibleScroll;
			_maxScroll = maxScroll;
			updateScrollUI()
		}
		
		function updateScrollUI():Void
		{
			if(!_slider) return;
			if(this._direction == Direction.VERTICAL)
			{
				_scrollButtonSize = Math.floor(_visibleScroll*_slider.height/_maxScroll)
				_slider.thumbButtonHeight = _scrollButtonSize
				
			}
			else if(this._direction == Direction.HORIZONTAL)
			{
				_scrollButtonSize =  Math.floor(_visibleScroll*_slider.width/_maxScroll);
				_slider.thumbButtonWidth = _scrollButtonSize;
			}	
		}
		
	}
