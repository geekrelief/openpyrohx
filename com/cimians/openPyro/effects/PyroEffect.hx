package com.cimians.openPyro.effects;

	import feffects.Tween;
	
	class PyroEffect
	{
		
		public var effectDescriptors(getEffectDescriptors, setEffectDescriptors) : Array<EffectDescriptor> ;

		var _effDescriptors:Array<EffectDescriptor>;
		
		public function new() {
			
		}
		
		public function setEffectDescriptors(effDescriptors:Array<EffectDescriptor>):Array<EffectDescriptor>
		{
			_effDescriptors = effDescriptors;
			return effDescriptors;
		}
		
		public function getEffectDescriptors():Array<EffectDescriptor>
		{
			return _effDescriptors;
		}
		
		public function start():Void
		{
			for (descriptor in _effDescriptors)
			{
                var field = Reflect.fields(descriptor.properties)[0];
                var tween = new Tween(  Reflect.field(descriptor.target, field), 
                                        Reflect.field(descriptor.properties, field), 
                                        descriptor.duration, 
                                        descriptor.target, 
                                        field, 
                                        descriptor.ease
                                     );
                tween.start();
			}
		}
	}
