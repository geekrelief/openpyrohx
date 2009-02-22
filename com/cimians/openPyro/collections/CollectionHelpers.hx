package com.cimians.openPyro.collections;

	import com.cimians.openPyro.collections.ICollection;
	
	class CollectionHelpers
    {
		public function new() { }
		
		public static function sourceToCollection(src:Dynamic):ICollection{
			if(Std.is( src, Array)){
				return new ArrayCollection(cast(src, Array<Dynamic>));
			} else if(Std.is(src, Xml)){
				var x = new XMLCollection(cast( src, Xml));
                return x;
			}
			else {
                return cast(src, ICollection);
            }
		}
	}
