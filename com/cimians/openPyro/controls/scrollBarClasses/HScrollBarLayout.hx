package com.cimians.openPyro.controls.scrollBarClasses;

	import com.cimians.openPyro.controls.ScrollBar;
	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.layout.ILayout;
	
	class HScrollBarLayout implements ILayout {
		
		public var container(null, setContainer) : UIContainer;
		public var initX(getInitX, setInitX) : Float;
		public var initY(getInitY, setInitY) : Float;
		public var prepare(null, setPrepare) : Dynamic;
		var _scrollBar:ScrollBar;
		
		public function new() {
			
		}
		
		public function setContainer(container:UIContainer):UIContainer{
			_scrollBar = cast container;
			return container;
		}
		
		public function getMaxWidth(children:Array<Dynamic>):Float
		{
			return _scrollBar.mwidth;
		}
		
		public function getMaxHeight(children:Array<Dynamic>):Float
		{
			return _scrollBar.mheight;
		}
		
		public function layout(children:Array<Dynamic>):Void
		{
			var allocatedWidth:Float = 0;
			if(_scrollBar.decrementButton != null)
			{
				_scrollBar.decrementButton.x =0;
				allocatedWidth+=_scrollBar.decrementButton.mwidth;
			}
			if(_scrollBar.incrementButton != null)
			{
				_scrollBar.incrementButton.x =  _scrollBar.mwidth-_scrollBar.decrementButton.mwidth;
				allocatedWidth+=_scrollBar.incrementButton.mwidth;
			}
			if(_scrollBar.slider != null && _scrollBar.decrementButton != null)
			{
				_scrollBar.slider.x = _scrollBar.decrementButton.mwidth;
				
				_scrollBar.slider.mwidth = _scrollBar.mwidth-allocatedWidth;
			}
			
			// Immediately validate the size and displaylist of the slider
 			// else we get a lag (flicker) in the drawing.
 			if(_scrollBar.slider != null && Std.is( _scrollBar.slider, MeasurableControl))
			{
				_scrollBar.slider.validateSize();
				_scrollBar.slider.validateDisplayList();
			}
			
		}
		
		var _prepare:Dynamic;
		public function setPrepare(f:Dynamic):Dynamic{
			_prepare = f;
			return f;
		}
		
		public function setInitX(n:Float):Float{
			return n;
	    }

        public function getInitX():Float {
            return Math.NaN;
        }
		
		public function setInitY(n:Float):Float{
			return n;
	    }
        
        public function getInitY():Float {
            return Math.NaN;
        }
	}
