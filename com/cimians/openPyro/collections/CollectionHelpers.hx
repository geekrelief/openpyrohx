package com.cimians.openPyro.collections;

	import com.cimians.openPyro.collections.ICollection;
	
	class CollectionHelpers
	 {
		public function new() { }
		
		public static function sourceToCollection(src:Dynamic):ICollection{
			if(Std.is( src, Array)){
				return new ArrayCollection(cast( src, Array));
			}
			else if(Std.is( src, XML)){
				return new XMLCollection(cast( src, XML))
			}
			else return ICollection(src);
			
		}
	}
