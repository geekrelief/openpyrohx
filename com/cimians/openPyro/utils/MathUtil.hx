package com.cimians.openPyro.utils;

	class MathUtil
	 {
		/**
		 * Inserts a comma after every 3rd character when counted from reverse
		 * 
		 * useage: getCommaSeparatedString(12345) returns 12,345
		 */  
		public static function getCommaSeparatedString(n:Float):String{
			var numString:String = Std.string(n);
			var returnString:Array<Dynamic> = new Array();
			var i:Int = numString.length-1;
            var count:Int=1;

			while (i>=0){
				returnString.push(numString.charAt(i));
				if(count%3==0 && i != 0){
					returnString.push(",");
				}
				i--; 
                count++;
			}
			returnString.reverse();
			return returnString.join('');
		}
		
		/**
		 * @param	deg		The degree value whose radian equivalent is required
		 * @return 			The radian equivalent of the input parameter
		 */ 
		public static function degreeToRadians(deg:Float):Float{
			return Math.PI*deg/180;
		}
		
		public static function radiansToDegrees(rad:Float):Float{
			return 180*rad/Math.PI;
		}
		
		public static function randRange(start:Float, end:Float) : Float{
			return Math.floor(start +(Math.random() * (end - start)));
		}
	}
