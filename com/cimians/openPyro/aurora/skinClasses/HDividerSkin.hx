package com.cimians.openPyro.aurora.skinClasses;

	import com.cimians.openPyro.aurora.AuroraButtonSkin;
	import com.cimians.openPyro.controls.Button;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.painters.GradientFillPainter;

	class HDividerSkin extends UIControl {
		
		public function new()
		{
			super();
		}
		
		var closeButton:Button;
		override function createChildren():Void{
			this.backgroundPainter = new GradientFillPainter([0x999999, 0xffffff, 0x999999]);
			closeButton = new Button()
			closeButton.skin = new AuroraButtonSkin()
			closeButton.percentWidth=100;
			closeButton.height = 70;
			addChild(closeButton);
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			closeButton.y = (unscaledHeight-70)/2
		}
		
	}
