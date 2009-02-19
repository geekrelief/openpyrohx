package com.cimians.openPyro.controls;

	import com.cimians.openPyro.collections.CollectionHelpers;
	import com.cimians.openPyro.collections.ICollection;
	import com.cimians.openPyro.collections.IIterator;
	import com.cimians.openPyro.collections.events.CollectionEvent;
	import com.cimians.openPyro.collections.events.CollectionEventKind;
	import com.cimians.openPyro.collections.events.IteratorEvent;
	import com.cimians.openPyro.controls.events.ListEvent;
	import com.cimians.openPyro.controls.listClasses.BaseListData;
	import com.cimians.openPyro.controls.listClasses.DefaultListRenderer;
	import com.cimians.openPyro.controls.listClasses.IListDataRenderer;
	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.core.IDataRenderer;
	import com.cimians.openPyro.core.ObjectPool;
	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.layout.VLayout;
	import com.cimians.openPyro.utils.ArrayUtil;
	import com.cimians.openPyro.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/*[Event(name="change", type="com.cimians.openPyro.controls.events.ListEvent")]*/
	/*[Event(name="itemClick", type="com.cimians.openPyro.controls.events.ListEvent")]*/
	
	class List extends UIContainer {
		
		/**
		 * Resets scrolls when the dataProvider changes
		 */ 
		
		
		public var dataProvider(getDataProvider, setDataProvider) : Dynamic;
		
		public var itemRenderer(null, setItemRenderer) : ClassFactory;
		
		public var labelFunction(getLabelFunction, setLabelFunction) : Dynamic;
		
		public var layoutChildren(getLayoutChildren, null) : Array<Dynamic>;
		
		public var originalRawDataProvider(getOriginalRawDataProvider, null) : Dynamic;
		
		public var selectedIndex(getSelectedIndex, setSelectedIndex) : Int
		;
		
		public var selectedItem(getSelectedItem, setSelectedItem) : Dynamic;
		
		/**
		 * Resets scrolls when the dataProvider changes
		 */ 
		public var autoResetScrollOnDataProviderChange:Bool public function new()
		{
			
			autoResetScrollOnDataProviderChange = true
		
		
		;
			super();
			this._labelFunction = StringUtil.toStringLabel
			_layout = new VLayout();
		}
		
		var _labelFunction:Dynamic  public function setLabelFunction(func:Dynamic):Dynamic{
			_labelFunction = func;
			/*
			 * TODO: Change label functions on all itemRenderers
			 */	
			return func;
		}
		
		public function getLabelFunction():Dynamic{
			return _labelFunction;
		}
		
		
		override function createChildren():Void
		{
			if(!this._rendererPool){
				var cf:ClassFactory = new ClassFactory(DefaultListRenderer);
				cf.properties = {percentWidth:100, height:25};
				_rendererPool = new ObjectPool(cf)
			}
		}
		
		var renderers:Array<Dynamic> ;
		var _rendererPool:ObjectPool;
		var selectedRenderer:DisplayObject;
		
		var _dataProvider:ICollection;
		var _originalRawDataProvider:Dynamic;
		
		public function setDataProvider(dp:Dynamic):Dynamic{
			if(dp == _originalRawDataProvider){
				return;
			}
			_originalRawDataProvider =dp
			if(autoResetScrollOnDataProviderChange){
				verticalScrollPosition = 0
				horizontalScrollPosition=0
			}
			if(_dataProvider){
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGED, onSourceCollectionChanged);
				_dataProvider.iterator.addEventListener(IteratorEvent.ITERATOR_MOVED, onIteratorMoved);
			}
			convertDataToCollection(dp)
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGED, onSourceCollectionChanged);
			_dataProvider.iterator.addEventListener(IteratorEvent.ITERATOR_MOVED, onIteratorMoved);
			createRenderers()
			return dp;
		}
		
		public function getOriginalRawDataProvider():Dynamic{
			return _originalRawDataProvider;
		}
		
		function createRenderers():Void{
			if(!_rendererPool) return;
			returnRenderersToPool()
			var renderer:DisplayObject;
			
			var iterator:IIterator = _dataProvider.iterator;
			iterator.reset();
			
			while(iterator.hasNext())
			{
				var listData:Dynamic = iterator.getNext();
				renderer = DisplayObject(_rendererPool.getObject());
				setRendererData(renderer, listData, iterator.cursorIndex);
				renderers.push(renderer);
				contentPane.addChildAt(renderer,0);
				
			}
			// reset the iterator to -1
			iterator.reset()
			
			displayListInvalidated = true;
			this.forceInvalidateDisplayList = true;
			this.invalidateSize();
			this.invalidateDisplayList();
			_selectedIndex = -1;
		}
		
		public function getDataProvider():Dynamic{
			return _dataProvider;
		}
		
		/**
		 * Converts an Array to ArrayCollection or xml to 
		 * XMLCollection. Written as a separate function so 
		 * that overriding classes may massage the data as 
		 * needed
		 */ 
		function convertDataToCollection(dp:Dynamic):Void{
			this._dataProvider = CollectionHelpers.sourceToCollection(dp);
		}
		
		function onSourceCollectionChanged(event:CollectionEvent):Void{
		
			if(event.kind == CollectionEventKind.REMOVE){
				handleDataProviderItemsRemoved(event)
			}
			
			else if(event.kind == CollectionEventKind.ADD){
				handDataProviderItemsAdded(event)
			}
			else if(event.kind == CollectionEventKind.RESET){
				createRenderers();	
			}
			
			this.displayListInvalidated = true
			this.layoutInvalidated = true;
			this.invalidateSize()
		}
		
		function onIteratorMoved(event:IteratorEvent):Void{
			var data:Dynamic = _dataProvider.iterator.getCurrent();
			var renderer:DisplayObject = dataToItemRenderer(data);
			if(Std.is( renderer, IListDataRenderer)){
				IListDataRenderer(renderer).selected = true;
			}
			selectedRenderer = renderer;
			dispatchEvent(new ListEvent(ListEvent.CHANGE));
		}
		
		function handleDataProviderItemsRemoved(event:CollectionEvent):Void
		{
			var childNodesData:Array<Dynamic> = event.delta;
			
			var renderer:DisplayObject
			for(i in 0...childNodesData.length){
					renderer = dataToItemRenderer(childNodesData[i]);
					if(renderer && renderer.parent){
						renderer.parent.removeChild(renderer);
						ArrayUtil.remove(renderers, renderer);
					}
				}
		}
		
		function handDataProviderItemsAdded(event:CollectionEvent):Void
		{
			var childNodesData:Array<Dynamic> = event.delta;
			var renderer:DisplayObject
			var eventSourceData:Dynamic = event.eventNode;
			var parentNode:DisplayObject
			
			
			//trace(XMLNodeDescriptor(eventSourceData).nodeString);	
			for(j in 0...renderers.length){
				var r:DisplayObject = renderers[j];
			
				if(IDataRenderer(r).data == eventSourceData){
					parentNode = r;
					var positionRefNode:DisplayObject = parentNode;
					var k:Int=childNodesData.length-1;
					while (k>=0){
						var newRenderer:DisplayObject = cast( _rendererPool.getObject(), DisplayObject);
						var listData:Dynamic = childNodesData[k]
						setRendererData(newRenderer, listData, k);
						this.contentPane.addChildAt(newRenderer,0);
						newRenderer.y = positionRefNode.y - newRenderer.height;
						positionRefNode = newRenderer;
						ArrayUtil.insertAt(renderers, (j+1), newRenderer);	
						k--;
					}
					break;
				}
			}			
		}
		
		function returnRenderersToPool():Void{
			var renderer:DisplayObject
			while(renderers.length > 0)
			{
				renderer = renderers.shift();
				if(renderer.parent)
				{
					renderer.parent.removeChild(renderer);
				}
				_rendererPool.returnToPool(renderer);
			}
		}
		
		function setRendererData(renderer:DisplayObject, data:Dynamic, index:Int):Void
		{
			if(Std.is( renderer, IListDataRenderer)){
				var baseListData:BaseListData = new BaseListData()
				baseListData.list = this;
				baseListData.rowIndex = index;
				
				IListDataRenderer(renderer).baseListData = baseListData;
				IListDataRenderer(renderer).data = data;
			
			}
			renderer.addEventListener(MouseEvent.CLICK, handleRendererClick);
		}
		
		
		function handleRendererClick(event:MouseEvent):Void
		{
				// dont react if the click is coming from a currently 
				// selected child.
				if(IListDataRenderer(event.currentTarget).selected) return;
				
				
				if(selectedRenderer && Std.is( selectedRenderer, IListDataRenderer)){
					IListDataRenderer(selectedRenderer).selected = false;
				}
				var newIndex:Int = itemRendererToIndex(cast( event.currentTarget, DisplayObject));
				if(newIndex != selectedIndex){
					selectedIndex = newIndex;
					selectedRenderer = cast( event.currentTarget, DisplayObject);
					if(Std.is( selectedRenderer, IListDataRenderer)){
						IListDataRenderer(selectedRenderer).selected = true;
					}
				}
				
				dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK));
		}
		
		
		public function dataToItemRendererIndex(data:Dynamic):Int
		{
			for(i in 0...renderers.length){
				if(IDataRenderer(renderers[i]).data == data){
					return i
				}
			}
			return -1;
		}
		
		public function dataToItemRenderer(data:Dynamic):DisplayObject{
			for(i in 0...renderers.length){
				if(IDataRenderer(renderers[i]).data == data){
					return renderers[i]
				}
			}
			return null;
		}
		
		public function itemRendererToIndex(renderer:DisplayObject):Int
		{
			var data:Dynamic = IDataRenderer(renderer).data;
			return _dataProvider.getItemIndex(data);
		}
		
		
		var _selectedItem:Dynamic;
		
		public function getSelectedItem():Dynamic{
			if(_selectedIndex == -1){
				return null;
			}
			return IDataRenderer(renderers[_selectedIndex]).data;
		}
		
		public function setSelectedItem(item:Dynamic):Dynamic{
			// TODO: 
			// right now i am assuming all data is rendererd 
			// This will change when object pool is connected
			// to the renderers.
			
			
			if(!renderers || renderers.length == 0)
			{
				throw new Error("LIST does not have renderers")
				return;
			}
			for(i in 0...renderers.length)
			{
				if (item == IDataRenderer(renderers[i]).data)
				{
					if(Std.is( renderers[i], IListDataRenderer))
					{
						IListDataRenderer(renderers[i]).selected = true;
					}
					return;
				}
			}
			
			throw new Error("Selected item not found in List data");
			return item;
			// TODO: 
			// right now i am assuming all data is rendererd 
			// This will change when object pool is connected
			// to the renderers.
			
			
		}
		
		var _selectedIndex:Int ;
		
		public function setSelectedIndex(index:Int):Int
		{
			if(_selectedIndex == index) return;
			if(this.selectedRenderer && Std.is( this.selectedRenderer, IListDataRenderer)){
				IListDataRenderer(selectedRenderer).selected = false;
			}
			
			_selectedIndex = index;
			if(_dataProvider){
				//selectedItem = _dataProvider[index];
				_dataProvider.iterator.cursorIndex = index;
			}
			return index;
		}
		
		public function getSelectedIndex():Int
		{
			return _selectedIndex;
		}
		
		public function setItemRenderer(itemRenderer:ClassFactory):ClassFactory{
			destroyOldRenderers();
			
			_rendererPool = new ObjectPool(itemRenderer);
			
			renderers = new Array();
			var renderer:DisplayObject
			if(_dataProvider)
			{
				for(j in 0..._dataProvider.length)
				{
					renderer = DisplayObject(_rendererPool.getObject());
					renderers.push(renderer);
					contentPane.addChildAt(renderer,0);
					setRendererData(renderer,j, j)
				}		
			}
			this.displayListInvalidated = true;
			this.invalidateSize();
			this.invalidateDisplayList();
			return itemRenderer;
		}
		
		function destroyOldRenderers():Void{
			var renderer:DisplayObject
			if(renderers){
				while(renderers.length > 0){
					renderer = renderers.shift();
					if(renderer.parent){
						renderer.parent.removeChild(renderer);
						renderer = null;
					}
				}
			}
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
			
		public override function getLayoutChildren():Array<Dynamic>{
			return this.renderers;
		}
		
		
		
	}
