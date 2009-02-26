package com.cimians.openPyro.managers;

	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.core.MeasurableControl;
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
		var dragInitiator:DisplayObject;
		
		var mouseStartY:Float;
        var mouseStartX:Float;

        public function new() {
            super();
    		mouseStartY = 0;
    		mouseStartX = 0;
		}
		
		public function makeDraggable(object:DisplayObject, bounds:Rectangle):Void{
			if(object.stage == null){
				throw ("DragTarget is not on stage");
			}
			dragInitiator = object;
			dragProxy = createDragProxy(object);
			if(Std.is( object.parent, UIControl)){
				cast(object.parent, UIControl)._S_addChild(dragProxy);
			}
			else{
				object.parent.addChild(dragProxy);
			}
			dragProxy.x = object.x;
			dragProxy.y = object.y;
			
			dragProxy.startDrag(true, bounds);
			
			mouseStartY = object.stage.mouseY;
			mouseStartX = object.stage.mouseX;
			object.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		static var instance:DragManager;
		public static function getInstance():DragManager{
			if(instance == null){
				instance = new DragManager();
			}
			return instance;
		}
		
		function onMouseUp(event:MouseEvent):Void{
			if(dragProxy == null) return;
			
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
			var data:BitmapData;
            if(Std.is(object, MeasurableControl)) {
                data = new BitmapData(Std.int(cast(object, MeasurableControl).mwidth), Std.int(cast(object, MeasurableControl).height));
            } else { 
                data = new BitmapData(Std.int(object.width), Std.int(object.height));
            }
			data.draw(object);
			var bmp:Bitmap = new Bitmap(data);
			var sp:Sprite = new Sprite();
			sp.addChild(bmp);
			sp.alpha = .5;
			return sp;
			
		}

	}
