package com.cimians.openPyro.effects;

	import flash.display.DisplayObject;
	
	/**
	 * The EffectDescriptor class is an object that can be passed 
	 * to an Effect class to execute.Unlike Flex's effects which can 
	 * only operate on UIComponents and are therefore tied to
	 * them, OpenPyro effects are executed based on EffectDescriptors, 
	 * so are decoupled from the framework.
	 */ 
	
	class EffectDescriptor
	{
		
		public var target:DisplayObject;
		public var duration:Float;
		public var properties:Dynamic;
		
		public function new(?target:DisplayObject = null, ?duration:Float, ?properties:Dynamic = null )
		{
            if(duration == null){
                duration = Math.NaN;
            }
			this.target = target;
			this.duration = duration;
			this.properties = properties;
		}
	}
