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
			_scrollBar = ScrollBar(container);
			return container;
		}
		
		
		public function getMaxWidth(children:Array<Dynamic>):Float
		{
			return _scrollBar.width;
		}
		
		public function getMaxHeight(children:Array<Dynamic>):Float
		{
			return _scrollBar.height;
		}
		
		public function layout(children:Array<Dynamic>):Void
		{
			var allocatedHeight:Int = 0;
			if(_scrollBar.decrementButton)
			{
				_scrollBar.decrementButton.y =0;
				allocatedHeight+=_scrollBar.decrementButton.height;
			}
			if(_scrollBar.incrementButton)
			{
				_scrollBar.incrementButton.y =  _scrollBar.height-_scrollBar.incrementButton.height;
				allocatedHeight+=_scrollBar.incrementButton.height;
			}
			if(_scrollBar.slider && _scrollBar.decrementButton)
			{
				_scrollBar.slider.y = _scrollBar.decrementButton.height;
				
				_scrollBar.slider.height = _scrollBar.height-allocatedHeight;
			}
			
			// Immediately validate the size and displaylist of the slider
 			// else we get a lag (flicker) in the drawing.
 			if(_scrollBar.slider && Std.is( _scrollBar.slider, MeasurableControl))
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
