package com.cimians.openPyro.storage;

	import com.cimians.openPyro.core.ISerializable;
	
	import flash.utils.Dictionary;
	
	/**
	 * @example The following code shows how to use StorageDictionary
	 * 
	 * <listing version="3.0" > 
	 * 		var kv:StorageDictionary = new StorageDictionary()
	 * 		kv.setKeyValuePair("one", "1");
	 * 		kv.setKeyValuePair("two", "2");
	 * 		kv.separator = "&"
	 * 		var serializedString:String = kv.serialize();
	 * </listing>
	 */ 
	class StorageDictionary implements ISerializable {
		
		
		
		public var separator(getSeparator, setSeparator) : String;
		
		var keyValueString:String ;
		
		var data:Dictionary var _separator:String public function new() {
			
		
		keyValueString = "";
		data = new Dictionary()
		
		;
		_separator = "|"
		
		;
		}
		
		public function setSeparator(separatorCharacter:String):String{
			_separator = separatorCharacter
			return separatorCharacter;
		}
		
		public function getSeparator():String{
			return _separator;
		}
		
		
		public function setKeyValuePair(key:String, value:String):Void
		{
			data[key] = value;
		}
		
		public function getValueForKey(key:String):String
		{
			return data[key];
		}
		
		public function serialize():String
		{
			for(var key:String in data){
				
				keyValueString+=key+":"+data[key]+_separator;
				
			}
			return keyValueString;
		}
		
		/**
		 * Reconsitutes a key value pair based dictionary
		 * from a serialized string.
		 */ 
		public function deserialize(str:String):Void
		{
			var keyValArray:Array<Dynamic> = str.split(this._separator);
			for(i in 0...keyValArray.length)
			{
				var key:String = String(String(keyValArray[i]).split(":")[0])
				var value:String = String(String(keyValArray[i]).split(":")[1])
				if(data.hasOwnProperty(key))
				{
					//TODO: Storage handle conflict
				}
				data[key] = value;
			}
		}

	}
