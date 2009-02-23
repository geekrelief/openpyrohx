package com.cimians.openPyro.controls.listClasses;

	import com.cimians.openPyro.core.IDataRenderer;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.painters.FillPainter;
	import com.cimians.openPyro.painters.IPainter;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	class DefaultListRenderer extends UIControl, implements IDataRenderer, implements IListDataRenderer {
		
		public var baseListData(null, setBaseListData) : BaseListData;
		
		public var data(getData, setData) : Dynamic ; 
		public var labelFormat(null, setLabelFormat) : TextFormat; 
		public var rollOutBackgroundPainter(null, setRollOutBackgroundPainter) : IPainter; 
		public var rollOverBackgroundPainter(null, setRollOverBackgroundPainter) : IPainter; 
		public var selected(getSelected, setSelected) : Bool ;
		
		var _labelField:TextField;
		
		var _rollOverBackgroundPainter:IPainter;
		var _rollOutBackgroundPainter:IPainter;
		var _labelFormat:TextFormat;
		
		public function new() {
			super();
		}
		
		override function createChildren():Void
		{
			super.createChildren();
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_labelField = new TextField();
			_labelField.selectable=false;
			
			if(_labelFormat == null){
				_labelField.defaultTextFormat= new TextFormat("Arial",12);
			} 
			else{
				_labelField.defaultTextFormat = _labelFormat;
			}
			addChild(_labelField);
			if(_data != null && _baseListData != null && _baseListData.list != null){
				_labelField.text = _baseListData.list.labelFunction(_data);
			}
			
			if(_rollOverBackgroundPainter == null){
				_rollOverBackgroundPainter = new FillPainter(0x559DE6);
			}
			if(_rollOutBackgroundPainter == null){
				_rollOutBackgroundPainter = new FillPainter(0xffffff);
			}
			this.backgroundPainter = this._rollOutBackgroundPainter;
		}
		
		var _baseListData:BaseListData;
		public function setBaseListData(value:BaseListData):BaseListData{
			_baseListData = value;
			return value;
		}
		public function setRollOutBackgroundPainter(painter:IPainter):IPainter{
			this._rollOutBackgroundPainter = painter;
			return painter;
		}
		
		public function setRollOverBackgroundPainter(painter:IPainter):IPainter{
			this._rollOverBackgroundPainter = painter;
			return painter;
		}
		
		public function setLabelFormat(format:TextFormat):TextFormat{
			_labelFormat = format;
			if(_labelField != null){
				_labelField.defaultTextFormat = format;
			}
			return format;
		}
		
		function mouseOverHandler(event:MouseEvent):Void
		{
			this.backgroundPainter = _rollOverBackgroundPainter;
		}
		
		function mouseOutHandler(event:MouseEvent):Void
		{
			if(!_selected){
				this.backgroundPainter = _rollOutBackgroundPainter;
			}
		}
		
		var _data:Dynamic;
		
		public function setData(value:Dynamic):Dynamic
		{
			_data = value;
			
			if(_labelField != null && _baseListData != null && _baseListData.list != null){
				_labelField.text =  _baseListData.list.labelFunction(_data);
			}
			return value;
		}
		
		public function getData():Dynamic
		{
			return _data;
		}
		
		var _selected:Bool ;
		public function setSelected(b:Bool):Bool
		{
			_selected = b;
			if(_selected){
				this.backgroundPainter = _rollOverBackgroundPainter;
			}
			else{
				this.backgroundPainter = _rollOutBackgroundPainter;
			}
			invalidateDisplayList();
			
			return b;
		}
		public function getSelected():Bool
		{
			return _selected;
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		
			_labelField.x = _labelField.y = 5;
			_labelField.width = unscaledWidth-10;
			_labelField.height = Math.max(unscaledHeight-10,20);
		}

	}
