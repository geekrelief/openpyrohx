package com.cimians.openPyro.utils;
	import flash.text.TextField;
	
	
	class StringUtil {
		/** 
		 * Check to see if the String is an empty string with one or more 
		 * whitespace characters or null. 
		 * Checks even for \n and \t values
		 */
		public function new() { }
		
		/** 
		 * Check to see if the String is an empty string with one or more 
		 * whitespace characters or null. 
		 * Checks even for \n and \t values
		 */
		public static function isEmptyOrNull(str:String):Bool{
			var pattern:EReg = ~/^\s+_S_/;
	      	return pattern.test(str) == true ? true : str == "" || str == null;
	      }
	      
	 	public static function padLeading(s:String, n:Float, ?char:String = " "):String{
			var returnStr:String="";
			var diff:Float = n-s.length;
			
			for(i in 0...diff){
				returnStr += char
			} 
			returnStr+=s;
			return returnStr;
		}
	   
	   public static function padTrailing(s:String, n:Float, ?char:String = " "):String{
			var diff:Float = n-s.length;
			for(i in 0...diff){
				s += char
			} 
			return s;
		}
		
		public static function trim(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(~/^\s+|\s+_S_/g, '');
		}
		
		
		public static function toStringLabel(val:Dynamic):String{
			if(Std.is( val, String)){
				return val;
			}
			if(Std.is( val, Number)){
				return String(val);
			}
			
			var s:String
			try{
				s = val["label"];
			}
			catch(e:Error){
				s = "[Object]"
			}
			return s;
		}
		
		public static function omitWordsToFit(tf:TextField, ?indicator:String="..."):Void
		{
			// truncate
	        var originalText:String = tf.text;

	        var h:Float = tf.height;
	        var w:Float = tf.width;
        	 
        	var theight:Float = tf.textHeight;
        	var twidth:Float = tf.textWidth; 
        	var s:String;     		
			
			/* added in a check against wordWrap, will omit words until fitting width*/
	        if(!tf.multiline && !tf.wordWrap){
	        	s = originalText.slice(0, Math.floor((w / tf.textWidth ) * originalText.length));
					
	            while (s && s.length > 1 && tf.textWidth > w)
	            {
	                s = s.slice(0, s.lastIndexOf(" "));
	                tf.text = s + indicator;
	            }
	        }
	        
	        // check against textWidth and textHeight, include styles
	        if(tf.textHeight > h)
	        {
	            // get close
	            s = originalText.slice(0, Math.floor((h / tf.textHeight ) * originalText.length));
					
	            while (s && s.length > 1 && tf.textHeight > h)
	            {
	                s = s.slice(0, s.lastIndexOf(" "));
	                tf.text = s + indicator;
	            }
	        }
		}
 	}
