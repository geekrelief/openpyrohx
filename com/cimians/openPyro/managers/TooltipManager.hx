package com.cimians.openPyro.managers;

	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.IDataRenderer;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.managers.toolTipClasses.DefaultToolTipRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	class TooltipManager
    {
		
		var rendererInstance:DisplayObject;
		var _defaultRendererClass:Class<Dynamic>;
        
        public function new() {
    		_defaultRendererClass = DefaultToolTipRenderer;
		}
		
		public function showToolTip(event:MouseEvent, data:Dynamic, ?rendererClass:Class<Dynamic>=null):Void
		{
			if(rendererClass == null){
				rendererClass = DefaultToolTipRenderer;
			}
			var stage:Stage = event.target.stage;
			if(stage == null) return;
			if(rendererInstance == null || Type.getClass(rendererInstance) != rendererClass){
				rendererInstance = Type.createInstance(rendererClass, []);
				stage.addChild(rendererInstance);
				if(Std.is( rendererInstance, UIControl)){
					cast(rendererInstance, UIControl).validateSize();
					cast(rendererInstance, UIControl).validateDisplayList();
				}
			}			
			else{
                if(Std.is( rendererInstance, MeasurableControl)) {
				    cast(rendererInstance, MeasurableControl).mvisible = true;
                } else {
    				rendererInstance.visible = true;
                }
			}
			cast(rendererInstance, IDataRenderer).data = data;
			
			rendererInstance.x = event.stageX+10;
			rendererInstance.y = event.stageY+10;
		}
		
		public function hideToolTip():Void
		{
            if(Std.is(rendererInstance, MeasurableControl)) {
			    cast(rendererInstance, MeasurableControl).mvisible = false;	
            } else {
    			rendererInstance.visible = false;	
            }
		}
		
		static var instance:TooltipManager;
		public static function getInstance():TooltipManager
		{
			if(instance == null)
			{
				instance = new TooltipManager();
			}
			return instance;
		}	
	}
