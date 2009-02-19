package com.cimians.openPyro.core;
	import com.cimians.openPyro.events.PyroEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/*[Event(name="resize", type="flash.events.Event")]*/
	/*[Event(name="updateComplete", type="com.cimians.openPyro.events.PyroEvent")]*/
	/*[Event(name="sizeValidated", type="com.cimians.openPyro.events.PyroEvent")]*/
	/*[Event(name="propertyChange", type="com.cimians.openPyro.events.PyroEvent")]*/
	
	
	/**
	 * The Measurable control is the basic class that
	 * understands Pyro's measurement strategy.
	 */ 
	class MeasurableControl extends Sprite {
		
		
		
		public var _S_height(get_S_height, set_S_height) : Float;
		
		public var _S_width(get_S_width, set_S_width) : Float;
		
		public var creationCompleteFired(getCreationCompleteFired, null) : Bool;
		
		public var explicitHeight(getExplicitHeight, setExplicitHeight) : Float;
		
		public var explicitWidth(getExplicitWidth, setExplicitWidth) : Float;
		
		public var height(getHeight, setHeight) : Float;
		
		public var includeInLayout(getIncludeInLayout, setIncludeInLayout) : Bool;
		
		public var maximumHeight(getMaximumHeight, setMaximumHeight) : Float;
		
		public var maximumWidth(getMaximumWidth, setMaximumWidth) : Float;
		
		public var measuredHeight(getMeasuredHeight, setMeasuredHeight) : Float
		;
		
		public var measuredWidth(getMeasuredWidth, setMeasuredWidth) : Float
		;
		
		public var mouseActionsDisabled(getMouseActionsDisabled, null) : Bool;
		
		public var parentContainer(getParentContainer, setParentContainer) : UIControl
		;
		
		public var percentHeight(getPercentHeight, setPercentHeight) : Float
		;
		
		public var percentUnusedHeight(getPercentUnusedHeight, setPercentUnusedHeight) : Float;
		
		public var percentUnusedWidth(getPercentUnusedWidth, setPercentUnusedWidth) : Float;
		
		public var percentWidth(getPercentWidth, setPercentWidth) : Float
		;
		
		public var usesMeasurementStrategy(getUsesMeasurementStrategy, null) : Bool;
		
		public var visible(null, setVisible) : Bool;
		
		public var width(getWidth, setWidth) : Float;
		
		public function new(){
			this.addEventListener(Event.ADDED, onAddedToParent);
			super.visible = false;
		}
		
		public var initialized:Bool ;
		
		/**
		 * This happens only once when a child is
		 * first added to any parent. Subsequent 
		 * removeChild and addChild actions do not
		 * trigger this function.
		 */ 
		public function initialize():Void
		{
			initialized = true;
			this.validateSize();
		}
		
		var _explicitWidth:Float ;
		var _explicitHeight:Float ;
		
		/**
		 * The width set in terms of actual pixels.
		 * You do not call this function in your code.
		 * Setting the width of the control to an actual
		 * numeric value (rather than percent) calls this
		 * function
		 * Call this function only if you want to set
		 * width without calling the invalidation methods 
		 * 
		 * [TODO] This class should 
		 * have namespace access control (pyro_internal)
		 */ 
		public function setExplicitWidth(w:Float):Float{
			_explicitWidth = w;	
			return w;
		}
		
		/**
		 * @private
		 */ 
		public function getExplicitWidth():Float{
			return _explicitWidth;	
		}
		
		/**
		 * The height set in terms of actual pixels.
		 * You do not call this function in your code.
		 * Setting the width of the control to an actual
		 * numeric value (rather than percent) calls this
		 * function
		 * Call this function only if you want to set
		 * width without calling the invalidation methods 
		 * 
		 * [TODO] This class should 
		 * have namespace access control (pyro_internal)
		 */ 
		public function setExplicitHeight(h:Float):Float{
			_explicitHeight = h;	
			return h;
		}
		
		/**
		 * @private
		 */ 
		public function getExplicitHeight():Float{
			return this._explicitHeight;	
		}
		
		/**
		 * Set/get the width of the control. If the width
		 * is set to a different value from the one the 
		 * control is already at, it triggers the size 
		 * invalidation cycle
		 */ 
		public override function setWidth(n:Float):Float{
			if(n == _explicitWidth) return
			n = Math.floor(n)
			this._explicitWidth = n
			_dimensionsChanged = true;
			displayListInvalidated = true;
			if(!initialized) return;
			invalidateSize();
			
			
			return n;
		}
		
		/**
		 * @private 
		 */ 
		public override function getWidth():Float{
			return this.getExplicitOrMeasuredWidth()
		}
		
		/**
		 * Set/get the height of the control. If the height
		 * is set to a different value from the one the 
		 * control is already at, it triggers the size 
		 * invalidation cycle
		 */ 
		public override function setHeight(n:Float):Float{
			if (n == _explicitHeight) return;
			n = Math.floor(n)
			this._explicitHeight = n
			displayListInvalidated = true;
			_dimensionsChanged=true;	
			if(!initialized) return;
			invalidateSize();
			//invalidateDisplayList();
			return n;
		}
		
		/**
		 * @private
		 */ 
		public override function getHeight():Float{
			return this.getExplicitOrMeasuredHeight();
		}
		
		var _maximumWidth:Float ;
		public function setMaximumWidth(n:Float):Float{
			_maximumWidth = n;
			invalidateSize();
			return n;
		}
		
		public function getMaximumWidth():Float{
			return _maximumWidth;
		}
		
		var _maximumHeight:Float ;
		public function setMaximumHeight(n:Float):Float{
			_maximumHeight = n;
			invalidateSize();
			return n;
		}
		
		public function getMaximumHeight():Float{
			return _maximumHeight;
		}
		
		
		var _percentUnusedWidth:Float;
		var _percentUnusedHeight:Float;
		
		/** 
		 * Only setting percent width/heights changes the 
		 * needsMeasurement flag which makes its parent 
		 * container call measure on it.
		 * If width and height are set directly, measurement 
		 * is never called (although size invalidation 
		 * still does if size has changed)
		 */ 
		public var needsMeasurement:Bool;
		
		/**
		 * Set/get the percent width. If the value is 
		 * different from the earlier, it sets the measurement 
		 * flag and calls invalidateSize
		 */ 
		public function setPercentUnusedWidth(w:Float):Float{
			if(w == _percentUnusedWidth) return
			_percentUnusedWidth = w;
			if(!initialized) return;
			invalidateSize()
			return w;
		}
		
		/**
		 * @private
		 */ 
		public function getPercentUnusedWidth():Float{
			return _percentUnusedWidth;
		}
		
		/**
		 * Set/get the percent height. If the value is 
		 * different from the earlier, it sets the measurement 
		 * flag and calls invalidateSize
		 */ 
		public function setPercentUnusedHeight(h:Float):Float{
			if(h==_percentUnusedHeight) return;
			//needsMeasurement = true;
			_percentUnusedHeight = h;
			if(!initialized) return;
			this.invalidateSize()
			return h;
		}
		
		var _percentWidth:Float
		public function setPercentWidth(w:Float):Float
		{
			if(w==_percentWidth) return;
			_percentWidth = w;
			if(!initialized) return;
			this.invalidateSize()
			return w;
		}
		
		public function getPercentWidth():Float
		{
			return _percentWidth
		}
		
		var _percentHeight:Float
		public function setPercentHeight(h:Float):Float
		{
			if(h==_percentHeight) return;
			_percentHeight = h;
			if(!initialized) return;
			this.invalidateSize()
			return h;
		}
		
		public function getPercentHeight():Float
		{
			return _percentHeight;
		}
		
		/**
		 * @private
		 */ 
		public function getPercentUnusedHeight():Float{
			return _percentUnusedHeight;
		}
		
		var _parentContainer:UIControl;
		
		public function setParentContainer(c:UIControl):UIControl
		{
			this._parentContainer = c;
			return c;
		}
		
		public function getParentContainer():UIControl
		{
			return _parentContainer;
		}
		
		/**
		 * The flag to mark that the control's size
		 * has been invalidated. This means the control
		 * is now waiting for a validateSize call.
		 */ 
		public var sizeInvalidated:Bool;
		
		/**
		 * Marks itself dirty and waits till either the container 
		 * to validateSize or validates itself at the next enterframe 
		 * if it has no parent container.
		 * 
		 * This method is overridden by UIControl. The code here 
		 * will only be useful for a Spacer type of component. 
		 */ 
		public function invalidateSize():Void{
			//Logger.debug(this, "invalidateSize")
			if(sizeInvalidated) return;
			sizeInvalidated=true;
			if(this._parentContainer){
				_parentContainer.invalidateSize();
			}
			else{
				this.addEventListener(Event.ENTER_FRAME, doQueuedValidateSize);
				//doQueuedValidateSize(new Event(Event.ENTER_FRAME))
			}
			
		}
		
		/*
		////////// Todo: NEEDS IMPLMENTATION ////////
		
		protected var _includeInLayout:Boolean = true;
		public function set includeInLayout(b:Boolean):void{
			_includeInLayout = b;
		}
		public function get includeInLayout():Boolean{
			return _includeInLayout;
		}
		*/
		
		/**
		 * doQueueValidateSize is executed by the top level UIControl.
		 */ 
		function doQueuedValidateSize(event:Event):Void
		{
			this.removeEventListener(Event.ENTER_FRAME, doQueuedValidateSize);
			
			this.validateSize();
			dispatchEvent(new PyroEvent(PyroEvent.SIZE_VALIDATED));		
		}
		
		/**
		 * This property defines whether measure() will be called during 
		 * validateSize() or not. 
		 */ 
		public function getUsesMeasurementStrategy():Bool{
			if(isNaN(this._explicitHeight) || isNaN(this._explicitWidth)){
				return true;
			}
			else{
				return false;
			}
		}
		
		/**
		 * The validateSize function is called in response to 
		 * a component declaring its size invalid (usually
		 * by calling invalidateSize()). The job of this 
		 * method is to compute the final width and height 
		 * (whether by calling measure if an explicit w/h
		 * is not declared or not if an explicit w & h is 
		 * declared)
		 * 
		 * @see invalidateSize()
		 * @see measure()
		 * @see usesMeasurementStrategy
		 */ 
		public function validateSize():Void{
			if(usesMeasurementStrategy){
//				if(this._parentContainer){
					measure();
					checkDisplayListValidation()
					sizeInvalidated=false;
//				}
			}	
			else{
				sizeInvalidated=false;
				if(displayListInvalidated){
					queueValidateDisplayList();
				}
			}
			
			//sizeInvalidated=false;
			
			for(j in 0...this.numChildren){
				var child:MeasurableControl = cast( this.getChildAt(j), MeasurableControl);
				if(!child) continue
				child.validateSize()
				child.dispatchEvent(new PyroEvent(PyroEvent.SIZE_VALIDATED));	
			}
		}
		
		/**
		 * The event listener executed when this component 
		 * has been added to the parent.
		 */ 
		function onAddedToParent(event:Event):Void{
			if(!this.parent) return;
			this.removeEventListener(Event.ADDED, onAddedToParent);
			this.addEventListener(Event.REMOVED, onRemovedFromParent,false,0,true);
			this._parentContainer = cast( this.parent, UIControl);
			if(!_parentContainer)
			{
				doOnAdded();
			}
		}
		
		/**
		 * [Temp] This function is called automatically 
		 * by a parent UIControl if this is created as a 
		 * child of a UIControl. Else you have to call 
		 * this function for now. 
		 */ 
		public function doOnAdded():Void
		{	
			if(!initialized){
				this.initialize();
				initialized = true;
			}
			else
			{
				validateSize();
			}
			
			if(!(Std.is( this.parent, UIControl))) {
				if(displayListInvalidated){
					queueValidateDisplayList();
				}
			}
			else{
				
				if(this.sizeInvalidated){
					_parentContainer.invalidateSize();
				}
			}
		}
		
		var _measuredWidth:Float;
		var _measuredHeight:Float;
		
		var _dimensionsChanged:Bool;
		
		/**
		 * Measure is called during the validateSize if
		 * the needsmeasurement flag is set. 
		 * At this point, new measured width/heights are 
		 * calculated. If these values are different from
		 * the values previously calculated, the 
		 * resizeHandler is queued for the next enterframe
		 * 
		 */ 
		public function measure():Void{
			if(isNaN(this._explicitWidth))
			{
				calculateMeasuredWidth()
			}
			if(isNaN(this._explicitHeight))
			{
				calculateMeasuredHeight();
			}
			this.needsMeasurement=false;
		}
		
		function calculateMeasuredWidth():Void
		{
			if(!isNaN(this._percentUnusedWidth) && this._parentContainer)
			{
				var computedWidth:Int = this._parentContainer.widthForMeasurement()*this._percentUnusedWidth/100;
				if(!isNaN(_maximumWidth)){
					computedWidth = Math.min(_maximumWidth, computedWidth);
				}
				measuredWidth = computedWidth;
			}
			else if(!isNaN(this._percentWidth) && this._parentContainer)
			{
				this.measuredWidth = this._parentContainer.width*this._percentWidth/100;
			}
		}
		
		function calculateMeasuredHeight():Void
		{
			if(!isNaN(this._percentUnusedHeight) && this._parentContainer)
			{
				this.measuredHeight = this._parentContainer.heightForMeasurement()*this._percentUnusedHeight/100;	
			}
			else if(!isNaN(this._percentHeight) && this._parentContainer)
			{
				this.measuredHeight = this._parentContainer.height*this._percentHeight/100;
			}
		}
		
		/**
		 * Set the measured height of the control. This is
		 * usually set by the same control's measure()
		 * function. If the measuredHeight is changed, 
		 * the displayList is invalidated
		 */ 
		public function setMeasuredHeight(h:Float):Float
		{
			if(h == _measuredHeight) return
			_measuredHeight = h;
			displayListInvalidated = true;
			_dimensionsChanged = true;
			return h;
		}
		
		
		
		/**
		 * @private
		 */ 
		public function getMeasuredHeight():Float
		{
			return _measuredHeight;
		}
		
		public function setMeasuredWidth(w:Float):Float
		{
			if(w  == _measuredWidth) return
			_measuredWidth = w;
			displayListInvalidated = true;
			_dimensionsChanged = true
			return w;
		}
		
		/**
		 * @private
		 */ 
		public function getMeasuredWidth():Float
		{
			return _measuredWidth;
		}
		
		/**
		 * Flag to mark a dirty displaylist. It basically means it is
		 * waiting for a call to updateDisplayList at some point
		 */ 
		public var displayListInvalidated:Bool;
		
		public var forceInvalidateDisplayList:Bool;
		
		function invalidateDisplayList():Void{
			if(!initialized) return;
			if((!this.sizeInvalidated && !displayListInvalidated) || forceInvalidateDisplayList){
				forceInvalidateDisplayList=false;
				displayListInvalidated=true;
				queueValidateDisplayList();
				
			}
		}
		
		public function checkDisplayListValidation():Void{
			if(_dimensionsChanged){
			
	//			trace(this.name,'dimensions changed ...queueValidateDL')
				queueValidateDisplayList()
			}	
		}
		
		/**
		 */ 
		public function queueValidateDisplayList():Void{
			
			if(this._parentContainer && _dimensionsChanged){
				_parentContainer.queueValidateDisplayList()
			}else{
				this.addEventListener(Event.ENTER_FRAME, validateDisplayList)
				
			}
		}
		
		/**
		 * validateDisplayList is called as a response to invalidateDisplayList.
		 */ 
		public function validateDisplayList(?event:Event=null):Void{
			
			if(isNaN(this.getExplicitOrMeasuredWidth()) || isNaN(this.getExplicitOrMeasuredHeight())){
				return;
			}
			if(event){
				this.removeEventListener(Event.ENTER_FRAME,validateDisplayList) 
			}
			for(j in 0...this.numChildren){
				var child:MeasurableControl = cast( this.getChildAt(j), MeasurableControl);
				if(!child) continue
				child.validateDisplayList()
			}
			this.updateDisplayList(this.getExplicitOrMeasuredWidth(), this.getExplicitOrMeasuredHeight());
			if(_dimensionsChanged){
				_dimensionsChanged = false;
				resizeHandler();
			}
			this.displayListInvalidated=false
			//trace(this, this.name, ">>>>> calliing upC")
			dispatchUpdateComplete();
			
		}
		
		var _creationCompleteFired:Bool ;
		
		public function getCreationCompleteFired():Bool{
			return _creationCompleteFired;
		}
		
		function dispatchUpdateComplete():Void{
			dispatchEvent(new PyroEvent(PyroEvent.UPDATE_COMPLETE));
			if(!_creationCompleteFired){
				if(this._isVisible){
					this.visible = true;
				}
				dispatchEvent(new PyroEvent(PyroEvent.CREATION_COMPLETE));
				_creationCompleteFired = true;
			}
		}
		
		var _isVisible:Bool ;
		public override function setVisible(value:Bool):Bool{
			this._isVisible = value;
			super.visible =value
			return value;
		}
		
		public function resizeHandler():Void{
			//trace('resize');
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * The updateDisplayList is triggered everytime the framework
		 * determines that some event has taken place that needs the
		 * UI to be refreshed.
		 * 
		 * @param unscaledWidth		The computed width of the control
		 * @param unscaledHeight	The computed height of the control
		 */ 
		public function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void{
			
			//trace("[fr: "+GlobalTimer.getFrameNumber()+"]["+this+"]["+this.name+"] ---> redraw: "+unscaledWidth,unscaledHeight)
			/*for(var i:uint=0; i<this.numChildren; i++)
			{
				var child:MeasurableControl = getChildAt(i) as MeasurableControl;
				if(child)
				{
					child.updateDisplayList(unscaledWidth, unscaledHeight);
				}
			}*/
		}
		
		/**
		 * Returns the explicitly defined width or the measured
		 * number computed by the <code>measure</code> function.
		 * 
		 */ 
		public function getExplicitOrMeasuredWidth():Float{
			if(!isNaN(this._explicitWidth)){
				return _explicitWidth	
			}
			else{
				return _measuredWidth
			}
		}
		
		/**
		 * Returns the explicitly defined height or the measured
		 * height computed by the <code>measure</code> function.
		 */ 
		public function getExplicitOrMeasuredHeight():Float{
			if(!isNaN(this._explicitHeight)){
				return _explicitHeight	
			}
			else{
				return _measuredHeight
			}
		}
		
		function onRemovedFromParent(event:Event):Void{
			this.addEventListener(Event.ADDED, onAddedToParent);
		}
		
		
		///////// Utils ///////////
		
		public function cancelMouseEvents():Void{
			this.addEventListener(MouseEvent.MOUSE_OVER, disableEvent, true, 1,true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, disableEvent, true, 1,true);
			this.addEventListener(MouseEvent.MOUSE_OUT, disableEvent, true, 1,true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, disableEvent, true, 1,true);
			//this.addEventListener(MouseEvent.MOUSE_UP, disableEvent, true, 1,true);
			this.addEventListener(MouseEvent.CLICK, disableEvent, true, 1,true);
			_mouseActionsDisabled = true
			
		}	
		
		public function enableMouseEvents():Void{
			//this.removeEventListener(MouseEvent.MOUSE_UP, disableEvent,true);
			this.removeEventListener(MouseEvent.MOUSE_OVER, disableEvent,true);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, disableEvent,true);
			this.removeEventListener(MouseEvent.MOUSE_OUT, disableEvent,true);
			this.removeEventListener(MouseEvent.CLICK, disableEvent,true);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, disableEvent,true);
			_mouseActionsDisabled = false;
		}
		
		function disableEvent(event:Event):Void{
			event.stopImmediatePropagation()
			event.preventDefault()
		}
		
		var _mouseActionsDisabled:Bool ;
		public function getMouseActionsDisabled():Bool{
			return _mouseActionsDisabled;
		}
		
		/**
		 * Utility function to check if a mouseEvent happened
		 * while the mouse was over the displayObject
		 */
		 public function isMouseOver(event:MouseEvent):Bool{
		 	if(event.localX < this.width && event.localX > 0 && 
			event.localY < this.height && event.localY > 0){
				return true
			}
			else{
				return false
			}
		 } 
		
		
		/**
		 * @private
		 * Since the addChild function is overridden in all MeasurableControls,
		 * this function is defined to keep the native implementation available
		 */ 
		public function _S_addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		/**
		 * @private
		 * Since the addChild function is overridden in all MeasurableControls,
		 * this function is defined to keep the native implementation available
		 */ 
		public function _S_addChildAt(child:DisplayObject, index:Int):DisplayObject
		{
			return super.addChildAt(child,index);
		}
		
		var _includeInLayout:Bool public function setIncludeInLayout(value:Bool):Bool{
			_includeInLayout = value
			return value;
		}
		
		public function getIncludeInLayout():Bool{
			return _includeInLayout;
		}
		
		public function setActualSize(w:Float, h:Float):Void
		{
			this._explicitHeight = w;
			this._explicitHeight = h;
			this.validateSize()
			this.validateDisplayList()
		}
		
		
		public function get_S_width():Float{
			return super.width
		}
		
		public function set_S_width(w:Float):Float{
			super.width = w;
			return w;
		}
		
		public function get_S_height():Float{
			return super.height
		}
		
		public function set_S_height(h:Float):Float{
			super.height = h;
			return h;
		}
		
	}
