package com.cimians.openPyro.aurora;

	import com.cimians.openPyro.aurora.skinClasses.HDividerSkin;
	import com.cimians.openPyro.controls.skins.IDividedBoxSkin;
	import com.cimians.openPyro.core.UIControl;
	
	class AuroraHDividedBoxSkin extends AuroraContainerSkin, implements IDividedBoxSkin {
		public function new() { }
		
		public function getNewDividerSkin():UIControl{
			var dividerSkin:UIControl =  new HDividerSkin();
			dividerSkin.width = 8;
			dividerSkin.percentUnusedHeight = 100;
			return dividerSkin;
		}
	}
