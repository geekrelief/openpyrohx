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
	import flash.profiler.showRedrawRegions;

	class Tree extends List {
		
		public var showRoot(getShowRoot, setShowRoot) : Bool;
		public function new()
		{
			super();
			_labelFunction = function(data:XMLNodeDescriptor):String{
				if(data.node.nodeKind() == "element"){
					return String(data.node.@label)
				}
				return String(data.node);
			}
			this.backgroundPainter = new FillPainter(0xffffff);
		}
		
		override function createChildren():Void
		{
			if(!this._rendererPool){
				var cf:ClassFactory = new ClassFactory(DefaultTreeItemRenderer);
				cf.properties = {percentWidth:100, height:25};
				_rendererPool = new ObjectPool(cf)
			}
			VLayout(this.layout).animationDuration = 0;
			
		}
		
		override function convertDataToCollection(dp:Dynamic):Void{
			super.convertDataToCollection(dp);
			if(!_showRoot){	
				XMLCollection(_dataProvider).normalizedArray.shift();
			}
		}
		
		var _showRoot:Bool ;
		public function setShowRoot(value:Bool):Bool{
			_showRoot = value;
			return value;
		}
		
		public function getShowRoot():Bool{
			return _showRoot
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
			var childNodesData:Array<Dynamic> = XMLCollection(this.dataProvider).getOpenChildNodes(node)
			XMLCollection(this.dataProvider).removeItems(childNodesData);
		}
		
		public function openNode(node:XMLNodeDescriptor):Void{
			if(node.isLeaf()) {
				return;
			}
			node.open = true;
			var childNodesData:Array<Dynamic> = XMLCollection(this.dataProvider).getOpenChildNodes(node)
			XMLCollection(this.dataProvider).addItems(childNodesData, node);
		}
		
		public function getNodeByLabel(str:String):XMLNodeDescriptor{
			var normalizedArray:Array<Dynamic> = _dataProvider.normalizedArray
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
			super.updateDisplayList(unscaledWidth, unscaledHeight)
			//trace(" >> updateDl")
		}
		
		
	}
