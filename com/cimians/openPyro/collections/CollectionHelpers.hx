package com.cimians.openPyro.collections;

	import com.cimians.openPyro.collections.ICollection;
	
	class CollectionHelpers
    {
		public static function sourceToCollection(src:Dynamic):ICollection{
			if(Std.is( src, Array)){
				return new ArrayCollection(src);
			} else if(Std.is(src, Xml)){
				var x = new XMLCollection(src);
                return x;
			} else {
                return cast(src, ICollection);
            }
		}
	}
