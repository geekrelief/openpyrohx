package com.cimians.openPyro.storage;

	import com.cimians.openPyro.core.ISerializable;
	
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
		
		var data:Hash<String>;
        var _separator:String;

        public function new() {
		    keyValueString = "";
    		data = new Hash();
    		_separator = "|";
		}
		
		inline public function setSeparator(separatorCharacter:String):String{
			_separator = separatorCharacter;
			return separatorCharacter;
		}
		
		inline public function getSeparator():String{
			return _separator;
		}
		
		
		inline public function setKeyValuePair(key:String, value:String):Void
		{
			data.set(key, value);
		}
		
		inline public function getValueForKey(key:String):String
		{
			return data.get(key);
		}
		
		public function serialize():String
		{
			for(key in data.keys()){
				keyValueString+=key+":"+data.get(key)+_separator;
			}
			return keyValueString;
		}
		
		/**
		 * Reconsitutes a key value pair based dictionary
		 * from a serialized string.
		 */ 
		public function deserialize(str:String):Void
		{
			var keyValArray:Array<String> = str.split(this._separator);
			for(kv in keyValArray)
			{
                var kva = kv.split(":");
				var key = kva[0];
				var value = kva[1];
				if(data.exists(key))
				{
					//TODO: Storage handle conflict
				}
				data.set(key, value);
			}
		}

	}
