package com.cimians.openPyro.core;
	import com.cimians.openPyro.managers.SkinManager;
	import com.cimians.openPyro.managers.TooltipManager;
	import com.cimians.openPyro.painters.IPainter;
	import com.cimians.openPyro.skins.ISkin;
	import com.cimians.openPyro.skins.ISkinClient;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * The UIControl is the basic building block for
	 * pyro controls. UIControls can include other UIControls
	 * as children but cannot use layouts to position them.
	 */ 
	class UIControl extends MeasurableControl, implements ISkinClient, implements ISkin {
		
		
		
		public var backgroundPainter(getBackgroundPainter, setBackgroundPainter) : IPainter;
		
		public var measuredHeight(null, setMeasuredHeight) : Float;
		
		public var measuredWidth(null, setMeasuredWidth) : Float;
		
		public var padding(getPadding, setPadding) : Padding;
		
		public var skin(null, setSkin) : ISkin;
		
		public var skinnedControl(getSkinnedControl, setSkinnedControl) : UIControl
		;
		
		public var styleName(getStyleName, setStyleName) : String;
		
		public var toolTip(null, setToolTip) : Dynamic;
		
		public function new() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */ 
		public override function initialize():Void
		{
			createChildren();
			super.initialize()
			if(_skin || !_styleName ) return;
			
			//var skinImpl:ISkin = SkinManager.getInstance().getSkinForStyleName(this._styleName);
			SkinManager.getInstance().registerSkinClient(this, _styleName)
			//this.skin = skinImpl;
			
		}
		
		/**
		 * This is where the new children should
		 * be created and then added to the displaylist.
		 * Similar to Flex's createChildren() method.
		 */ 
		function createChildren():Void{}
		
		/**
		 * @inheritDoc
		 */ 
		public override function addChild(child:DisplayObject):DisplayObject
		{
			var ch:DisplayObject =  super._S_addChild(child);
			if(Std.is( child, UIControl))
			{
				UIControl(child).parentContainer = this;
				UIControl(child).doOnAdded()
			}
			this.invalidateSize()
			return ch
		}
		
		
		/**
		 * @inheritDoc
		 */ 
		public override function addChildAt(child:DisplayObject,index:Int):DisplayObject
		{
			var ch:DisplayObject =  super._S_addChildAt(child, index);
			if(Std.is( child, UIControl))
			{
				UIControl(child).parentContainer = this;
				UIControl(child).doOnAdded()
			}
			this.invalidateSize()
			return ch
		}
		
		/**
		 * @inheritDoc
		 */ 
		public override function measure():Void{
			if(isNaN(this._explicitWidth) && 
				(!isNaN(this._percentWidth) || !isNaN(_percentUnusedWidth)))
			{
				calculateMeasuredWidth()
			}
			if(isNaN(this._explicitHeight) && 
				(!isNaN(this._percentHeight) || !isNaN(_percentUnusedHeight)))
			{
				calculateMeasuredHeight();
			}
			this.needsMeasurement=false;
		}
		
		public override function checkDisplayListValidation():Void
		{
			doChildBasedValidation()
			super.checkDisplayListValidation()
		}
		
		function doChildBasedValidation():Void
		{
			var child:DisplayObject;
			if(isNaN(this._explicitWidth) && isNaN(this._percentWidth) && isNaN(_percentUnusedWidth))
			{
				var maxW:Int = 0
				for(j in 0...this.numChildren){
					child = this.getChildAt(j);
					if(child.width > maxW)
					{
						maxW = child.width;
					}
				}
				
				super.measuredWidth = maxW + _padding.left + _padding.right;
			}
			if(isNaN(this._explicitHeight) && isNaN(this._percentHeight) && isNaN(_percentUnusedHeight))
			{
				var maxH:Int = 0
				for(k in 0...this.numChildren){
					child = this.getChildAt(k);
					if(child.height > maxH)
					{
						maxH = child.height;
					}
				}
				super.measuredHeight = maxH + _padding.top + _padding.bottom;
			}
		}
		
		
		/**
		 * Overrides the set measuredWidth property from 
		 * <code>MeasurableControl</code> to invalidate children
		 * (UIControl acknowledges that it can have children whose
		 * dimensions are based on its own)
		 */ 
		public override function setMeasuredWidth(w:Float):Float{
			if(w  == _measuredWidth) return
			_dimensionsChanged = true;
			_measuredWidth = w;
			for(i in 0...this.numChildren){
				var child:UIControl = cast( this.getChildAt(i), UIControl);
				if(!child) continue
				child.needsMeasurement=true;
			}
				
			invalidateDisplayList()
			return w;
		}
			
		/**
		 * Overrides the set measuredHeight property from 
		 * <code>MeasurableControl</code> to invalidate children
		 * (UIControl acknowledges that it can have children whose
		 * dimensions are based on its own)
		 */
		public override function setMeasuredHeight(h:Float):Float{
			if(h == _measuredHeight) return
			this._dimensionsChanged = true;
			_measuredHeight = h;
			for(i in 0...this.numChildren){
				var child:UIControl = cast( this.getChildAt(i), UIControl);
				if(!child) continue
				child.needsMeasurement=true;
			}
			invalidateDisplayList()
			return h;
		}
		
		/**
		 * When measure is called, it uses the widthForMeasurement and 
		 * heightForMeasurement to calculate the sizes for 
		 * percent-dimension based children
		 */
		public function widthForMeasurement():Float{
			return this.width
		}
		
		/**
		 * When measure is called, it uses the widthForMeasurement and 
		 * heightForMeasurement to calculate the sizes for 
		 * percent-dimension based children
		 */
		public function heightForMeasurement():Float{
			return this.height
		}
		
		/**
		 * @inhertiDoc
		 */ 
		public override function removeChild(d:DisplayObject):DisplayObject{
			
			var d2:DisplayObject = super.removeChild(d);
			this.invalidateSize()
			return d2;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			//_S_width = unscaledWidth
			//_S_height = unscaledHeight;
			if(this._backgroundPainter){
				this.graphics.clear()
				_backgroundPainter.draw(Sprite(this).graphics, unscaledWidth,unscaledHeight);
			}
			if(_skin && !(Std.is( _skin, MeasurableControl)) && (Std.is( _skin, DisplayObject))){
				DisplayObject(_skin).width = unscaledWidth;
				DisplayObject(_skin).height = unscaledHeight;
			}
			doLayoutChildren()
		}
		
		public function doLayoutChildren():Void
		{
			for(i in 0...this.numChildren)
			{
				var child:DisplayObject = this.getChildAt(i);
				// Skin elements do not get positioned. Its upto the
				// skin to deal with the padding
				if(child == _skin) continue;
				
				//child.x = padding.left;
				//child.y = padding.top;
			}
		}
		/////////////// Painters Implementation //////////////
		
		var _backgroundPainter:IPainter;
		
		/**
		 * UIControls can have a backgroundPainter object attached that is 
		 * triggered everytime updateDisplayList is called. 
		 * 
		 * @see com.cimians.openPyro.painters
		 */
		public function getBackgroundPainter():IPainter{
			return _backgroundPainter;
		}
		
		/**
		 * @private
		 */ 
		public function setBackgroundPainter(painter:IPainter):IPainter{
			this._backgroundPainter = painter;
			this.invalidateDisplayList();
			return painter;
		}
		
		public function removeBackgroundPainter():Void{
			this._backgroundPainter = null;
			this.invalidateDisplayList();
		}
		
		///////////////////// Skinning implementation ////////////
		
		var _styleName:String
		
		/**
		 * Defines the skin this component is registered to.
		 * As long as a skin is registered with the same 
		 * name as this value, this control will get that
		 * skin when instantiated or when that definition
		 * changes.
		 * 
		 * @see com.cimians.openPyro.managers.SkinManager
		 */ 
		public function getStyleName():String{
			return _styleName;
		}
		
		/**
		 * @private
		 */ 
		public function setStyleName(selector:String):String{
			if(_styleName == selector) return;	
			if(initialized){
				SkinManager.getInstance().unregisterSkinClient(this,_styleName);
				SkinManager.getInstance().registerSkinClient(this, selector)
			}
			this._styleName = selector;
			return selector;
		}
		
		public function dispose():Void{}
		
		var _skinnedControl:UIControl;
		
		public function setSkinnedControl(uic:UIControl):UIControl
		{
			if(_skinnedControl){
				_skinnedControl.removeEventListener(Event.RESIZE, onSkinnedControlResize)
			}
			_skinnedControl = uic;
			_skinnedControl.addEventListener(Event.RESIZE, onSkinnedControlResize)
			return uic;
		}
		
		public function getSkinnedControl():UIControl
		{
			return _skinnedControl;
		}
		
		/**
		 * Event handler for when the UIControl is applied as a Skin
		 * and the control it is skinning is resized.
		 * 
		 * @see com.cimians.openPyro.skins
		 */ 
		function onSkinnedControlResize(event:Event):Void
		{
			this.width = _skinnedControl.width;
			this.height = _skinnedControl.height;
		}
		
		var _skin:ISkin;
		
		public function setSkin(skinImpl:ISkin):ISkin{
			if(!skinImpl) return;
			
			if(this._skin)
			{
				_skin.dispose();
				_skin = null;
			}
			_skin = skinImpl;
			_skin.skinnedControl = this;
			if(Std.is( _skin, UIControl)){
				addChild(UIControl(_skin))
				//UIControl(_skin).percentUnusedWidth = 100
				//UIControl(_skin).percentUnusedHeight = 100
			}
			return skinImpl;
		}
		
		////////////////////// ToolTip //////////////////////////
		
		var _toolTipData:Dynamic;
		var toolTipRenderer:Class<Dynamic>;
	
		public function setToolTip(data:Dynamic):Dynamic{
			_toolTipData = data;
			if(_toolTipData){
				this.addEventListener(MouseEvent.MOUSE_OVER, 
										function(event:MouseEvent):Void{
											TooltipManager.getInstance().showToolTip(event, _toolTipData, toolTipRenderer)
										})
				
				this.addEventListener(MouseEvent.MOUSE_OUT, 
				function(event:MouseEvent):Void{
					TooltipManager.getInstance().hideToolTip()
				})
			}
			return data;
		}
		
		///////////////////// Padding //////////////////////////////
		
		var _padding:Padding ;
		
		/**
		 * Paddings define the unusable space within
		 * UIContainers that should not be used for
		 * measurement and layout. Similar to 
		 * HTML/CSS padding
		 */ 
		public function getPadding():Padding{
			return _padding;
		}
		
		public override function setActualSize(w:Float,h:Float):Void
		{
			this._explicitWidth = w;
			this._explicitHeight = h;
			for(i in 0...this.numChildren){
				var uic:UIControl = cast( this.getChildAt(i), UIControl)
				if(!uic) continue
				uic.validateSize();
				uic.validateDisplayList();
			}
			this.updateDisplayList(this.getExplicitOrMeasuredWidth(), this.getExplicitOrMeasuredHeight());
		}
		
		
		/**
		 * @private
		 */ 
		public function setPadding(p:Padding):Padding{
			_padding = p
			this.invalidateDisplayList();
			return p;
		}
	
		
		//////////////////// End Skinning Implementation ///////////
		
		/**
		 * Convinience function for setting width and height
		 * in one call. The parameters can either be Strings
		 * or Numbers. When passing strings, you can append
		 * a '%' character at the end of the string to set a 
		 * percent value
		 * 
		 * @param	w	Width either as a Number or as a String 
		 * 				ending with a % character
		 * @param	h	Height either as a Number or as a String 
		 * 				ending with a % character
		 * 
		 * @throws	Error if the datatype passed in is not a Number 
		 * 			or String
		 */ 
		public function setSize(w:Dynamic, h:Dynamic):Void{
			var str:String
			if(Std.is( w, Number)){
				this.width = w
			}
			else if(Std.is( w, String)){
				str = String(w)
				if(str.charAt(str.length-1)== "%"){
					str = str.substring(0, str.length-1)
					this.percentUnusedWidth = Number(str);
				}
			}
			
			else{
				throw new Error('SetSize can only take a string or number as a param')
			}
			
			if(Std.is( h, Number)){
				this.height = h
			}
			else if(Std.is( h, String)){
				str = String(h)
				if(str.charAt(str.length-1)== "%"){
					str = str.substring(0, str.length-1)
					this.percentUnusedHeight = Number(str);
				}
			}
			
			else{
				throw new Error('SetSize can only take a string or number as a param')
			}
			
		}
		
	}