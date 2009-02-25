package com.cimians.openPyro.managers.toolTipClasses;

	import com.cimians.openPyro.controls.Label;
	import com.cimians.openPyro.core.IDataRenderer;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.events.PyroEvent;
	import com.cimians.openPyro.painters.FillPainter;
	
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;

	class DefaultToolTipRenderer extends UIControl, implements IDataRenderer {
		
		public var data(getData, setData) : Dynamic;
		var _label:Label;
		var _labelFormat:TextFormat;
		
		public function new()
		{
			super();
		}
		
		override function createChildren():Void{
			_label = new Label();
			if(_labelFormat == null){
				_labelFormat = new TextFormat("Arial", 12, 0);
			}
			_label.addEventListener(PyroEvent.UPDATE_COMPLETE, onlabelUpdateComplete);
			//_label.addEventListener()
			_label.textFormat = _labelFormat;
			addChild(_label);
			var painter:FillPainter = new FillPainter(0xfff000,1,null,5);
			this.backgroundPainter = painter;
			this.filters = [new DropShadowFilter()];
		}
		
		var _data:Dynamic;
		public function setData(d:Dynamic):Dynamic{
			_data = d;
			if(_label != null){ // && Std.is(d, String)){  // assume string.. error on sprite
				_label.text = cast(d, String);
			}
			return d;
		}
		
		public function getData():Dynamic{
			return _data;
		}
		
		function onlabelUpdateComplete(event:Event):Void{
			//trace(">> 2 ")
			//updateDisplayList(width, height);
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_label.x = _label.y = 2;
			//trace("l w:: "+_label.mwidth)
		}
		
	}
