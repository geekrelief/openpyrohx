package com.cimians.openPyro.shapes;

	import com.cimians.openPyro.core.Direction;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	class Triangle extends Sprite, implements IShape {
		
		public var direction(null, setDirection) : String;
		var _direction:String ;

        public var mheight(getHeight, setHeight):Float;
		var _h:Float;

        public var mwidth(getWidth, setWidth):Float;
		var _w:Float;
		
		var _fillColor:UInt;
		var _fillAlpha:Float;
        var _strokeColor:UInt;
		var _strokeWidth:Float;
		var _strokeAlpha:Float;
		
		public function new(?direction:String, ?width:Float=30, ?height:Float=30)
		{
            super();
			_direction = Direction.UP;
			_fillColor = 0x666666;
			_fillAlpha = 1;
			_strokeColor =0x000000;
			_strokeWidth =0;
			_strokeAlpha =1;
			_h = height;
			_w = width;
			_direction = direction;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		function onAddedToStage(event:Event):Void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawShape();
		}	
		public function setStroke(strokeWidth:Float, ?strokeColor:UInt=0x000000, ?strokeAlpha:Float=1):Void
		{
			this._strokeWidth = strokeWidth;
			this._strokeColor = strokeColor;
			this._strokeAlpha = strokeAlpha;
			if(this.stage != null){
				drawShape();
			}
		}
		
		public function setFill(fillColor:UInt, ?fillAlpha:UInt=1):Void
		{
			_fillColor = fillColor;
			_fillAlpha = fillAlpha;
			if(this.stage != null){
				drawShape();
			}	
		}
		
		public function setDirection(pointDirection:String):String{
			this._direction = pointDirection;
			if(this.stage != null){
				drawShape();
			}
			return pointDirection;
		}
		
		public function drawShape():Void
		{
			this.graphics.clear();
			if(_strokeWidth > 0){
				this.graphics.lineStyle(_strokeWidth, _strokeColor, _strokeAlpha);
			}
			this.graphics.beginFill(_fillColor, _fillAlpha);
			
			switch (_direction){
				case Direction.UP:
    				drawUpArrow();
				case Direction.DOWN:
    				drawDownArrow();
				case Direction.LEFT:
    				drawLeftArrow();
				case Direction.RIGHT:
    				drawRightArrow();
			}
			
			this.graphics.endFill();
		}
		
		function drawDownArrow():Void
		{
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(_w/2, _h);
			this.graphics.lineTo(_w, 0);
			this.graphics.lineTo(0, 0);
		}
		
		
		function drawLeftArrow():Void
		{					
			this.graphics.moveTo(_w,0);
			this.graphics.lineTo(_w, _h);
			this.graphics.lineTo(0, _h/2);
			this.graphics.lineTo(_w, 0);
		}
		
		function drawRightArrow():Void
		{			
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(_w, _h/2);
			this.graphics.lineTo(0, _h);
			this.graphics.lineTo(0, 0);
		}
		
		function drawUpArrow():Void
		{			
			this.graphics.moveTo(0,_h);
			this.graphics.lineTo(_w/2, 0);
			this.graphics.lineTo(_w, _h);
			this.graphics.lineTo( 0, _h);
		}


        function getHeight():Float{
            return _h;
        }

        function setHeight(v:Float){
            _h = v;
            return v;
        }

        function getWidth():Float{
            return _w;
        }

        function setWidth(v:Float){
            _w = v;
            return v;
        }
	}
