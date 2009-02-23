package com.cimians.openPyro.core;
	
	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.utils.ArrayUtil;
	
	/**
	 * ObjectPools are used to reuse created objects
	 * rather than create new one every time one is needed.
	 */ 
	class ObjectPool {
		
		var availableObjects:Array<Dynamic>;
		var populatedObjects:Array<Dynamic>;
		var _classFactory:ClassFactory;
		
		public function new(classFactory:ClassFactory){
			_classFactory = classFactory;
			availableObjects = new Array();
			populatedObjects = new Array();
		}
		
		public function getObject():Dynamic{
			var r:Dynamic;
			if(availableObjects.length > 0){
				r = availableObjects.pop();
			}
			else{
				r = _classFactory.newInstance();
			}
			populatedObjects.push(r);
			return r;
		}
		
		public function hasReusableObject():Bool{
			return (availableObjects.length > 0);
		}
		
		public function returnToPool(r:Dynamic):Void{
			ArrayUtil.removeItemAt(populatedObjects, ArrayUtil.indexOf(populatedObjects, r));
			this.availableObjects.push(r);
		}
	}
