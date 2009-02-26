package com.cimians.openPyro.controls;

	import com.cimians.openPyro.collections.XMLCollection;
	import com.cimians.openPyro.collections.XMLNodeDescriptor;
	import com.cimians.openPyro.controls.events.TreeEvent;
	import com.cimians.openPyro.controls.treeClasses.DefaultTreeItemRenderer;
	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.core.ObjectPool;
	import com.cimians.openPyro.layout.VLayout;
	import com.cimians.openPyro.painters.FillPainter;
	
	import flash.display.DisplayObject;
	//import flash.profiler.showRedrawRegions;

	class Tree extends List {
		
		public var showRoot(getShowRoot, setShowRoot) : Bool;
		var _showRoot:Bool ;

		public function new()
		{
			super();
			_labelFunction = function(data:XMLNodeDescriptor):String{
				if(data.node.nodeType == Xml.Element){
					return data.node.get("label");
				}
				return data.node.toString();
			}
			this.backgroundPainter = new FillPainter(0xffffff);

            _showRoot = true;
		}
		
		override function createChildren():Void
		{
			if(this._rendererPool == null){
				var cf:ClassFactory = new ClassFactory(DefaultTreeItemRenderer);
				cf.properties = {setPercentWidth:100, setHeight:25};
				_rendererPool = new ObjectPool(cf);
			}
			cast(this.layout, VLayout).animationDuration = 0;
			
		}
		
		override function convertDataToCollection(dp:Dynamic):Void{
			super.convertDataToCollection(dp);
			if(!_showRoot){	
				cast(_dataProvider, XMLCollection).normalizedArray.shift();
			}
		}
		
		public function setShowRoot(value:Bool):Bool{
			_showRoot = value;
			return value;
		}
		
		public function getShowRoot():Bool{
			return _showRoot;
		}
		
		override function setRendererData(renderer:DisplayObject, data:Dynamic, index:Int):Void{
			super.setRendererData(renderer, data, index);
			renderer.addEventListener(TreeEvent.ROTATOR_CLICK, handleRotatorClick);
		}
		
		function handleRotatorClick(event:TreeEvent):Void
		{
			var node:XMLNodeDescriptor = event.nodeDescriptor;
			if(node.isLeaf()) {
				return;
			}
			// for a non leaf node 
			if(node.open){
				closeNode(node);
			}
			else{
				openNode(node);
			}
		}
		
		public function closeNode(node:XMLNodeDescriptor):Void{
			if(node.isLeaf()) {
				return;
			}
			node.open = false;
			var childNodesData:Array<Dynamic> = cast(this.dataProvider, XMLCollection).getOpenChildNodes(node);
			cast(this.dataProvider, XMLCollection).removeItems(childNodesData);
		}
		
		public function openNode(node:XMLNodeDescriptor):Void{
			if(node.isLeaf()) {
				return;
			}
			node.open = true;
			var childNodesData:Array<Dynamic> = cast(this.dataProvider, XMLCollection).getOpenChildNodes(node);
			cast(this.dataProvider, XMLCollection).addItems(childNodesData, node);
		}
		
		public function getNodeByLabel(str:String):XMLNodeDescriptor{
			var normalizedArray:Array<Dynamic> = _dataProvider.normalizedArray;
			for(i in 0...normalizedArray.length){
				var nodeDescriptor:XMLNodeDescriptor = cast( normalizedArray[i], XMLNodeDescriptor);
				if(_labelFunction(nodeDescriptor) == str){
					return nodeDescriptor;
				}
			}
			return null;
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			//trace(" >> updateDl")
		}
	}
