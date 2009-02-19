package com.cimians.openPyro.managers;

	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.managers.events.DragEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	class DragManager extends EventDispatcher {
		
		
		
		var dragProxy:Sprite;
		var dragInitiator:DisplayObject
		
		var mouseStartY:Int var mouseStartX:Int public function new() {
			
		
		mouseStartY = 0
		;
		mouseStartX = 0
		
		;
		}
		
		public function makeDraggable(object:DisplayObject, bounds:Rectangle):Void{
			if(!object.stage){
				throw new Error("DragTarget is not on stage")
			}
			dragInitiator = object;
			dragProxy = createDragProxy(object);
			if(Std.is( object.parent, UIControl)){
				UIControl(object.parent)._S_addChild(dragProxy);
			}
			else{
				object.parent.addChild(dragProxy)
			}
			dragProxy.x = object.x;
			dragProxy.y = object.y;
			
			dragProxy.startDrag(true, bounds);
			
			mouseStartY = object.stage.mouseY
			mouseStartX = object.stage.mouseX;
			object.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		static var instance:DragManager;
		public static function getInstance():DragManager{
			if(!instance){
				instance = new DragManager()
			}
			return instance;
		}
		
		function onMouseUp(event:MouseEvent):Void{
			if(!dragProxy) return;
			
			
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_COMPLETE);
			
			dragEvent.stageX = event.stageX;
			dragEvent.stageY = event.stageY;
			dragEvent.dragInitiator = dragInitiator;
			
			dragEvent.mouseXDelta = dragProxy.parent.stage.mouseX-mouseStartX;
			dragEvent.mouseYDelta = dragProxy.parent.stage.mouseY-mouseStartY;
			
			dragProxy.parent.removeChild(dragProxy);
			dragProxy = null;
			
			dispatchEvent(dragEvent);
		}
		
		
		public function createDragProxy(object:DisplayObject):Sprite{
			var data:BitmapData = new BitmapData(object.width, object.height)
			data.draw(object);
			var bmp:Bitmap = new Bitmap(data)
			var sp:Sprite = new Sprite();
			sp.addChild(bmp);
			sp.alpha = .5;
			return sp;
			
		}

	}
