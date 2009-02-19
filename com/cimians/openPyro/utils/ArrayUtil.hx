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
			if(idx<src.length){
				var spliced:Array<Dynamic> = src.splice(idx);
				src.push(data);
				for(i in 0...spliced.length){
					src.push(spliced[i]);
				}
			}
			else{
				src[idx] = (data)
			}
		}
		
		/**
		 * Removes the FIRST instance of the item passed in as a parameter
		 */ 
		public static function remove(src:Array<Dynamic>,item:Dynamic):Void{
			var index:Float = src.indexOf(item);
			if(index==-1){
				return;
				//throw new Error("Could not remove item from Array, item doesnt exist in the Array");
			}
			src.splice(index,1);
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
			return NaN;
		}
		
		/**
		 * Swaps the positions of two items if they are found in the 
		 * source array.
		 */ 
		public static function swapByValue(src:Array<Dynamic>, item1:Dynamic, item2:Dynamic):Void{
			var idx1:Float =src.indexOf(item1);
			var idx2:Float = src.indexOf(item2);
			swapByIndex(src, idx1, idx2);
		}
		
		public static function swapByIndex(src:Array<Dynamic>, idx1:Float, idx2:Float):Void{
			var temp:Dynamic = src[idx1];
			src[idx1] = src[idx2];
			src[idx2] = temp;
			
		}
		
		public static function createRepeatingArray(n:Float, v:Float):Array<Dynamic> {
			var result:Array<Dynamic> = new Array(n);
			for (var i:Int = 0; i<n; i++) result[i] = v;
			
			return result;
		}
		
		public static function createProgressiveArray(n:Float, s:Float, e:Float):Array<Dynamic> {
			var result:Array<Dynamic> = new Array(n);
			for (var i:Int = 0; i<n; i++) result[i] = s + i*(e-s)/(n-1);
			return result;
		}
		
		/**
		 * Inserts all the elements of the arrayToInsert Array into the sourceArray.
		 * The elements are inserted at the end of the sourceArray.
		 * 
		 * TODO: This isnt the most efficient way to do it. There is a way using splice or something.
		 */ 
		public static function insertArrayAtEnd(sourceArray:Array<Dynamic>, arrayToInsert:Array<Dynamic>):Array<Dynamic>{
			for (o in arrayToInsert){
				sourceArray.push(o);
			}
			return sourceArray;
		}
		
		public static function insertArrayAtIndex(sourceArray:Array<Dynamic>, arrayToInsert:Array<Dynamic>, idx:Int):Array<Dynamic>{
			var i:Int = arrayToInsert.length-1;
			while (i>=0){
				insertAt(sourceArray, idx, arrayToInsert[i])
				i--;
			}
			return sourceArray;
		}
		
		
		
		public static function removeItemAt(src:Array<Dynamic>, idx:UInt):Void{
			src.splice(idx,1);
		}
		
		public static function removeDuplicates(arr:Array<Dynamic>):Array<Dynamic>{
			var uniques:Array<Dynamic> = new Array()	
			var i:UInt = 0;
			while(i < arr.length){
				var searchElement:Dynamic = arr[i];
				if(uniques.indexOf(searchElement) != -1){
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
