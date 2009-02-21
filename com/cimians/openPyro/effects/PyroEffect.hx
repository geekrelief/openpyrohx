package com.cimians.openPyro.effects;

	//import gs.TweenMax;  // replace with FEffects
	
	class PyroEffect
	{
		
		public var effectDescriptors(getEffectDescriptors, setEffectDescriptors) : Array<Dynamic> ;
		/*[ArrayElementType("com.cimians.openPyro.effects.EffectDescriptor")]*/
		var _effDescriptors:Array<Dynamic>;
		
		public function new() {
			
		}
		
		public function setEffectDescriptors(effDescriptors:Array<Dynamic>):Array<Dynamic>
		{
			_effDescriptors = effDescriptors;
			return effDescriptors;
		}
		
		public function getEffectDescriptors():Array<Dynamic>
		{
			return _effDescriptors;
		}
		
		public function start():Void
		{
			for (descriptor in _effDescriptors)
			{
				//TweenMax.to(descriptor.target, descriptor.duration, descriptor.properties);
			}
		}
	}
