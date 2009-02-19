package com.cimians.openPyro.containers;

	import com.cimians.openPyro.containers.events.DividerEvent;
	import com.cimians.openPyro.controls.skins.IDividedBoxSkin;
	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	/*[Event(name="dividerDoubleClick", type="com.cimians.openPyro.containers.events.DividerEvent" )]*/

	class DividedBox extends UIContainer {
		
		public var defaultDividerFactory(getDefaultDividerFactory, null) : ClassFactory;
		public var dividerFactory(getDividerFactory, setDividerFactory) : ClassFactory;
		public function new()
		{
			super();
		}
		
		var dividers:Array<Dynamic> ;
		
		
		var _dividerFactory:ClassFactory;
		public function setDividerFactory(f:ClassFactory):ClassFactory{
			_dividerFactory = f;
			return f;
		}
		public function getDividerFactory():ClassFactory{
			return _dividerFactory;
		}
		
		
		public override function addChild(child:DisplayObject):DisplayObject{
			if(contentPane.numChildren > 0){
				contentPane.addChild(getNewDivider())
			}
			return super.addChild(child);
		}
		
		public override function addChildAt(child:DisplayObject, index:Int):DisplayObject{
			if(contentPane.numChildren > 0){
				contentPane.addChild(getNewDivider())
			}
			return super.addChildAt(child, index);
		}
		
		
		function getNewDivider():DisplayObject{
			var divider:DisplayObject 
			if(this._skin){
				divider = IDividedBoxSkin(_skin).getNewDividerSkin();
			}
			else{
				if(!_dividerFactory){
					_dividerFactory = defaultDividerFactory;
				}
				divider = _dividerFactory.newInstance();
			}
			dividers.push(divider);
			InteractiveObject(divider).doubleClickEnabled = true;
			divider.addEventListener(MouseEvent.MOUSE_DOWN, onDividerMouseDown);
			divider.addEventListener(MouseEvent.CLICK, onDividerClick);	
			divider.addEventListener(MouseEvent.DOUBLE_CLICK, onDividerDoubleClick);	
			return divider;
		}
		
		function getDefaultDividerFactory():ClassFactory{
			throw new Error("Method needs overriding")
			return new ClassFactory();
			/// override
		}
		
		function onDividerMouseDown(event:MouseEvent):Void{
			throw new Error("DividerMouseDown needs overriding")
		}
		
		function onDividerDoubleClick(event:MouseEvent):Void{
			var evt:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_DOUBLE_CLICK)
			evt.divider = cast( event.currentTarget, DisplayObject);
			evt.dividerIndex = dividers.indexOf(event.currentTarget);
			dispatchEvent(evt);
		}
		
		function onDividerClick(event:MouseEvent):Void{
			var evt:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_CLICK)
			evt.divider = cast( event.currentTarget, DisplayObject);
			evt.dividerIndex = dividers.indexOf(event.currentTarget);
			dispatchEvent(evt);
		}
		
		/*
		 Removes the child required and also the previous divider or the next one if one 
		 was created 
		 */ 
		public override function removeChild(child:DisplayObject):DisplayObject{
			
			var prevDivider:DisplayObject;
			for(i in 0...contentPane.numChildren){
				var uiObject:DisplayObject = contentPane.getChildAt(i)
				if(dividers.indexOf(uiObject)!=-1){
					prevDivider = uiObject
					continue
				}
				if(uiObject == child){
					if(!prevDivider){
						if(i < this.contentPane.numChildren-1){
							prevDivider = contentPane.getChildAt(i+1);
						}
					}
					break;
				}
			}
			
			if(prevDivider){
				contentPane.removeChild(prevDivider);
			}
			return super.removeChild(child);
		}
	}
