package com.cimians.openPyro.utils;
	class ArrayUtil {
		
		/**
		 * Inserts the data at the specified index of the array.
		 * The operation is carried out on the source array and not
		 * on a copy.
		 * 
		 * @param	src		The source Array
		 * @param	idx		The index at which data needs to be inserted.
		 * 					The index can be greater than the length of the 
		 * 					array, in which case, all intermediate values are
		 * 					initialized to undefined.
		 * @param	data 	The data to be inserted into the Array.
		 * 
		 * @example   <listing version="3.0" > 
		 * 				var a:Array = [0,1,2,3,4,5]
		 * 				ArrayUtil.insertAt(a, 2, "inserted");
		 * 				trace(a) //[0,1,inserted,2,3,4,5]
		 * 			 </listing>
		 */ 
		public function new() { }
		
		
		/**
		 * Inserts the data at the specified index of the array.
		 * The operation is carried out on the source array and not
		 * on a copy.
		 * 
		 * @param	src		The source Array
		 * @param	idx		The index at which data needs to be inserted.
		 * 					The index can be greater than the length of the 
		 * 					array, in which case, all intermediate values are
		 * 					initialized to undefined.
		 * @param	data 	The data to be inserted into the Array.
		 * 
		 * @example   <listing version="3.0" > 
		 * 				var a:Array = [0,1,2,3,4,5]
		 * 				ArrayUtil.insertAt(a, 2, "inserted");
		 * 				trace(a) //[0,1,inserted,2,3,4,5]
		 * 			 </listing>
		 */ 
		public static function insertAt(src:Array<Dynamic>, idx:Float, data:Dynamic):Void{
            var dx = Std.int(idx);
			if(dx < src.length){
                src.insert(dx, data);
			} else {
				src[dx] = data;
			}
		}
		
		/**
		 * Removes the FIRST instance of the item passed in as a parameter
		 */ 
		public static function remove(src:Array<Dynamic>,item:Dynamic):Void{
            src.remove(item);
		}
		
		
		/**
		 * Returns the index number of an item in the array if that
		 * item exists. Else NaN is returned
		 * 
		 * @deprecated Use Array.indexOf() which is native to the Flash player
		 * as of AS3
		 */ 
		public static function getItemIndex(src:Array<Dynamic>, item:Dynamic):Float{
			for(i in 0...src.length){
				if(src[i]== item){
					return i;
				}
			}
			return Math.NaN;
		}

        public static function indexOf(src:Array<Dynamic>, item:Dynamic): Int {
            for(i in 0...src.length){
                if( src[i] == item)
                    return i;
            }
            return -1;
        }
	
		/**
		 * Swaps the positions of two items if they are found in the 
		 * source array.
		 */ 
		public static function swapByValue(src:Array<Dynamic>, item1:Dynamic, item2:Dynamic):Void{
			var idx1:Float = ArrayUtil.indexOf(src, item1);
			var idx2:Float = ArrayUtil.indexOf(src, item2);
			swapByIndex(src, idx1, idx2);
		}
		
		public static function swapByIndex(src:Array<Dynamic>, idx1:Float, idx2:Float):Void{
            var dx1 = Std.int(idx1);
            var dx2 = Std.int(idx2);
			var temp:Dynamic = src[dx1];
			src[dx1] = src[dx2];
			src[dx2] = temp;
			
		}
		
		public static function createRepeatingArray(n:Float, v:Dynamic):Array<Dynamic> {
			var result:Array<Dynamic> = new Array();
			for (i in 0...Std.int(n)) result[i] = v;
			
			return result;
		}
		
		public static function createProgressiveArray(n:Float, s:Dynamic, e:Dynamic):Array<Dynamic> {
			var result:Array<Dynamic> = new Array();
            var floor:Bool = false;
            if(Std.is(s, Int)) { floor = true; }
			for (i in 0...Std.int(n)){
                var val = s + i*(e-s)/(n-1);
                if(floor)
                    result[i] = Std.int(val);
                else
                    result[i] = val;
            }
			return result;
		}
		
		/**
		 * Inserts all the elements of the arrayToInsert Array into the sourceArray.
		 * The elements are inserted at the end of the sourceArray.
		 * 
		 * TODO: This isnt the most efficient way to do it. There is a way using splice or something.
		 */ 
		public static function insertArrayAtEnd(sourceArray:Array<Dynamic>, arrayToInsert:Array<Dynamic>):Array<Dynamic>{
            return sourceArray.concat(arrayToInsert);
		}
		
		public static function insertArrayAtIndex(sourceArray:Array<Dynamic>, arrayToInsert:Array<Dynamic>, idx:Int):Array<Dynamic>{
			var i:Int = arrayToInsert.length-1;
			while (i>=0){
				insertAt(sourceArray, idx, arrayToInsert[i]);
				i--;
			}
			return sourceArray;
		}
		
		
		
		public static function removeItemAt(src:Array<Dynamic>, idx:UInt):Void{
			src.splice(idx,1);
		}
		
		public static function removeDuplicates(arr:Array<Dynamic>):Array<Dynamic>{
			var uniques:Array<Dynamic> = new Array();
			var i:UInt = 0;
			while(i < arr.length){
				var searchElement:Dynamic = arr[i];
				if(ArrayUtil.indexOf(uniques, searchElement) != -1){
					removeItemAt(arr, i);
				}
				else{
					uniques.push(searchElement);
					i++;
				}
			}
			return arr;
		}
		
	}
