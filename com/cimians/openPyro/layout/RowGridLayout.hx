package com.cimians.openPyro.layout;

	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.core.MeasurableControl;
	
	import flash.display.DisplayObject;

	class RowGridLayout implements ILayout, implements IContainerMeasurementHelper {
		
		public var container(null, setContainer) : UIContainer; 
		public var initX(getInitX, setInitX) : Float; 
		public var initY(getInitY, setInitY) : Float; 
		public var prepare(null, setPrepare) : Dynamic;
		
		var _initX:Float ;
		var _initY:Float ;
		
		var _numColumns:UInt;
		var _rowHeight:Float ;
		var _rowGap:Float;
		var _columnGap:Float;
		
		public function new(numColumns:UInt, ?rowHeight:Float, ?rowGap:Float=0, ?columnGap:Float=0)
		{
			_initX = 0;
			_initY = 0;
			this._numColumns = numColumns;
			_rowHeight = rowHeight;
			_rowGap = rowGap;
			_columnGap = columnGap;
		}
		
		var _prepare:Dynamic;
		public function setPrepare(f:Dynamic):Dynamic{
			_prepare = f;
			return f;
		}

		inline public function setInitX(n:Float):Float{
			_initX = n;
			return n;
		}

        inline public function getInitX():Float{
            return _initX;
        }
		
		inline public function setInitY(n:Float):Float{
			_initY = n;
			return n;
		}

        inline public function getInitY():Float{
            return _initY;
        }
		
		var _container:UIContainer;
		public function setContainer(c:UIContainer):UIContainer{
			_container = c;	
			return c;
		}
		
		public function layout(children:Array<Dynamic>):Void
		{
			if(children.length == 0 ) return;
			var nowX:Float = _initX;
			var nowY:Float = _initY;
			
			if(Math.isNaN(_rowHeight)){
                if(Std.is(children[0], MeasurableControl)) {
				    _rowHeight = cast(children[0], MeasurableControl).mheight;
                } else {
				    _rowHeight = cast(children[0], DisplayObject).height;
                }
			}
			
			for(i in 0...children.length)
			{
				var child:DisplayObject = cast children[i];
				if(i>0 && (i%_numColumns)==0){
					nowY+= _rowHeight+_rowGap;
					nowX= _initX;
				}
				child.x = nowX;
				child.y = nowY;
                nowX+= ((Std.is(child, MeasurableControl)) ?  cast(child, MeasurableControl).mwidth : child.width) + _columnGap;
			}
		}
		
		public function getMaxWidth(children:Array<Dynamic>):Float
		{
			if(children.length == 0){
				return 0;
			}
			var childW:Float = (Std.is(children, MeasurableControl)) ?  cast(children[0], MeasurableControl).mwidth : children[0].width;
			var w:Float = childW * this._numColumns;
			return w;
		}
		
		public function getMaxHeight(children:Array<Dynamic>):Float
		{
			if(children.length == 0){
				return 0;
			}
			
			var childH:Float = Math.isNaN(_rowHeight) 
                ? (Std.is(children[0], MeasurableControl) 
                      ? cast(children[0], MeasurableControl).mheight 
                      : children[0].height) 
                : _rowHeight;
			var numRows:Float = children.length%_numColumns != 0 ? children.length/_numColumns+1 : children.length/_numColumns;
			return (numRows*childH+(numRows-1)*_rowGap) ;
		}
		
		public function calculateSizes(children:Array<Dynamic>, container:UIContainer):Void
		{
			trace("--> calculate new sizes");
		}
		
	}
