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
		
		
		
		public var data(null, setData) : Dynamic;
		
		/*[Embed(source="../../../../../assets/folder.png")]*/
		var folderIconClass:Class<Dynamic>
		
		public function new()
		{
			super();
		}
		
		var folderIcon:DisplayObject;
		var leafIcon:DisplayObject;
		var rotator:Sprite;
		var arrow:Sprite;
		
		override function createChildren():Void{
			super.createChildren()
		}
		
		public override function setData(value:Dynamic):Dynamic{
			if(_data && Std.is( _data, IEventDispatcher)){
				IEventDispatcher(_data).removeEventListener(XMLNodeDescriptor.BRANCH_VISIBILITY_CHANGED, setRotatorDirection);
			}
			super.data = value;
			
			if(Std.is( _data, IEventDispatcher)){
				IEventDispatcher(_data).addEventListener(XMLNodeDescriptor.BRANCH_VISIBILITY_CHANGED, setRotatorDirection);
			}
			
			if(!XMLNodeDescriptor(value).isLeaf()){
				if(!folderIcon){
					folderIcon = new folderIconClass();
				}
				if(!folderIcon.parent){
					addChild(folderIcon);
				}
				if(!rotator){
					rotator = new Sprite();
					rotator.graphics.beginFill(0x000000,0)
					rotator.graphics.drawRect(0,0, 20,20);
					rotator.graphics.endFill()
					
					
					arrow = new Sprite();
					
					var trianglePainter:TrianglePainter = new TrianglePainter(TrianglePainter.CENTERED);
					trianglePainter.draw(arrow.graphics, 8,8)
					//rotator.addChild(arrow)
					addChild(arrow)
					arrow.cacheAsBitmap = true;
					
					rotator.buttonMode = true;
					rotator.useHandCursor = true
					
					rotator.addEventListener(MouseEvent.CLICK, onRotatorClick)//,true,1,true)
					rotator.mouseChildren=false;
				}
				if(!rotator.parent){
					addChild(rotator);
				}
			}
			else{
				if(folderIcon && folderIcon.parent){
					removeChild(folderIcon);
					folderIcon =  null;
				}
				if(rotator && rotator.parent){
					removeChild(rotator);
					rotator = null
				}
				if(arrow && arrow.parent){
					removeChild(arrow);
					arrow = null
				}
				
				
			}
			this.forceInvalidateDisplayList=true
			this.invalidateDisplayList()
			return value;
		}
		
		function onRotatorClick(event:MouseEvent):Void{
			event.stopImmediatePropagation()
			event.preventDefault();
			var treeEvent:TreeEvent = new TreeEvent(TreeEvent.ROTATOR_CLICK);
			treeEvent.nodeDescriptor = XMLNodeDescriptor(_data);
			dispatchEvent(treeEvent);
		}
		
		function setRotatorDirection(?event:Event=null):Void{
			
			if(!rotator || !rotator.parent) return;
			if(XMLNodeDescriptor(_data).open){
				arrow.rotation = 90
			}
			else{
				arrow.rotation = 0
			}
		}
		
		var rendererLayout:HLayout public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(rotator && rotator.parent){
				rotator.y = (unscaledHeight-rotator.height)/2
			}
			
			setRotatorDirection()
			
			rendererLayout.initX = XMLNodeDescriptor(_data).depth*15+10
			rendererLayout.initY = 5;
			var children:Array<Dynamic> = []
			if(rotator && rotator.parent){
				children.push(rotator)
			}
			else{
				rendererLayout.initX+=10;
			}
			if(folderIcon && folderIcon.parent){
				children.push(folderIcon)
			}
			else{
				rendererLayout.initX+=10
			}
			children.push(_labelField);
			
			if(arrow){
				arrow.x = rotator.x+ (rotator.width - arrow.width)/2+arrow.width/2
				arrow.y =  rotator.y+ (rotator.height - arrow.height)/2+arrow.height/2;
				
			}
			
			
			rendererLayout.layout(children);
		}
	}
