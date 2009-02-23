package com.cimians.openPyro.controls;

	import com.cimians.openPyro.core.UIControl;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	class Image extends UIControl {
		
		public var autoLoad(getAutoLoad, setAutoLoad) : Bool ;
		public var contentHeight(getContentHeight, null) : Float;
		public var contentWidth(getContentWidth, null) : Float;
		public var loader(getLoader, null) : Loader ;
		public var loaderContext(getLoaderContext, setLoaderContext) : LoaderContext ;
		public var maintainAspectRatio(getMaintainAspectRatio, setMaintainAspectRatio) : Bool ;
		public var scaleToFit(getScaleToFit, setScaleToFit) : Bool;
		public var source(null, setSource) : String;

		var _sourceURL:String ;
		var _loader:Loader;
		
		var _autoLoad:Bool;

		var _scaleToFit:Bool ;

		var _maintainAspectRatio:Bool ;

		public function new() {
			_sourceURL = "";
			super();
            _autoLoad = true;
            _scaleToFit = true;
            _maintainAspectRatio = true;
		}
		
		override function createChildren():Void
		{
			super.createChildren();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addChild(_loader);
			
			if(_loaderContext != null)
			{
				_loaderContext = new LoaderContext(true);
			}
			
			if(_autoLoad && (_sourceURL != "")){
				_loader.load(new URLRequest(_sourceURL), _loaderContext);	
			}
		}
		
		public function setAutoLoad(b:Bool):Bool
		{
			_autoLoad = b;	
			return b;
		}
		
		public function getAutoLoad():Bool
		{
			return _autoLoad;
		}
		
		public function setSource(url:String):String{
			if(url == _sourceURL) return url;
			_sourceURL = url;
			if(_loader != null && _autoLoad){
				_loader.load(new URLRequest(url), _loaderContext);
			}
			return url;
		}
		
		var _loaderContext:LoaderContext;
		
		/**
		 * The LoaderContext that is used when loading an 
		 * image.
		 */ 
		public function setLoaderContext(context:LoaderContext):LoaderContext
		{
			_loaderContext = context;
			return context;
		}
		
		/**
		 * @private
		 */ 
		public function getLoaderContext():LoaderContext
		{
			return _loaderContext;
		}
		
		/**
		 * Returns the raw loader being used to load the image
		 */ 
		public function getLoader():Loader
		{
			return _loader;
		}
		
		function onLoadComplete(event:Event):Void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			forceInvalidateDisplayList = true;
			invalidateSize();
			invalidateDisplayList();
		}

		override function doChildBasedValidation():Void{
			if(_loader == null ||  _loader.content == null) return;
			if(Math.isNaN(this._explicitWidth) && Math.isNaN(this._percentWidth) && Math.isNaN(_percentUnusedWidth)){
				measuredWidth = _loader.content.width;
			}
			if(Math.isNaN(this._explicitHeight) && Math.isNaN(this._percentHeight) && Math.isNaN(_percentUnusedHeight))
			{
				measuredHeight = _loader.content.height;
			}
		}
		
		public function getContentWidth():Float{
			return _loader.content.width;
		}
		
		public function getContentHeight():Float{
			return _loader.content.height;
		}
		
		function onIOError(event:IOErrorEvent):Void
		{
			//todo: Put broken thumb skin here//
		}
		
		public function getScaleToFit():Bool{
			return _scaleToFit;
		}
		
		public function setScaleToFit(value:Bool):Bool{
			_scaleToFit = value;
			if(_scaleToFit && _loader != null && _loader.content != null)
			{
				scaleImageContent();
			}
			return value;
		}
		
		public function setMaintainAspectRatio(value:Bool):Bool
		{
			_maintainAspectRatio = value;
			return value;
		}

		public function getMaintainAspectRatio():Bool
		{
			return _maintainAspectRatio;
		}
		
		function scaleImageContent():Void
		{
		
			var scaleX:Float;
			var scaleY:Float;	
			scaleX = mwidth / _loader.content.width;
			scaleY = mheight / _loader.content.height;
			
			if(_maintainAspectRatio)
			{
				var scale:Float = Math.min(scaleX, scaleY);
				_loader.content.width = _loader.content.width*scale;
				_loader.content.height = _loader.content.height*scale;	
			}
			else
			{
				_loader.content.width = _loader.content.width*scaleX;
				_loader.content.height = _loader.content.height*scaleY;
			}
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_loader != null && _loader.content != null && _scaleToFit){
				scaleImageContent();
			}
		}
		
	}
