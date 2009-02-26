package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.UIContainer;
    import com.cimians.openPyro.core.MeasurableControl;

	import flash.display.DisplayObject;

	class ColumnGridLayout implements ILayout, implements IContainerMeasurementHelper {
		
		public var container(null, setContainer) : UIContainer;
		public var initX(getInitX, setInitX) : Float;
		public var initY(getInitY, setInitY) : Float;
		public var prepare(null, setPrepare) : Dynamic;
		
		var _initX:Float ;
		var _initY:Float ;
		
		var _numRows:UInt;
		var _columnWidth:Float;
		var _rowGap:Float;
		var _columnGap:Float;

		var _container:UIContainer;
		
		public function new(numRows:UInt, ?columnWidth:Float, ?rowGap:Float=0, ?columnGap:Float=0)
		{
			_initX = 0;
			_initY = 0;
			this._numRows = numRows;
			_columnWidth = columnWidth;
			_rowGap = rowGap;
			_columnGap = columnGap;
		}

		inline public function setInitX(n:Float):Float{
			_initX = n;
			return n;
		}

        inline public function getInitX():Float { return _initX; }
		
		inline public function setInitY(n:Float):Float{
			_initY = n;
			return n;
		}

        inline public function getInitY():Float { return _initY; }
		
		public function setContainer(c:UIContainer):UIContainer{
			_container = c;	
			return c;
		}
		
		public function layout(children:Array<Dynamic>):Void
		{
			if(children.length == 0 ) return;
			var nowX:Float = _initX;
			var nowY:Float = _initY;
			
			if(Math.isNaN(_columnWidth)){
                if(Std.is(children[0], MeasurableControl)) {
				    _columnWidth = cast(children[0], MeasurableControl).mwidth;
                } else {
    				_columnWidth = cast(children[0], DisplayObject).width;
                }
			}
			
			for(i in 0...children.length)
			{
				var child:DisplayObject = cast children[i];
				if(i>0 && (i%_numRows)==0){
					nowX+=_columnWidth+_columnGap;
					nowY = _initY;
				}
				child.x = nowX;
				child.y = nowY;
                if(Std.is(child, MeasurableControl)) {
				    nowY+= cast(child, MeasurableControl).mheight + _rowGap;
                } else {
    				nowY+=child.height + _rowGap;
                }
			}
		}
		
		public function getMaxWidth(children:Array<Dynamic>):Float
		{
			// TODO: stub ... this needs to cahnge to actually use a calculation
			return 300;
		}
		
		public function getMaxHeight(children:Array<Dynamic>):Float
		{
			//TODO: stub ... this needs to cahnge to actually use a calculation
			return 300;
		}
		
		var _prepare:Dynamic;
		public function setPrepare(f:Dynamic):Dynamic{
			_prepare = f;
			return f;
		}
		
		public function calculateSizes(children:Array<Dynamic>, container:UIContainer):Void
		{
		}
		
	}
