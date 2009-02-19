package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;

	class RowGridLayout implements ILayout, implements IContainerMeasurementHelper {
		
		
		
		public var container(null, setContainer) : UIContainer;
		
		public var initX(null, setInitX) : Float;
		
		public var initY(null, setInitY) : Float;
		
		public var prepare(null, setPrepare) : Dynamic;
		
		var _initX:Int ;
		var _initY:Int ;
		
		var _numColumns:UInt;
		var _rowHeight:Float ;
		var _rowGap:Float;
		var _columnGap:Float;
		
		public function new(numColumns:UInt, ?rowHeight:Float = NaN, ?rowGap:Int=0, ?columnGap:Int=0)
		{
			
			_initX = 0;
			_initY = 0;
			_rowHeight = NaN;
			this._numColumns = numColumns;
			_rowHeight = rowHeight;
			_rowGap = rowGap
			_columnGap = columnGap
		}
		
		var _prepare:Dynamic;
		public function setPrepare(f:Dynamic):Dynamic{
			_prepare = f;
			return f;
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
			
			if(isNaN(_rowHeight)){
				_rowHeight = DisplayObject(children[0]).height;
			}
			
			for(i in 0...children.length)
			{
				var child:DisplayObject = cast( children[i], DisplayObject);
				if(i>0 && (i%_numColumns)==0){
					nowY+= _rowHeight+_rowGap;
					nowX= _initX;
				}
				child.x = nowX;
				child.y = nowY;
				nowX+=child.width + _columnGap;
			}
		}
		
		public function getMaxWidth(children:Array<Dynamic>):Float
		{
			if(children.length == 0){
				return 0
			}
			var childW:Int = children[0].width;
			var w:Float = childW * this._numColumns
			return w;
		}
		
		public function getMaxHeight(children:Array<Dynamic>):Float
		{
			if(children.length == 0){
				return 0
			}
			
			var childH:Int = isNaN(_rowHeight)?children[0].height:_rowHeight;
			var numRows:Int = children.length%_numColumns != 0 ? children.length/_numColumns+1 : children.length/_numColumns
			return (numRows*childH+(numRows-1)*_rowGap) ;
		}
		
		public function calculateSizes(children:Array<Dynamic>, container:UIContainer):Void
		{
			trace("--> calculate new sizes")
		}
		
	}
