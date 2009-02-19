package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;

	class AbsoluteLayout implements ILayout, implements IContainerMeasurementHelper {
		
		
		
		public var container(null, setContainer) : UIContainer;
		
		public var initX(null, setInitX) : Float;
		
		public var initY(null, setInitY) : Float;
		
		public var prepare(null, setPrepare) : Dynamic;
		
		var _container:UIContainer
		
		public function new() {
			
		}
		
		public function setInitX(n:Float):Float{
			return n;
	}
		
		public function setInitY(n:Float):Float{
			return n;
	}
		
		public function setContainer(c:UIContainer):UIContainer{
			_container = c;
			return c;
		}
		
		public function layout(children:Array<Dynamic>):Void
		{

		}
		
		public function getMaxWidth(children:Array<Dynamic>):Float
		{
			var maxW:Int=0;
			for(i in 0...children.length)
			{
				if(DisplayObject(children[i]).width > maxW)
				{
					maxW = DisplayObject(children[i]).width
				}
			}
			return maxW;
		}
		
		public function getMaxHeight(children:Array<Dynamic>):Float
		{
			var maxH:Int=0;
			for(i in 0...children.length)
			{
				if(DisplayObject(children[i]).height > maxH)
				{
					maxH = DisplayObject(children[i]).height
				}
			}
			return maxH;
		}
		
		var _prepare:Dynamic;
		public function setPrepare(f:Dynamic):Dynamic{
			_prepare = f;
			return f;
		}
		
		/**		
		*Find all the children with explicitWidth/ explicit Height set
		*This part depends on the layout since HLayout will start trimming
		*the objects available h space, and v layout will do the same 
		*for vertically available space
		**/
		
		public function calculateSizes(children:Array<Dynamic>,container:UIContainer):Void
		{
			for(i in 0...children.length)
			{
				if(Std.is( children[i], MeasurableControl))				
				{
					var sizeableChild:MeasurableControl = MeasurableControl(children[i]);
					if(!isNaN(sizeableChild.explicitWidth))
					{
						container.explicitlyAllocatedWidth+=sizeableChild.explicitWidth;
					}
					if(!isNaN(sizeableChild.explicitHeight))
					{
						container.explicitlyAllocatedHeight+=sizeableChild.explicitHeight;	
					}
				}
			}
		}
		
	}
