package com.cimians.openPyro.layout;
	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;
	
	class HLayout implements ILayout, implements IContainerMeasurementHelper {
		
		
		public var container(null, setContainer) : UIContainer;
		
		public var initX(getInitX, setInitX) : Float;
		public var initY(getInitY, setInitY) : Float;
		public var prepare(null, setPrepare) : Dynamic;
		
		
		var _hGap:Float;
		var _initY:Float ;
		var _initX:Float ;
		
		public function new(?hGap:Float=0){
			_hGap = hGap;
            _initY = 0;
            _initX = 0;
		}
		
		var _container:UIContainer;
		public function setContainer(container:UIContainer):UIContainer{
			_container = container;
			return container;
		}
		
		public function setInitX(n:Float):Float{
			_initX = n;	
			return n;
		}
		
		public function getInitX():Float{
			return _initX;
		}
		
		public function setInitY(n:Float):Float{
			_initY = n;
			return n;
		}
		
		public function getInitY():Float{
			return _initY;
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
				if(i>0){
					container.explicitlyAllocatedWidth+=_hGap;
				}
				if(Std.is( children[i], MeasurableControl))	
				{
					var sizeableChild:MeasurableControl = cast children[i];
					
					if(!Math.isNaN(sizeableChild.explicitWidth))
					{
						container.explicitlyAllocatedWidth+=sizeableChild.explicitWidth;
					}
				}
			}
		}
		
		public function getMaxWidth(children:Array<Dynamic>):Float
		{
			var nowX:Float=_initX;
			for(i in 0...children.length){
                var c = children[i];
                if(Std.is(c, MeasurableControl)){
                    nowX += cast(c, MeasurableControl).mwidth+_hGap;
                } else {
				    nowX+= cast(c, DisplayObject).width+_hGap;
                }
			}
			return nowX-_hGap;	
		}
		
		public function getMaxHeight(children:Array<Dynamic>):Float
		{
			var maxH:Float=0;
			for(i in 0...children.length)
			{
                var c = children[i];
                if(Std.is(c, MeasurableControl)) {
                    if(cast(c, MeasurableControl).mheight > maxH){
					    maxH = cast(c, MeasurableControl).mheight;
                    }
                } else {
				    if(cast(c, DisplayObject).height > maxH)
    				{
    					maxH = cast(c, DisplayObject).height;
    				}
                }
			}
			return maxH;
		}
		
		var _prepare:Dynamic;
		public function setPrepare(f:Dynamic):Dynamic{
			_prepare = f;
			return f;
		}
		
		public function layout(children:Array<Dynamic>):Void{
			var nowX:Float=_initX;
			for(i in 0...children.length){
				var c:DisplayObject = cast children[i];
				c.x = nowX;
				c.y = _initY;
                if(Std.is(c, MeasurableControl)){
    				nowX+=cast(c, MeasurableControl).mwidth+_hGap;
                } else {
				    nowX+=c.width+_hGap;
                }
			}		
		}
	}
