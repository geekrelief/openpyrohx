package com.cimians.openPyro.managers;

	import com.cimians.openPyro.core.IDataRenderer;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.managers.toolTipClasses.DefaultToolTipRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	class TooltipManager
	 {
		
		
		
		var rendererInstance:DisplayObject;
		var _defaultRendererClass:Class<Dynamic> public function new() {
			
		
		_defaultRendererClass = DefaultToolTipRenderer

		;
		}
		
		public function showToolTip(event:MouseEvent, data:Dynamic, ?rendererClass:Class<Dynamic>=null):Void
		{
			if(!rendererClass){
				rendererClass = DefaultToolTipRenderer;
			}
			var stage:Stage = event.target.stage;
			if(!stage) return;
			if(!rendererInstance || getDefinitionByName(getQualifiedClassName(rendererInstance)) != rendererClass){
				rendererInstance =new rendererClass();
				stage.addChild(rendererInstance);
				if(Std.is( rendererInstance, UIControl)){
					UIControl(rendererInstance).validateSize()
					UIControl(rendererInstance).validateDisplayList()
				}
			}			
			else{
				rendererInstance.visible = true;
			}
			IDataRenderer(rendererInstance).data = data;
			
			rendererInstance.x = event.stageX+10
			rendererInstance.y = event.stageY+10
				
		}
		
		public function hideToolTip():Void
		{
			rendererInstance.visible = false;	
		}
		
		static var instance:TooltipManager;
		public static function getInstance():TooltipManager
		{
			if(!instance)
			{
				instance = new TooltipManager();
			}
			return instance;
		}	
	}
