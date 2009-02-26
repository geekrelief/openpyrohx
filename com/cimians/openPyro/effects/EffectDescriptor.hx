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
		public var duration:Int;
		public var properties:Dynamic;
        public var ease:Float->Float->Float->Float->Float;
		
		public function new(?target:DisplayObject = null, ?duration:Float, ?ease:Dynamic = null, ?properties:Dynamic = null )
		{
			this.target = target;
			this.duration = Math.round(duration * 1000);
			this.properties = properties;
            this.ease = cast ease;
		}
	}
