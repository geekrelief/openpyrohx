package com.cimians.openPyro.aurora;

	import com.cimians.openPyro.controls.skins.IComboBoxSkin;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.skins.ISkin;
	
	import flash.filters.DropShadowFilter;
	
	class AuroraComboBoxSkin implements IComboBoxSkin {
		
		public var buttonSkin(getButtonSkin, null) : ISkin
		;
		public var listSkin(getListSkin, null) : ISkin
		;
		public var skinnedControl(null, setSkinnedControl) : UIControl;
		var _buttonSkin:AuroraButtonSkin;
		var _listSkin:AuroraContainerSkin;
		
		public function new() {
			
		}
		
		public function getButtonSkin():ISkin
		{
			_buttonSkin = new AuroraButtonSkin();
			_buttonSkin.labelAlign = "left";
			_buttonSkin.cornerRadius = 10;
			_buttonSkin.filters = [new DropShadowFilter(.5,90,0,1,0,0)]
			return _buttonSkin;
		}
		
		public function getListSkin():ISkin
		{
			_listSkin =  new AuroraContainerSkin();
			return _listSkin;
		}
		
		public function dispose():Void
		{
			
		}
		
		public function setSkinnedControl(control:UIControl):UIControl{
			if(_buttonSkin)
			{
				_buttonSkin.skinnedControl = control;
			}
			return control;
		}

	}
