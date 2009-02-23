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
		public var mheight(getHeight, setHeight) : Float;
		public var includeInLayout(getIncludeInLayout, setIncludeInLayout) : Bool;
		public var maximumHeight(getMaximumHeight, setMaximumHeight) : Float;
		public var maximumWidth(getMaximumWidth, setMaximumWidth) : Float;
		public var measuredHeight(getMeasuredHeight, setMeasuredHeight) : Float ;
		public var measuredWidth(getMeasuredWidth, setMeasuredWidth) : Float ;
		public var mouseActionsDisabled(getMouseActionsDisabled, null) : Bool;
		public var parentContainer(getParentContainer, setParentContainer) : UIControl ;
		public var percentHeight(getPercentHeight, setPercentHeight) : Float ;
		public var percentUnusedHeight(getPercentUnusedHeight, setPercentUnusedHeight) : Float;
		public var percentUnusedWidth(getPercentUnusedWidth, setPercentUnusedWidth) : Float;
		public var percentWidth(getPercentWidth, setPercentWidth) : Float ;
		public var usesMeasurementStrategy(getUsesMeasurementStrategy, null) : Bool;
		public var mvisible(getVisible, setVisible) : Bool;
		public var mwidth(getWidth, setWidth) : Float;

		public var initialized:Bool ;

		var _explicitWidth:Float;
		var _explicitHeight:Float;

		var _maximumWidth:Float;
		var _maximumHeight:Float;

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
	
		var _percentWidth:Float;
		var _percentHeight:Float;

		var _parentContainer:UIControl;

		/**
		 * The flag to mark that the control's size
		 * has been invalidated. This means the control
		 * is now waiting for a validateSize call.
		 */ 
		public var sizeInvalidated:Bool;

	    var _measuredWidth:Float;
		var _measuredHeight:Float;
		
		var _dimensionsChanged:Bool;

	    /**
		 * Flag to mark a dirty displaylist. It basically means it is
		 * waiting for a call to updateDisplayList at some point
		 */ 
		public var displayListInvalidated:Bool;
		
		public var forceInvalidateDisplayList:Bool;
		
		var _creationCompleteFired:Bool ;

		var _isVisible:Bool ;
		var _mouseActionsDisabled:Bool ;

		var _includeInLayout:Bool;

		public function new(){
            super();
			this.addEventListener(Event.ADDED, onAddedToParent);
			visible = false;
            initialized = false;
            _explicitWidth = Math.NaN;
            _explicitHeight = Math.NaN;
            _maximumWidth = Math.NaN;
            _maximumHeight = Math.NaN;
    		_percentUnusedWidth = Math.NaN;
		    _percentUnusedHeight = Math.NaN;
	        needsMeasurement = true;
            _percentWidth = Math.NaN;
            _percentHeight = Math.NaN;
		    _parentContainer = null;
            sizeInvalidated = false;
            _measuredWidth = Math.NaN;
            _measuredHeight = Math.NaN;
            _dimensionsChanged = true;
            displayListInvalidated = true;
            forceInvalidateDisplayList = false;
            _creationCompleteFired = false;
            _isVisible = true;
            _mouseActionsDisabled = false;
            _includeInLayout = true;
		}
		
		
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
		inline function setExplicitWidth(w:Float):Float{
			_explicitWidth = w;	
			return w;
		}
		
		/**
		 * @private
		 */ 
		inline function getExplicitWidth():Float{
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
		inline function setExplicitHeight(h:Float):Float{
			_explicitHeight = h;	
			return h;
		}
		
		/**
		 * @private
		 */ 
		inline function getExplicitHeight():Float{
			return _explicitHeight;	
		}
		
		/**
		 * Set/get the width of the control. If the width
		 * is set to a different value from the one the 
		 * control is already at, it triggers the size 
		 * invalidation cycle
		 */ 
		function setWidth(n:Float):Float{
			if(n == _explicitWidth) return n;
			n = Math.floor(n);
			this._explicitWidth = n;
			_dimensionsChanged = true;
			displayListInvalidated = true;
			if(!initialized) return Math.NaN;
			invalidateSize();
			return n;
		}
		
		/**
		 * @private 
		 */ 
		inline function getWidth():Float{
			return this.getExplicitOrMeasuredWidth();
		}
		
		/**
		 * Set/get the height of the control. If the height
		 * is set to a different value from the one the 
		 * control is already at, it triggers the size 
		 * invalidation cycle
		 */ 
		function setHeight(n:Float):Float{
			if (n == _explicitHeight) return n;
			n = Math.floor(n);
			this._explicitHeight = n;
			displayListInvalidated = true;
			_dimensionsChanged=true;	
			if(!initialized) return Math.NaN;
			invalidateSize();
			//invalidateDisplayList();
			return n;
		}
		
		/**
		 * @private
		 */ 
		inline function getHeight():Float{
			return this.getExplicitOrMeasuredHeight();
		}
		
		function setMaximumWidth(n:Float):Float{
			_maximumWidth = n;
			invalidateSize();
			return n;
		}
		
		inline function getMaximumWidth():Float{
			return _maximumWidth;
		}
		
		public function setMaximumHeight(n:Float):Float{
			_maximumHeight = n;
			invalidateSize();
			return n;
		}
		
		inline public function getMaximumHeight():Float{
			return _maximumHeight;
		}
		
		
		/**
		 * Set/get the percent width. If the value is 
		 * different from the earlier, it sets the measurement 
		 * flag and calls invalidateSize
		 */ 
		function setPercentUnusedWidth(w:Float):Float{
			if(w == _percentUnusedWidth) return w;
			_percentUnusedWidth = w;
			if(!initialized) return Math.NaN;
            trace("invalidateSize");
			invalidateSize();
			return w;
		}
		
		/**
		 * @private
		 */ 
		inline function getPercentUnusedWidth():Float{
			return _percentUnusedWidth;
		}
		
		/**
		 * Set/get the percent height. If the value is 
		 * different from the earlier, it sets the measurement 
		 * flag and calls invalidateSize
		 */ 
		function setPercentUnusedHeight(h:Float):Float{
			if(h==_percentUnusedHeight) return h;
			//needsMeasurement = true;
			_percentUnusedHeight = h;
			if(!initialized) return Math.NaN;
			this.invalidateSize();
			return h;
		}
		
		function setPercentWidth(w:Float):Float {
			if(w==_percentWidth) return w;
			_percentWidth = w;
			if(!initialized) return Math.NaN;
			this.invalidateSize();
			return w;
		}
		
		inline public function getPercentWidth():Float {
			return _percentWidth;
		}
		
		function setPercentHeight(h:Float):Float {
			if(h==_percentHeight) return h;
			_percentHeight = h;
			if(!initialized) return Math.NaN;
			this.invalidateSize();
			return h;
		}
		
		inline function getPercentHeight():Float {
			return _percentHeight;
		}
		
		/**
		 * @private
		 */ 
		inline function getPercentUnusedHeight():Float{
			return _percentUnusedHeight;
		}
		
		
		inline function setParentContainer(c:UIControl):UIControl {
			this._parentContainer = c;
			return c;
		}
		
		inline function getParentContainer():UIControl {
			return _parentContainer;
		}
		
	
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
			if(this._parentContainer != null){
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
		inline function getUsesMeasurementStrategy():Bool{
			return (Math.isNaN(this._explicitHeight) || Math.isNaN(this._explicitWidth));
            /*
			if(Math.isNaN(this._explicitHeight) || Math.isNaN(this._explicitWidth)){
				return true;
			}
			else{
				return false;
			}
            */
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
                measure();
                checkDisplayListValidation();
                sizeInvalidated=false;
			}	
			else{
				sizeInvalidated=false;
				if(displayListInvalidated){
					queueValidateDisplayList();
				}
			}
			
			//sizeInvalidated=false;
			
			for(j in 0...this.numChildren){
                var c = this.getChildAt(j);
                if(Std.is(c, MeasurableControl)){
                    cast(c, MeasurableControl).validateSize();
				    cast(c, MeasurableControl).dispatchEvent(new PyroEvent(PyroEvent.SIZE_VALIDATED));	
                }
                /*
				var child:MeasurableControl = cast( this.getChildAt(j), MeasurableControl);
				if(child == null) continue;
				child.validateSize();
				child.dispatchEvent(new PyroEvent(PyroEvent.SIZE_VALIDATED));	
                */
			}
		}
		
		/**
		 * The event listener executed when this component 
		 * has been added to the parent.
		 */ 
		function onAddedToParent(event:Event):Void{
			if(this.parent == null) return;
			this.removeEventListener(Event.ADDED, onAddedToParent);
			this.addEventListener(Event.REMOVED, onRemovedFromParent,false,0,true);

            if(Std.is(this.parent, UIControl)){
			    _parentContainer = cast( this.parent, UIControl);
            } else {
                _parentContainer = null;
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
			if(Math.isNaN(this._explicitWidth))
			{
				calculateMeasuredWidth();
			}
			if(Math.isNaN(this._explicitHeight))
			{
				calculateMeasuredHeight();
			}
			this.needsMeasurement=false;
		}
		
		function calculateMeasuredWidth():Void
		{
			if(!Math.isNaN(this._percentUnusedWidth) && this._parentContainer != null)
			{
				var computedWidth:Float = this._parentContainer.widthForMeasurement()*this._percentUnusedWidth/100;
				if(!Math.isNaN(_maximumWidth)){
					computedWidth = Math.min(_maximumWidth, computedWidth);
				}
				measuredWidth = computedWidth;
			}
			else if(!Math.isNaN(this._percentWidth) && this._parentContainer != null)
			{
				this.measuredWidth = this._parentContainer.mwidth*this._percentWidth/100;
			}
		}
		
		function calculateMeasuredHeight():Void
		{
			if(!Math.isNaN(this._percentUnusedHeight) && this._parentContainer != null)
			{
				this.measuredHeight = this._parentContainer.heightForMeasurement()*this._percentUnusedHeight/100;	
			}
			else if(!Math.isNaN(this._percentHeight) && this._parentContainer != null)
			{
				this.measuredHeight = this._parentContainer.mheight*this._percentHeight/100;
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
			if(h == _measuredHeight) return h;
			_measuredHeight = h;
			displayListInvalidated = true;
			_dimensionsChanged = true;
			return h;
		}
		
		
		
		/**
		 * @private
		 */ 
		inline function getMeasuredHeight():Float
		{
			return _measuredHeight;
		}
		
		public function setMeasuredWidth(w:Float):Float
		{
			if(w  == _measuredWidth) return w;
			_measuredWidth = w;
			displayListInvalidated = true;
			_dimensionsChanged = true;
			return w;
		}
		
		/**
		 * @private
		 */ 
		function getMeasuredWidth():Float
		{
			return _measuredWidth;
		}
		

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
				queueValidateDisplayList();
			}	
		}
		
		/**
		 */ 
		public function queueValidateDisplayList():Void{
			
			if(this._parentContainer != null && _dimensionsChanged){
				_parentContainer.queueValidateDisplayList();
			}else{
				this.addEventListener(Event.ENTER_FRAME, validateDisplayList);
				
			}
		}
		
		/**
		 * validateDisplayList is called as a response to invalidateDisplayList.
		 */ 
		public function validateDisplayList(?event:Event=null):Void{
			
			if(Math.isNaN(this.getExplicitOrMeasuredWidth()) || Math.isNaN(this.getExplicitOrMeasuredHeight())){
				return;
			}
			if(event != null){
				this.removeEventListener(Event.ENTER_FRAME,validateDisplayList);
			}
			for(j in 0...this.numChildren){
                var c = this.getChildAt(j);
                if(Std.is(c, MeasurableControl)){
                    cast(c, MeasurableControl).validateDisplayList();
                }
                /*
				var child:MeasurableControl = cast( this.getChildAt(j), MeasurableControl);
				if(child == null) continue;
				child.validateDisplayList();
                */
			}
			this.updateDisplayList(this.getExplicitOrMeasuredWidth(), this.getExplicitOrMeasuredHeight());
			if(_dimensionsChanged){
				_dimensionsChanged = false;
				resizeHandler();
			}
			this.displayListInvalidated=false;
			//trace(this, this.name, ">>>>> calliing upC")
			dispatchUpdateComplete();
		}
		
		inline function getCreationCompleteFired():Bool{
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

        inline function getVisible():Bool {
            return this._isVisible;
        }

		function setVisible(value:Bool):Bool{
			this._isVisible = value;
			visible = value;
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
			if(!Math.isNaN(this._explicitWidth)){
				return _explicitWidth;
			}
			else{
				return _measuredWidth;
			}
		}
		
		/**
		 * Returns the explicitly defined height or the measured
		 * height computed by the <code>measure</code> function.
		 */ 
		public function getExplicitOrMeasuredHeight():Float{
			if(!Math.isNaN(this._explicitHeight)){
				return _explicitHeight;	
			}
			else{
				return _measuredHeight;
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
			_mouseActionsDisabled = true;
			
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
			event.stopImmediatePropagation();
			event.preventDefault();
		}
		
		inline function getMouseActionsDisabled():Bool{
			return _mouseActionsDisabled;
		}
		
		/**
		 * Utility function to check if a mouseEvent happened
		 * while the mouse was over the displayObject
		 */
		 public function isMouseOver(event:MouseEvent):Bool{
		 	if(event.localX < this.mwidth && event.localX > 0 && 
			event.localY < this.mheight && event.localY > 0){
				return true;
			}
			else{
				return false;
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
		
        inline function setIncludeInLayout(value:Bool):Bool{
			_includeInLayout = value;
			return value;
		}
		
		inline function getIncludeInLayout():Bool{
			return _includeInLayout;
		}
		
		public function setActualSize(w:Float, h:Float):Void
		{
			this._explicitHeight = w;
			this._explicitHeight = h;
			this.validateSize();
			this.validateDisplayList();
		}
		
		
		public function get_S_width():Float{
			return width;
		}
		
		public function set_S_width(w:Float):Float{
			width = w;
			return w;
		}
		
		public function get_S_height():Float{
			return height;
		}
		
		public function set_S_height(h:Float):Float{
			height = h;
			return h;
		}
		
	}
