package com.cimians.openPyro.aurora;

	import com.cimians.openPyro.aurora.AuroraScrollBarSkin;
	import com.cimians.openPyro.controls.skins.IScrollBarSkin;
	import com.cimians.openPyro.controls.skins.IScrollableContainerSkin;
	import com.cimians.openPyro.core.Direction;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.skins.ISkin;

	class AuroraContainerSkin implements IScrollableContainerSkin {	
		
			
		
		public var horizontalScrollBarSkin(getHorizontalScrollBarSkin, null) : IScrollBarSkin
		;	
		
		public var skinnedControl(null, setSkinnedControl) : UIControl;	
		
		public var verticalScrollBarSkin(getVerticalScrollBarSkin, null) : IScrollBarSkin
		;	
		
		var _horizontalScrollBarSkin:AuroraScrollBarSkin;
		var _verticalScrollBarSkin:AuroraScrollBarSkin;
		
		public function new() {	
			
		}
		
		public function getVerticalScrollBarSkin():IScrollBarSkin
		{
			_verticalScrollBarSkin = new AuroraScrollBarSkin()
			_verticalScrollBarSkin.direction = Direction.VERTICAL;
			return _verticalScrollBarSkin;
		}
		
		public function getHorizontalScrollBarSkin():IScrollBarSkin
		{
			_horizontalScrollBarSkin = new AuroraScrollBarSkin();
			_horizontalScrollBarSkin.direction = Direction.HORIZONTAL;
			return _horizontalScrollBarSkin;
		}
		
		public function setSkinnedControl(uic:UIControl):UIControl{
			return uic;
	}
		
		public function dispose():Void
		{
			_verticalScrollBarSkin.dispose();
			_horizontalScrollBarSkin.dispose();
		}
				
	}
