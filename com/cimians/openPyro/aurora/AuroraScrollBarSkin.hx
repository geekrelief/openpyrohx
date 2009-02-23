package com.cimians.openPyro.aurora;

	import com.cimians.openPyro.controls.skins.IScrollBarSkin;
	import com.cimians.openPyro.controls.skins.ISliderSkin;
	import com.cimians.openPyro.core.Direction;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.shapes.Triangle;
	import com.cimians.openPyro.skins.ISkin;

	class AuroraScrollBarSkin implements IScrollBarSkin {
		
		public var decrementButtonSkin(getDecrementButtonSkin, null) : ISkin ;
		public var incrementButtonSkin(getIncrementButtonSkin, null) : ISkin ;
		public var skinnedControl(null, setSkinnedControl) : UIControl;
		public var sliderSkin(getSliderSkin, null) : ISliderSkin ;
		
		public var direction:String ;
		
		var _incrementButtonSkin:AuroraButtonSkin;
		var _decrementButtonSkin:AuroraButtonSkin;
		var _sliderSkin:AuroraSliderSkin;
		
		public function new()
		{
		    direction = Direction.VERTICAL;
		}

		public function getIncrementButtonSkin():ISkin
		{
			_incrementButtonSkin = new AuroraButtonSkin();
			if(direction == Direction.VERTICAL){
				_incrementButtonSkin.icon = new Triangle(Direction.DOWN, 6,6);
			}
			else if(direction == Direction.HORIZONTAL){
				_incrementButtonSkin.icon = new Triangle(Direction.RIGHT, 6,6);
			}
			_incrementButtonSkin.mwidth = 15;
			_incrementButtonSkin.mheight= 15;
			return _incrementButtonSkin;
		}
		
		public function getDecrementButtonSkin():ISkin
		{
			_decrementButtonSkin = new AuroraButtonSkin();
			if(direction == Direction.VERTICAL){
				_decrementButtonSkin.icon = new Triangle(Direction.UP, 6,6);
			}
			else if(direction == Direction.HORIZONTAL){
				_decrementButtonSkin.icon = new Triangle(Direction.LEFT, 6,6);
			}
			_decrementButtonSkin.mwidth = 15;
			_decrementButtonSkin.mheight= 15;
			return _decrementButtonSkin;
		}
		
		public function setSkinnedControl(uic:UIControl):UIControl{
			return uic;
        }
		
		public function getSliderSkin():ISliderSkin
		{
			_sliderSkin = new AuroraSliderSkin();
			if(direction == Direction.HORIZONTAL)
			{
				_sliderSkin.trackGradientRotation = Math.PI/2;
			}
			return _sliderSkin;
		}
		
		public function dispose():Void
		{
			if(_incrementButtonSkin != null && _incrementButtonSkin.parent != null)
			{
				_incrementButtonSkin.parent.removeChild(_incrementButtonSkin);
			}
			_incrementButtonSkin = null;
			
			if(_decrementButtonSkin != null && _decrementButtonSkin.parent != null)
			{
				_decrementButtonSkin.parent.removeChild(_decrementButtonSkin);
			}
			_decrementButtonSkin = null;
			if(_sliderSkin != null){
				_sliderSkin.dispose();	
			}
		}
		
	}
