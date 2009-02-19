package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;

	class ColumnGridLayout implements ILayout, implements IContainerMeasurementHelper {
		
		
		
		public var container(null, setContainer) : UIContainer;
		
		public var initX(null, setInitX) : Float;
		
		public var initY(null, setInitY) : Float;
		
		public var prepare(null, setPrepare) : Dynamic;
		
		var _initX:Int ;
		var _initY:Int ;
		
		var _numRows:UInt;
		var _columnWidth:Float ;
		var _rowGap:Float;
		var _columnGap:Float;
		
		public function new(numRows:UInt, ?columnWidth:Float = NaN, ?rowGap:Int=0, ?columnGap:Int=0)
		{
			
			_initX = 0;
			_initY = 0;
			_columnWidth = NaN;
			this._numRows = numRows;
			_columnWidth = columnWidth;
			_rowGap = rowGap
			_columnGap = columnGap
		}

		public function setInitX(n:Float):Float{
			_initX = n;
			return n;
		}
		
		public function setInitY(n:Float):Float{
			_initY = n;
			return n;
		}
		
		var _container:UIContainer
		public function setContainer(c:UIContainer):UIContainer{
			_container = c;	
			return c;
		}
		
		public function layout(children:Array<Dynamic>):Void
		{
			if(children.length == 0 ) return;
			var nowX:Float = _initX;
			var nowY:Float = _initY;
			
			if(isNaN(_columnWidth)){
				_columnWidth = DisplayObject(children[0]).width;
			}
			
			for(i in 0...children.length)
			{
				var child:DisplayObject = cast( children[i], DisplayObject);
				if(i>0 && (i%_numRows)==0){
					nowX+=_columnWidth+_columnGap;
					nowY = _initY;
				}
				child.x = nowX;
				child.y = nowY;
				nowY+=child.height + _rowGap;
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
