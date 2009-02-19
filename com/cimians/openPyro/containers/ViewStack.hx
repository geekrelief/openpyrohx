package com.cimians.openPyro.containers;

	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.utils.ArrayUtil;
	
	import flash.display.DisplayObject;

	class ViewStack extends UIContainer {
		
		
		
		public var selectedChild(getSelectedChild, setSelectedChild) : UIContainer
		;
		
		public var selectedIndex(getSelectedIndex, setSelectedIndex) : Int
		;
		
		/*[ArrayElementType("com.cimians.openPyro.core.UIContainer")]*/
		var viewChildren:Array<Dynamic>;
		
		/**
		 * The viewstack manages multiple the visibility of
		 * multiple UIContainers that are added to it.
		 */ 
		public function new(){
			super();
			this._horizontalScrollPolicy = false;
			this._verticalScrollPolicy = false;
			viewChildren = new Array();
		}
		
		var viewsChanged:Bool ;
		
		var _selectedIndex:Int ;
		public function setSelectedIndex(idx:Int):Int
		{
			if(_selectedIndex == idx) return;
			_selectedIndex = idx;
			this._selectedChild = viewChildren[_selectedIndex];
			viewsChanged = true;
			if(this.initialized){
				invalidateDisplayList();
			}
			return idx;
		}
		
		public function getSelectedIndex():Int
		{
			return _selectedIndex
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			if(!(Std.is( child, UIContainer)))
			{
				throw new Error("ViewStacks can only hold UIContainers");
				return;
			}
			this.viewChildren.push(child);
			_selectedChild = UIContainer(child);
			_selectedIndex++;
			viewsChanged = true
			return super.addChild(child);
		}
		
		public override function addChildAt(child:DisplayObject, index:Int):DisplayObject
		{
			if(!(Std.is( child, UIContainer)))
			{
				throw new Error("ViewStacks can only hold UIContainers");
				return;
			}
			ArrayUtil.insertAt(viewChildren, index, child);
			_selectedChild = viewChildren[viewChildren.length-1]
			_selectedIndex++;
			viewsChanged = true
			return super.addChildAt(child, index);
		}
		
		var _selectedChild:UIContainer ;
		public function setSelectedChild(child:UIContainer):UIContainer
		{
			if(_selectedChild == child) return;
			
			for(i in 0...viewChildren.length)
			{
				var container:UIContainer = viewChildren[i];
				if(container == child)
				{
					this.selectedIndex = i;
				}
			}
			return child;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			if(viewChildren.indexOf(child) != -1){
				ArrayUtil.remove(viewChildren, child);
			}
			if(_selectedChild == child){
				// set the topmost child as the visible child
				_selectedIndex = viewChildren.length-1;	
			}
			return super.removeChild(child);
		}
		
		public function getSelectedChild():UIContainer
		{
			return _selectedChild;
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(viewsChanged){
				viewsChanged = false;
				showSelectedChild()
			}
		}
		
		function showSelectedChild():Void
		{
			for(i in 0...viewChildren.length){
				var child:DisplayObject = DisplayObject(viewChildren[i]);
				child.visible = (i == _selectedIndex)?true:false;
			}
		}
		
	}
