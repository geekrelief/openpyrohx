package com.cimians.openPyro.shapes;

	import com.cimians.openPyro.core.Direction;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	class Triangle extends Sprite, implements IShape {
		
		public var direction(null, setDirection) : String;
		var _direction:String ;
		
		var _h:Float;
		var _w:Float;
		
		var _fillColor:UInt ;
		var _fillAlpha:Int var _strokeColor:UInt;
		var _strokeWidth:Int;
		var _strokeAlpha:Int;
		
		public function new(?direction:String = Direction.UP, ?width:Int=30, ?height:Int=30)
		{
			
			_direction = Direction.UP;
			_fillColor = 0x666666;
			_fillAlpha = 1
		
		;
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
		public function setStroke(strokeWidth:Float, ?strokeColor:UInt=0x000000, ?strokeAlpha:Int=1):Void
		{
			this._strokeWidth = strokeWidth;
			this._strokeColor = strokeColor;
			this._strokeAlpha = strokeAlpha;
			if(this.stage){
				drawShape();
			}
		}
		
		public function setFill(fillColor:UInt, ?fillAlpha:UInt=1):Void
		{
			_fillColor = fillColor;
			_fillAlpha = fillAlpha;
			if(this.stage){
				drawShape();
			}	
		}
		
		public function setDirection(pointDirection:String):String{
			this._direction = pointDirection;
			if(this.stage){
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
				drawUpArrow()
				break;
				case Direction.DOWN:
				drawDownArrow()
				break;
				case Direction.LEFT:
				drawLeftArrow()
				break;
				case Direction.RIGHT:
				drawRightArrow()
				break;
				
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
		
		
	}
