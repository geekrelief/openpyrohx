package com.cimians.openPyro.controls.treeClasses;

	import com.cimians.openPyro.collections.XMLNodeDescriptor;
	import com.cimians.openPyro.controls.events.TreeEvent;
	import com.cimians.openPyro.controls.listClasses.DefaultListRenderer;
	import com.cimians.openPyro.layout.HLayout;
	import com.cimians.openPyro.painters.TrianglePainter;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	/*[Event(name="rotatorClick", type="com.cimians.openPyro.controls.events.TreeEvent")]*/

	class DefaultTreeItemRenderer extends DefaultListRenderer {
		
		/*[Embed(source="../../../../../assets/folder.png")]*/
		var folderIconClass:Class<Dynamic>;
		
		var rendererLayout:HLayout;

		public function new()
		{
			super();
            rendererLayout = new HLayout(5);
		}
		
		var folderIcon:Sprite; // this should be a skin
		var leafIcon:DisplayObject;
		var rotator:Sprite;
		var arrow:Sprite;
		
		override function createChildren():Void{
			super.createChildren();
		}
		
		public override function setData(value:Dynamic):Dynamic{
			if(_data != null && Std.is( _data, IEventDispatcher)){
				cast(_data, IEventDispatcher).removeEventListener(XMLNodeDescriptor.BRANCH_VISIBILITY_CHANGED, setRotatorDirection);
			}
			super.setData(value);
			
			if(Std.is( _data, IEventDispatcher)){
				cast(_data, IEventDispatcher).addEventListener(XMLNodeDescriptor.BRANCH_VISIBILITY_CHANGED, setRotatorDirection);
			}
			
			if(!cast(value, XMLNodeDescriptor).isLeaf()){
				if(folderIcon == null){
					folderIcon = new Sprite();//Type.createInstance(folderIconClass, []);
					var trianglePainter:TrianglePainter = new TrianglePainter(TrianglePainter.CENTERED);
					trianglePainter.draw(folderIcon.graphics, 8,8);
				}
				if(folderIcon.parent == null){
					addChild(folderIcon);
				}
				if(rotator == null){
					rotator = new Sprite();
					rotator.graphics.beginFill(0x000000,0);
					rotator.graphics.drawRect(0,0, 20,20);
					rotator.graphics.endFill();
					
					arrow = new Sprite();
					
					var trianglePainter:TrianglePainter = new TrianglePainter(TrianglePainter.CENTERED);
					trianglePainter.draw(arrow.graphics, 8,8);
					//rotator.addChild(arrow)
					addChild(arrow);
					arrow.cacheAsBitmap = true;
					
					rotator.buttonMode = true;
					rotator.useHandCursor = true;
					
					rotator.addEventListener(MouseEvent.CLICK, onRotatorClick);//,true,1,true)
					rotator.mouseChildren=false;
				}
				if(rotator.parent == null){
					addChild(rotator);
				}
			}
			else{
				if(folderIcon != null && folderIcon.parent != null){
					removeChild(folderIcon);
					folderIcon =  null;
				}
				if(rotator != null && rotator.parent != null){
					removeChild(rotator);
					rotator = null;
				}
				if(arrow != null && arrow.parent != null){
					removeChild(arrow);
					arrow = null;
				}
				
				
			}
			this.forceInvalidateDisplayList=true;
			this.invalidateDisplayList();
			return value;
		}
		
		function onRotatorClick(event:MouseEvent):Void{
			event.stopImmediatePropagation();
			event.preventDefault();
			var treeEvent:TreeEvent = new TreeEvent(TreeEvent.ROTATOR_CLICK);
			treeEvent.nodeDescriptor = cast(_data, XMLNodeDescriptor);
			dispatchEvent(treeEvent);
		}
		
		function setRotatorDirection(?event:Event=null):Void{
			
			if(rotator == null || rotator.parent == null) return;
			if(cast(_data, XMLNodeDescriptor).open){
				arrow.rotation = 90;
			}
			else{
				arrow.rotation = 0;
			}
		}
		
        public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(rotator != null && rotator.parent != null){
				rotator.y = (unscaledHeight-rotator.height)/2;
			}
			
			setRotatorDirection();
			
			rendererLayout.initX = cast(_data, XMLNodeDescriptor).depth*15+10;
			rendererLayout.initY = 5;
			var children:Array<Dynamic> = [];
			if(rotator != null && rotator.parent != null){
				children.push(rotator);
			}
			else{
				rendererLayout.initX+=10;
			}
			if(folderIcon != null && folderIcon.parent != null){
				children.push(folderIcon);
			}
			else{
				rendererLayout.initX+=10;
			}
			children.push(_labelField);
			
			if(arrow != null){
				arrow.x = rotator.x+ (rotator.width - arrow.width)/2+arrow.width/2;
				arrow.y =  rotator.y+ (rotator.height - arrow.height)/2+arrow.height/2;
			}
			
			rendererLayout.layout(children);
		}
	}
