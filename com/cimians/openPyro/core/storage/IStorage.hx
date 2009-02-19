package com.cimians.openPyro.core.storage;
	import com.cimians.openPyro.core.ISerializable;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * Dispatched when the store succeeds in persisting any object to the store
	 */ 
	/*[Event(name="storeSucceeded", type="net.comcast.pyro.storage.events.StorageEvent")]*/
	
	/**
	 * Dispatched when the store fails in persisting any object to the store
	 */ 
	/*[Event(name="storageFailed", type="net.comcast.pyro.storage.events.StorageEvent")]*/
	
	interface IStorage implements IEventDispatcher{
		/**
		 * Called to save the contents of the store to tje storage implementation.
		 * Since this may be an async process, success or failure is indicated by 
		 * dispatching a storeSucceeded or storeFailed Event.
		 * 
		 * @see net.comcast.pyro.storage.events.StorageEvent
		 */ 
		function save(object:ISerializable, ?overwrite:Bool=true):Void;
		
		/**
		 * Function used to verify if the store was successfully created or not.
		 * For example, users may have sharedObject turned off or may not allow
		 * filesystem access or may be offline for remote storage.
		 */ 
		function storeCreated():Bool;
		
		/**
		 * @return The string stored by the IStorage implementation.
		 * If the store does not exist or could not be read, return
		 * null.
		 */ 
		function getStoredData():String;
	}
