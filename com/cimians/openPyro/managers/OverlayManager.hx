package com.cimians.openPyro.managers;

    import com.cimians.openPyro.core.MeasurableControl;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	class OverlayManager
    {
		
		public var overlayContainer(getOverlayContainer, setOverlayContainer) : DisplayObjectContainer;

		public function new() { }
		
		var _overlayDisplayObject:DisplayObjectContainer;
		
		/**
		 * The overlay layer on which the popups are 
		 * rendered
		 */ 
		public function setOverlayContainer(dp:DisplayObjectContainer):DisplayObjectContainer{
			_overlayDisplayObject = dp;
			return dp;
		}
		
		public function getOverlayContainer():DisplayObjectContainer{
			return _overlayDisplayObject;
		}
		
		static var instance:OverlayManager;
		public static function getInstance():OverlayManager{
			if(instance == null){
				instance = new OverlayManager();
			}
			return instance;
		}
		
		
		var bgSprite:Sprite;
		var centeredPopup:DisplayObject;
		
		public function showPopUp(popupObject:DisplayObject, ?modal:Bool=false, ?center:Bool=true):Void{
			if(_overlayDisplayObject == null){
				throw ("No overlay displayObject defined on which to draw");
			}
			if(modal){
				bgSprite = new Sprite();
				bgSprite.graphics.beginFill(0x00000, .5);
				bgSprite.graphics.drawRect(0,0,_overlayDisplayObject.stage.stageWidth, _overlayDisplayObject.stage.stageHeight);
				_overlayDisplayObject.addChild(bgSprite);
				_overlayDisplayObject.stage.addEventListener(Event.RESIZE, onBaseStageResize);
				// capture mouse interactions here.
			}
			
			_overlayDisplayObject.addChild(popupObject);
			if(center){
				centeredPopup = popupObject;
                if(Std.is(popupObject, MeasurableControl)) {
				    popupObject.x = (_overlayDisplayObject.stage.stageWidth-cast(popupObject, MeasurableControl).mwidth)/2;
    				popupObject.y = (_overlayDisplayObject.stage.stageHeight-cast(popupObject, MeasurableControl).mheight)/2;
                } else {
				    popupObject.x = (_overlayDisplayObject.stage.stageWidth-popupObject.width)/2;
    				popupObject.y = (_overlayDisplayObject.stage.stageHeight-popupObject.height)/2;
                }
			}
			
		}
		
		public function showOnOverlay(object:DisplayObject, ?target:DisplayObject=null):Void{
			_overlayDisplayObject.addChild(object);
			if(target != null){
				var orig:Point = new Point(0,0);
				var pt:Point = target.localToGlobal(orig);
				pt = _overlayDisplayObject.globalToLocal(pt);
				//trace(pt.x, pt.y);
				object.x = pt.x;
				object.y = pt.y;
			}
			
		}
		
		
		function onBaseStageResize(event:Event):Void{
			if(bgSprite != null){
				bgSprite.width = _overlayDisplayObject.stage.stageWidth;
				bgSprite.height = _overlayDisplayObject.stage.stageHeight;
			}
			if(centeredPopup != null){
                if(Std.is(centeredPopup, MeasurableControl)) {
				    centeredPopup.x = (_overlayDisplayObject.stage.stageWidth-cast(centeredPopup, MeasurableControl).mwidth)/2;
                    centeredPopup.y = (_overlayDisplayObject.stage.stageHeight-cast(centeredPopup, MeasurableControl).mheight)/2;
                } else {
                    centeredPopup.x = (_overlayDisplayObject.stage.stageWidth-centeredPopup.width)/2;
                    centeredPopup.y = (_overlayDisplayObject.stage.stageHeight-centeredPopup.height)/2;
                }
			}
		}
	}
