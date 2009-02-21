package com.cimians.openPyro.controls.scrollBarClasses;

	import com.cimians.openPyro.controls.ScrollBar;
	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.layout.ILayout;
	
	import flash.display.DisplayObject;
	
	class VScrollBarLayout implements ILayout {
		
		public var container(null, setContainer) : UIContainer;
		public var initX(null, setInitX) : Float;
		public var initY(null, setInitY) : Float;
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
			var allocatedHeight:Float = 0;
			if(_scrollBar.decrementButton != null)
			{
				_scrollBar.decrementButton.y =0;
				allocatedHeight+=_scrollBar.decrementButton.mheight;
			}
			if(_scrollBar.incrementButton != null)
			{
				_scrollBar.incrementButton.y =  _scrollBar.mheight-_scrollBar.incrementButton.mheight;
				allocatedHeight+=_scrollBar.incrementButton.mheight;
			}
			if(_scrollBar.slider != null && _scrollBar.decrementButton != null)
			{
				_scrollBar.slider.y = _scrollBar.decrementButton.mheight;
				
				_scrollBar.slider.mheight = _scrollBar.mheight-allocatedHeight;
			}
			
			// Immediately validate the size and displaylist of the slider
 			// else we get a lag (flicker) in the drawing.
 			if(_scrollBar.slider != null && Std.is( _scrollBar.slider, MeasurableControl))
			{
				_scrollBar.slider.validateSize();
				_scrollBar.slider.validateDisplayList();
			}
		}
		
		public function setInitX(n:Float):Float{
			return n;
        }
		
		public function setInitY(n:Float):Float{
			return n;
        }
		
		var _prepare:Dynamic;
		public function setPrepare(f:Dynamic):Dynamic{
			_prepare = f;
			return f;
		}
	}
