package com.cimians.openPyro.managers;
	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.skins.FlaSymbolSkin;
	import com.cimians.openPyro.skins.ISkin;
	import com.cimians.openPyro.skins.ISkinClient;
	import com.cimians.openPyro.utils.ArrayUtil;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	class SkinManager extends EventDispatcher {
		
		public static var SKIN_SWF_LOADED:String = "skinSWFLoaded";
		
		var skinClients:Hash<Array<ISkinClient>>;
		var skinDefinitions:Hash<ClassFactory>;
		
		public function new(){
            super();
			skinClients = new Hash();
			skinDefinitions = new Hash();
            invalidSelectors = new Array();
		}
		
		static var instance:SkinManager;
		public static function getInstance():SkinManager
		{
			if(instance == null)
			{
				instance = new SkinManager();
			}
			return instance;
		}
		
		public function registerSkinClient(client:ISkinClient, selector:String):Void
		{
			if(skinClients.exists(selector)){
                var skinnable:Array<ISkinClient> = skinClients.get(selector);
                skinnable.push(client);
            } else {
                skinClients.set(selector, [client]);
            }
		}
		
		public function unregisterSkinClient(client:ISkinClient, selector:String):Void
		{
            if(skinClients.exists(selector)) {
                skinClients.get(selector).remove(client);
            }
		}
		
		
		public function getSkinForStyleName(styleName:String):ISkin
		{
			var skinFactory:ClassFactory =  this.skinDefinitions.get(styleName);
			if(skinFactory == null) return null;
			var skin:ISkin = cast skinFactory.newInstance();
			return skin;
		}
		
		
		var timer:Timer;
		var invalidSelectors:Array<String> ;
		
		public function registerSkin(skinFactory:ClassFactory, selector:String):Void
		{
			if(skinDefinitions.get(selector) == skinFactory) return;
			this.skinDefinitions.set(selector, skinFactory);
			invalidSelectors.push(selector);
			/* 
			[TODO:] This needs to happen on the next EnterFrame, not Timer
			*/
			invalidateSkins();
		}
		
		public function registerFlaSkin(skin:Class<Dynamic>, selector:String):Void
		{
			var flaSkinFactory = new ClassFactory(FlaSymbolSkin);
			flaSkinFactory.properties = {movieClipClass:skin};
			registerSkin(flaSkinFactory, selector);
		}
		
		public function invalidateSkins():Void
		{
			if(timer == null){
				timer = new Timer(500, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, validateSkins);
			}
			if(!timer.running){
				timer.start();
			}	
		}
		
		public function validateSkins(event:TimerEvent):Void
		{
			for (a in this.invalidSelectors)
			{ 
				var skinnable:Array<ISkinClient> = skinClients.get(a);
				var skinFactory:ClassFactory = this.skinDefinitions.get(a);
				
				if(skinnable == null || skinFactory == null) continue;
				for(client in skinnable)
				{
					client.skin = cast skinFactory.newInstance();
				}
			}
			this.invalidSelectors = new Array();	
		}
		
		public function loadSkinSwf(swfURL:String):Void{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onSkinSWFLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(swfURL), new LoaderContext(true, ApplicationDomain.currentDomain));
		}
		
		function onIOError(event:Event):Void{
			
		}
		
		
		function onSkinSWFLoaded(event:Event):Void{
			cast(event.target, LoaderInfo).removeEventListener(Event.INIT, onSkinSWFLoaded);

            //?? what does this line below do?
			//Object(cast(event.target, LoaderInfo).loader.content).getDefinitions(this)
			
			/*
			for(var a:String in this.skinClients){
				var classDefinition:Class
				try{
					classDefinition = ApplicationDomain.currentDomain.getDefinition(a) as Class;	
				}catch(e:Error){
					continue
				}
				var skinnable:Array = skinClients[a] as Array;
				for(var i:uint=0; i<skinnable.length; i++){
					var client:ISkinClient = ISkinClient(skinnable[i])
					var skin:ISkin;
					try{
						var mclip:MovieClip = MovieClip(new classDefinition());
						skin = new FlaSymbolSkin(mclip);
					}catch(e:Error){
						trace('there was no movieclip in the loaded swf')
					}
					client.skin = skin;
				}
			}	
			dispatchEvent(new Event(SKIN_SWF_LOADED));
			*/
		}

	}
