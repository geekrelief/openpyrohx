package com.cimians.openPyro.aurora.skinClasses;

	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.painters.GradientFillPainter;
	import com.cimians.openPyro.painters.Stroke;
	
	class GradientRectSkin extends UIControl {
		
		public var gradientRotation(null, setGradientRotation) : Float;
		public var stroke(getStroke, setStroke) : Stroke ;

		var _gradientRotation:Float ;
		var gradientFill:GradientFillPainter;
		var _stroke:Stroke ;
		
		public function new()
		{
            super();
			_gradientRotation = 0;
			gradientFill = new GradientFillPainter([0x999999,0xdfdfdf],[.6,1],[1,255],_gradientRotation);
			this.backgroundPainter = gradientFill;
            _stroke = new Stroke(1, 0x777777);
		}
		
		public function setGradientRotation(r:Float):Float{
			_gradientRotation = r;
			gradientFill.rotation = _gradientRotation;
			this.invalidateDisplayList();
			return r;
		}
		
		
		public function setStroke(str:Stroke):Stroke
		{
			_stroke = str;
			gradientFill.stroke = str;
			this.invalidateDisplayList();
			return str;
		}
		
		public function getStroke():Stroke
		{
			return _stroke;
		}

	}
