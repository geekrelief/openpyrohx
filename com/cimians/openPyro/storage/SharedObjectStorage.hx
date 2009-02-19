package com.cimians.openPyro.storage;
	
	import com.cimians.openPyro.core.ISerializable;
	import com.cimians.openPyro.core.events.StorageEvent;
	import com.cimians.openPyro.core.storage.IStorage;
	import com.cimians.openPyro.core.storage.StoreActionState;
	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	/**
	 * Dispatched when the store succeeds in persisting any object to the store
	 */ 
	/*[Event(name="storeSucceeded", type="net.comcast.pyro.storage.events.StorageEvent")]*/
	
	/**
	 * Dispatched when the store fails in persisting any object to the store
	 */ 
	/*[Event(name="storageFailed", type="net.comcast.pyro.storage.events.StorageEvent")]*/
	
	/**
	 * The SharedObjectStorage saves the serializable object as a
	 * value to the SO in the so.data.value field.
	 * 
	 * <listing version="3.0" > 
	 * 	var ob:StorageDictionary = new StorageDictionary()
	 * 	ob.setKeyValuePair(key, value);
	 * 	var storage:SharedObjectStore = new SharedObjectStore('dev')
	 * 	storage.save(ob)
	 * </listing>
	 */ 
	class SharedObjectStorage extends EventDispatcher, implements IStorage {
		
		
		
		public var storeActionState(getStoreActionState, null) : String;
		
		public var storeCreated(getStoreCreated, null) : Bool;
		
		var _storeCreated:Bool ;
		var so:SharedObject;
		
		/**
		 * The number of bytes to reserve for the storage
		 */ 
		public var minDiskSpace:Int ;
		
		/**
		 * Constructor
		 */ 
		public function new(soName:String,?localPath:String = null, ?secure:Bool = false){
			
			_storeCreated = false;
			minDiskSpace = 1000;
			try{
				so = SharedObject.getLocal(soName, localPath, secure);
				_storeCreated = true;	
				
			}catch(e:Error){
				_storeCreated = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getStoreCreated():Bool{
			return _storeCreated;
		}
		
		var _storeActionState:String;
		
		/**
		 * Returns the status of the last "save" action.
		 * The values are one of the constant values from
		 * <code>com.cimians.openPyro.core.storage.StoreActionState</code>
		 * 
		 * @see com.cimians.openPyro.core.storage.StoreActionState;
		 */ 
		public function getStoreActionState():String{
			return _storeActionState;
		}
		
		
		/**
		 * @inheritDoc
		 */ 
		public function save(ob:ISerializable, ?overwrite:Bool=true):Void{
			if(!_storeCreated){
				_storeActionState = StoreActionState.SAVE_FAILED;
				dispatchEvent(new StorageEvent(StoreActionState.SAVE_FAILED));
				return ;
			}
			if(overwrite){
				so.data.value = ob.serialize();
			}
			else{
				if(so.data && so.data != ""){
					throw new Error("Cannot overwrite on Shared Object. Key already exists");
				}
			}
			var flushStatus:String = null;
			try{
				flushStatus = so.flush(minDiskSpace);
			}
			// flush may immediately fail if user has disallowed storage
			catch(e:Error){
				_storeActionState = StoreActionState.SAVE_FAILED;
				dispatchEvent(new StorageEvent(StoreActionState.SAVE_FAILED));
				return ;
			}
			 if (flushStatus != null) {
                switch (flushStatus) {
                    case SharedObjectFlushStatus.PENDING:
                    	_storeActionState = StoreActionState.SAVE_PENDING;
                        //Logger.info(this, "Waiting for user to allow save to disk");
                        so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                        break;
                    case SharedObjectFlushStatus.FLUSHED:
                    	_storeActionState = StoreActionState.SAVE_SUCCEEDED;
                        dispatchEvent(new StorageEvent(StoreActionState.SAVE_SUCCEEDED));
                        break;
                }
            }
		}
		
		/**
		 * @private
		 * Event handler if the flush caused a user prompt making the response
		 * asynchronous
		 */ 
		function onFlushStatus(event:NetStatusEvent):Void {
            switch (event.info.code) {
                case "SharedObject.Flush.Success":
               	 	_storeActionState = StoreActionState.SAVE_SUCCEEDED;
                   	dispatchEvent(new StorageEvent(StoreActionState.SAVE_SUCCEEDED));
                    break;
                case "SharedObject.Flush.Failed":
                	_storeActionState = StoreActionState.SAVE_FAILED;
                    dispatchEvent(new StorageEvent(StoreActionState.SAVE_FAILED));
                    break;
            }
            so.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }
        
        /**
        * @inheritDoc
        */ 
        public function getStoredData():String{
        	return cast( so.data.value, String);
        }
	}
