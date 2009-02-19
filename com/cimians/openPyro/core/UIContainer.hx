package com.cimians.openPyro.core;
	import com.cimians.openPyro.controls.ScrollBar;
	import com.cimians.openPyro.controls.events.ScrollEvent;
	import com.cimians.openPyro.controls.skins.IScrollableContainerSkin;
	import com.cimians.openPyro.events.PyroEvent;
	import com.cimians.openPyro.layout.AbsoluteLayout;
	import com.cimians.openPyro.layout.IContainerMeasurementHelper;
	import com.cimians.openPyro.layout.ILayout;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * UIContainers extend UIControls and introduce
	 * the concept of scrolling and layouts. If the 
	 * bounds of the children of a UIContainer, they
	 * get clipped by the mask layer on top.
	 * 
	 * todo: Create UIContainer.clipContent = false/true function 
	 * 
	 * @see #layout
	 */ 
	class UIContainer extends UIControl {
		
		
		
		public var clipContent(getClipContent, setClipContent) : Bool
		;
		
		public var contentHeight(getContentHeight, null) : Float;
		
		public var explicitlyAllocatedHeight(getExplicitlyAllocatedHeight, setExplicitlyAllocatedHeight) : Float
		;
		
		public var explicitlyAllocatedWidth(getExplicitlyAllocatedWidth, setExplicitlyAllocatedWidth) : Float
		;
		
		public var horizontalScrollBar(getHorizontalScrollBar, null) : ScrollBar
		;
		
		public var horizontalScrollIncrement(getHorizontalScrollIncrement, setHorizontalScrollIncrement) : Float;
		
		public var horizontalScrollPolicy(getHorizontalScrollPolicy, setHorizontalScrollPolicy) : Bool;
		
		public var horizontalScrollPosition(getHorizontalScrollPosition, setHorizontalScrollPosition) : Float;
		
		public var layout(getLayout, setLayout) : ILayout;
		
		public var layoutChildren(getLayoutChildren, null) : Array<Dynamic>
		;
		
		public var scrollHeight(getScrollHeight, null) : Float
		;
		
		public var scrollWidth(getScrollWidth, null) : Float
		;
		
		public var verticalScrollBar(getVerticalScrollBar, setVerticalScrollBar) : ScrollBar;
		
		public var verticalScrollIncrement(getVerticalScrollIncrement, setVerticalScrollIncrement) : Float;
		
		public var verticalScrollPolicy(getVerticalScrollPolicy, setVerticalScrollPolicy) : Bool;
		
		public var verticalScrollPosition(getVerticalScrollPosition, setVerticalScrollPosition) : Float;
		
		var contentPane:UIControl;
		var _horizontalScrollPolicy:Bool var _verticalScrollPolicy:Bool ;
		
		public function new(){
			
			_horizontalScrollPolicy = true
		;
			_verticalScrollPolicy = true;
			super();
			contentPane = new UIControl();
			contentPane.name = "contentPane_"+this.name
		}
		
		/**
		 * @inheritDoc
		 */ 
		public override function initialize():Void
		{
			/*
			Since the first time the container is
			validated, it may cause scrollbars to 
			be added immediately, the contentPane
			is added before any of that so that 
			scrollbars are not placed under it
			*/
			_S_addChild(contentPane);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			
			super.initialize();
			
			contentPane.percentUnusedWidth = 100;
			contentPane.percentUnusedHeight = 100;
			contentPane.doOnAdded()
		//	this.mask = this.maskShape;

		}
		
		public function setHorizontalScrollPolicy(b:Bool):Bool{
			_horizontalScrollPolicy = b;
			return b;
		}
		public function getHorizontalScrollPolicy():Bool{
			return _horizontalScrollPolicy
		}
		
		public function setVerticalScrollPolicy(b:Bool):Bool{
			_verticalScrollPolicy = b;
			return b;
		}
		
		public function getVerticalScrollPolicy():Bool{
			return _verticalScrollPolicy;
		}
		
		
		public override function addChildAt(child:DisplayObject, index:Int):DisplayObject
		{
			var ch:DisplayObject = contentPane.addChild(child);
			if(Std.is( child, MeasurableControl))
			{
				var component:MeasurableControl = MeasurableControl(child)
				component.parentContainer = this;
				component.addEventListener(PyroEvent.UPDATE_COMPLETE, onChildUpdateComplate);
				component.doOnAdded()
				
			}
			return ch;
		}
		
		function onChildUpdateComplate(event:PyroEvent):Void
		{
			/*for(var i:uint=0; i<this.layoutChildren.length; i++)
			{
				var d:MeasurableControl = layoutChildren[i]
				trace( i+": "+d.width);
			}
			trace(" -------- ")
			*/
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			var ch:DisplayObject = contentPane.addChild(child);
			if(Std.is( child, MeasurableControl))
			{
				var component:MeasurableControl = MeasurableControl(child)
				component.parentContainer = this;
				component.addEventListener(PyroEvent.UPDATE_COMPLETE, onChildUpdateComplate);
				component.doOnAdded()
			}
			return ch;
		}
		
		
		public override function getChildByName(name:String):DisplayObject{
			return contentPane.getChildByName(name);
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject{
			return contentPane.removeChild(child)
		}
		
		public function removeAllChildren():Void{
			while(this.contentPane.numChildren>0){
				contentPane.removeChildAt(0);
			}
		}
		
		override function doChildBasedValidation():Void
		{
			var child:DisplayObject;
			if(isNaN(this._explicitWidth) && isNaN(this._percentWidth) && isNaN(_percentUnusedWidth))
			{
				super.measuredWidth = _layout.getMaxWidth(this.layoutChildren) + _padding.left + _padding.right;
			}
			if(isNaN(this._explicitHeight) && isNaN(this._percentHeight) && isNaN(_percentUnusedHeight))
			{
				super.measuredHeight = _layout.getMaxHeight(this.layoutChildren) + _padding.top + _padding.bottom;
			}
		}
		
		
		var _explicitlyAllocatedWidth:Int ;
		var _explicitlyAllocatedHeight:Int ;
		
		/**
		 * This property are modified by IContainerMeasurementHelpers.
		 * which most container layouts implement.
		 * 
		 * @see com.cimians.openPyro.layout.IContainerMeasurementHelper 
		 */ 
		public function setExplicitlyAllocatedWidth(w:Float):Float
		{
			_explicitlyAllocatedWidth = w;
			return w;
		}
		
		/**
		 * @private
		 */ 
		public function getExplicitlyAllocatedWidth():Float
		{
			return _explicitlyAllocatedWidth ;
		}
		
		/**
		 * This property are modified by IContainerMeasurementHelpers.
		 * which most container layouts implement.
		 * 
		 * @see com.cimians.openPyro.layout.IContainerMeasurementHelper 
		 */ 
		public function setExplicitlyAllocatedHeight(h:Float):Float
		{
			_explicitlyAllocatedHeight = h;
			return h;
		}
		
		/**
		 * @private
		 */ 
		public function getExplicitlyAllocatedHeight():Float
		{
			return _explicitlyAllocatedHeight;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * If validateSize is called on UIContainers, the container does
		 * a check at the end to see if the children layout requires a 
		 * scroll and if the scrollbar needs to be created. If so, it
		 * creates the scrollbars and calls validateSize again.
		 */ 
		public override function validateSize():Void
		{
			_explicitlyAllocatedWidth = _padding.left+_padding.right
			_explicitlyAllocatedHeight = _padding.top+_padding.bottom;
			var layoutChildrenArray:Array<Dynamic> = layoutChildren;
			
			_layout.initX = this.padding.left;
			_layout.initY = this.padding.top;
			
			if(Std.is( _layout, IContainerMeasurementHelper))
			{
				IContainerMeasurementHelper(_layout).calculateSizes(layoutChildrenArray, this)
			}
			super.validateSize();
			
			if(this._verticalScrollBar && _verticalScrollBar.visible)
			{
				this.explicitlyAllocatedWidth-=_verticalScrollBar.width
				_verticalScrollBar.setScrollProperty(this.scrollHeight, this._contentHeight);
			}
			
			if(this._horizontalScrollBar && _horizontalScrollBar.visible)
			{
				this.explicitlyAllocatedHeight-=_horizontalScrollBar.height
				_horizontalScrollBar.setScrollProperty(this.scrollWidth, contentWidth);	
			}
			
			if(_verticalScrollBar)
			{
				if(_horizontalScrollBar && _horizontalScrollBar.visible){
					_verticalScrollBar.setActualSize(_verticalScrollBar.width,this.height - _horizontalScrollBar.height);	
				}
				else{
					_verticalScrollBar.setActualSize(_verticalScrollBar.width,this.height)
				}
			}
			if(_horizontalScrollBar)
			{
				if(_verticalScrollBar && _verticalScrollBar.visible)
				{
					//_horizontalScrollBar.width = this.width-_verticalScrollBar.width
					_horizontalScrollBar.setActualSize(this.width-_verticalScrollBar.width, _horizontalScrollBar.height)
				}
				else{
					_horizontalScrollBar.setActualSize(this.width, _horizontalScrollBar.height);
				}
			}
			checkRevalidation()	
		}
		
		var _layout:ILayout var layoutInvalidated:Bool ;
		/**
		 * Containers can be assigned different layouts
		 * which control the positioning of the 
		 * different controls.
		 * 
		 * @see com.cimians.openPyro.layout
		 */ 
		public function getLayout():ILayout{
			return _layout;
		}
		
		/**
		 * @private
		 */ 
		public function setLayout(l:ILayout):ILayout{
			if(_layout == l) return
			layoutInvalidated = true;
			_layout = l;
			_layout.container = this;
			if(!initialized) return;
			
			this.invalidateSize()
			return l;
		}
		
		/**
		 * Returns an Array of displayObjects whose positions
		 * are controlled by the <code>ILayout</code> object.
		 * These do not include, for example, the scrollbars.
		 * 
		 * @see com.cimians.openPyro.layout
		 */ 
		public function getLayoutChildren():Array<Dynamic>
		{
			var children:Array<Dynamic> = new Array();
			if(!contentPane) return children;
			for(i in 0...this.contentPane.numChildren)
			{
				var child:MeasurableControl = cast( contentPane.getChildAt(i), MeasurableControl)
				if(!child || !child.includeInLayout) continue
				children.push(child);
			}
			return children;
		}
		
		/////////// END LAYOUT ///////////
		
		/**
		 * @inheritDoc
		 */ 
		public override function widthForMeasurement():Float
		{
			var containerWidth:Float = this.width - this._explicitlyAllocatedWidth
			if(this._verticalScrollBar && _verticalScrollBar.visible==true)
			{
				containerWidth-=_verticalScrollBar.width;
			}
			return containerWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function heightForMeasurement():Float
		{
			var containerHeight:Float =  this.height-this._explicitlyAllocatedHeight;
			if(this._horizontalScrollBar && _horizontalScrollBar.visible==true)
			{
				containerHeight-=_horizontalScrollBar.height;
			}
			return containerHeight;
		}
		
		/**
		 * scrollWidth is the max width a horizontal 
		 * scrollbar needs to scroll
		 */ 
		public function getScrollWidth():Float
		{
			var containerWidth:Float = this.width-padding.left-padding.right
			if(this._verticalScrollBar && _verticalScrollBar.visible==true)
			{
				containerWidth-=_verticalScrollBar.width;
			}
			return containerWidth;
		}
		
		/**
		 * scrollHeight is the max height a vertical 
		 * scrollbar needs to scroll
		 */ 
		public function getScrollHeight():Float
		{
			var containerHeight:Float =  this.height-padding.top-padding.bottom;
			if(this._horizontalScrollBar && _horizontalScrollBar.visible==true)
			{
				containerHeight-=_horizontalScrollBar.height;
			}
			return containerHeight;
		}
		
		var _verticalScrollBar:ScrollBar;
		var _horizontalScrollBar:ScrollBar;
		
		/**
		 * Returns The instance of the created verticalScrollBar
		 * or null if it was never created or is not visible. Note
		 * that this function does cannot be used to detect if the
		 * scrollbar was created or not, since scrollbars once 
		 * created are never distroyed, even if a subsequent change
		 * in the container's layout does not require the scrollbar
		 * anymore.
		 */ 
		public function getVerticalScrollBar():ScrollBar{
			if(_verticalScrollBar && _verticalScrollBar.visible)
			{
				return _verticalScrollBar
			}
			else
			{
				return null;
			}
		}
		
		
		/**
		 * Returns The instance of the created horizontal
		 * or null if it was never created or is not visible. Note
		 * that this function does cannot be used to detect if the
		 * scrollbar was created or not, since scrollbars once 
		 * created are never distroyed, even if a subsequent change
		 * in the container's layout does not require the scrollbar
		 * anymore.
		 */ 
		public function getHorizontalScrollBar():ScrollBar
		{
			if(_horizontalScrollBar && _horizontalScrollBar.visible)
			{
				return _horizontalScrollBar
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * @private
		 */ 
		public function setVerticalScrollBar(scrollBar:ScrollBar):ScrollBar{
			if(_verticalScrollBar)
			{
				_verticalScrollBar.removeEventListener(ScrollEvent.SCROLL, onVerticalScroll);
				_verticalScrollBar.removeEventListener(PyroEvent.UPDATE_COMPLETE, onVScrollBarUpdateComplete)
				_verticalScrollBar.removeEventListener(PyroEvent.SIZE_VALIDATED, onVerticalScrollBarSizeValidated)
			}
			_verticalScrollBar = scrollBar;
			addChild(scrollBar);
			if(this._contentHeight > this.height)
			{
				setVerticalScrollBar();
			}
			return scrollBar;
		}
		
		var scrollBarsChanged:Bool ;
		
		function checkRevalidation():Void
		{
			if(_horizontalScrollPolicy){
				checkNeedsHScrollBar()
			}
			if(_verticalScrollPolicy)
			{
				checkNeedsVScrollBar()
			}
			
			if(needsHorizontalScrollBar && 
					this._skin && 
					Std.is( this._skin, IScrollableContainerSkin) && 
					IScrollableContainerSkin(_skin).horizontalScrollBarSkin)
			{
				if(!_horizontalScrollBar)
				{
					createHScrollBar();
				}
				if(_horizontalScrollBar.visible==false)
				{
					_horizontalScrollBar.visible = true;
					scrollBarsChanged = true;
				}
			}
			else
			{
				if(_horizontalScrollBar && _horizontalScrollBar.visible==true)
				{
					_horizontalScrollBar.visible = false;
					scrollBarsChanged = true;
				}
			}
			if(needsVerticalScrollBar && 
				this._skin && 
				Std.is( this._skin, IScrollableContainerSkin) && 
				IScrollableContainerSkin(_skin).verticalScrollBarSkin)
			{
				if(!_verticalScrollBar)
				{
					createVScrollBar();
				}
				if(_verticalScrollBar.visible == false)
				{
					_verticalScrollBar.visible = true;
					scrollBarsChanged=true;
				}
			}
			else
			{
				if(_verticalScrollBar && _verticalScrollBar.visible == true)
				{
					_verticalScrollBar.visible = false;
					scrollBarsChanged = true;
				}
			}
			
			if(scrollBarsChanged)
			{
				scrollBarsChanged = false;
				dispatchEvent(new PyroEvent(PyroEvent.SCROLLBARS_CHANGED));
				validateSize();
			}
		}
			
		var _contentHeight:Int ;
		var contentWidth:Int ;
		
		public function getContentHeight():Float{
			return _contentHeight;
		}
		
		var needsVerticalScrollBar:Bool ;
		var needsHorizontalScrollBar:Bool ;
		
		function checkNeedsVScrollBar():Void
		{
			_contentHeight = this._layout.getMaxHeight(this.layoutChildren);
			if(_contentHeight > this.height){
				needsVerticalScrollBar = true
			}
			else{
				needsVerticalScrollBar = false;
			}
		}
		function checkNeedsHScrollBar():Void
		{
			contentWidth = this._layout.getMaxWidth(this.layoutChildren);
			if(contentWidth > this.width){
				needsHorizontalScrollBar = true
			}
			else{
				needsHorizontalScrollBar = false;
			}
		}
		
		function createVScrollBar():Void
		{
			_verticalScrollBar = new ScrollBar(Direction.VERTICAL);
			_verticalScrollBar.maximum = 1;
			_verticalScrollBar.minimum = 0;
			_verticalScrollBar.incrementalScrollDelta = _verticalScrollIncrement;
			_verticalScrollBar.name = "vscrollbar_"+this.name;
			_verticalScrollBar.width = 15;
			_verticalScrollBar.addEventListener(PyroEvent.SIZE_VALIDATED, onVerticalScrollBarSizeValidated);
			_verticalScrollBar.addEventListener(PyroEvent.UPDATE_COMPLETE, onVScrollBarUpdateComplete);
			_verticalScrollBar.skin = IScrollableContainerSkin(_skin).verticalScrollBarSkin;
			_verticalScrollBar.addEventListener(ScrollEvent.SCROLL, onVerticalScroll)
			_verticalScrollBar.doOnAdded()
			_verticalScrollBar.visible = false;
			_S_addChild(_verticalScrollBar);
		}
		
		function hideVScrollBar():Void
		{
			if(_verticalScrollBar)
			{
				_verticalScrollBar.visible=false;
			}
		}
			
		function createHScrollBar():Void
		{
			_horizontalScrollBar = new ScrollBar(Direction.HORIZONTAL);
			_horizontalScrollBar.maximum = 1
			_horizontalScrollBar.minimum = 0
			_horizontalScrollBar.incrementalScrollDelta = _horizontalScrollIncrement
			_horizontalScrollBar.name = "hscrollbar_"+this.name;
			_horizontalScrollBar.height = 15;
			_horizontalScrollBar.addEventListener(PyroEvent.SIZE_VALIDATED, onHorizontalScrollBarSizeValidated)
			_horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, onHorizontalScroll);
			_horizontalScrollBar.parentContainer = this;
			_horizontalScrollBar.doOnAdded()
			_horizontalScrollBar.skin = IScrollableContainerSkin(_skin).horizontalScrollBarSkin;	
			_horizontalScrollBar.visible = false;
			_S_addChild(_horizontalScrollBar);	
		}
		
		function onHorizontalScrollBarSizeValidated(event:PyroEvent):Void
		{
			_horizontalScrollBar.removeEventListener(PyroEvent.SIZE_VALIDATED, onHorizontalScrollBarSizeValidated)
			_horizontalScrollBar.setScrollProperty(this.scrollWidth, contentWidth);	
		}
		
		function onVerticalScrollBarSizeValidated(event:PyroEvent):Void
		{
			_verticalScrollBar.removeEventListener(PyroEvent.SIZE_VALIDATED, onVerticalScrollBarSizeValidated)
			_verticalScrollBar.setScrollProperty(this.scrollWidth, contentWidth);
		}
		
		function hideHScrollBar():Void
		{
			if(_horizontalScrollBar)
			{
				_horizontalScrollBar.visible=false;
			}
		}
		
		function setVerticalScrollBar():Void{
			if(_verticalScrollBar.parent != this)
			{
				addChild(_verticalScrollBar);
			}
			_verticalScrollBar.height = this.height;
		}
		
		function handleMouseWheel(event:MouseEvent):Void{
			if(this.verticalScrollBar){
				var scrollDelta:Float = verticalScrollBar.value - event.delta*.02;
				scrollDelta = Math.min(scrollDelta, 1)
				scrollDelta = Math.max(0, scrollDelta);
				verticalScrollBar.value = scrollDelta;
			}
		}
		
		public function setHorizontalScrollPosition(value:Float):Float{
			if(!_horizontalScrollBar) return
			if(value > 1){
				throw new Error("UIContainer scrollpositions range from 0 to 1")
			}
			this._horizontalScrollBar.value = value;
			return value;
		}
		
		public function getHorizontalScrollPosition():Float{
			return _horizontalScrollBar.value;
		}
		
		var _horizontalScrollIncrement:Int ;
		public function setHorizontalScrollIncrement(n:Float):Float{
			_horizontalScrollIncrement = n;
			if(_horizontalScrollBar){
				_horizontalScrollBar.incrementalScrollDelta = n;
			}
			return n;
		}
		
		public function getHorizontalScrollIncrement():Float{
			return _horizontalScrollIncrement
		}
		
		var _verticalScrollIncrement:Int ;
		public function setVerticalScrollIncrement(n:Float):Float{
			_verticalScrollIncrement = n;
			if(_verticalScrollBar){
				_verticalScrollBar.incrementalScrollDelta = n;
			}
			return n;
		}
		
		public function getVerticalScrollIncrement():Float{
			return _verticalScrollIncrement
		}
		
		
		/**
		 * Sets the scrollposition of the vertical scrollbar
		 * The valid values are between 0 and 1 
		 */ 
		public function setVerticalScrollPosition(value:Float):Float{
			if(!_verticalScrollBar) return;
			if(value > 1){
				throw new Error("UIContainer scrollpositions range from 0 to 1")
			}
			this._verticalScrollBar.value = value;
			return value;
		}
		
		public function getVerticalScrollPosition():Float{
			return _verticalScrollBar.value;
		}
		
		var scrollY:Int ;
		var scrollX:Int ;
		
		/**
		 * Event listener for when the vertical scrollbar is 
		 * used.
		 */ 
		function onVerticalScroll(event:ScrollEvent):Void
		{
			var scrollAbleHeight:Float = this._contentHeight - this.height;
			if(_horizontalScrollBar)
			{
				scrollAbleHeight+=_horizontalScrollBar.height;
			}
			scrollY = event.value*scrollAbleHeight
			setContentMask()
		}
		
		/**
		 * Event listener for when the horizontal scrollbar is 
		 * used.
		 */ 
		function onHorizontalScroll(event:ScrollEvent):Void
		{
			var scrollAbleWidth:Float = this.contentWidth - this.width;
			if(_verticalScrollBar)
			{
				scrollAbleWidth+=_verticalScrollBar.width;
			}
			scrollX = event.value*scrollAbleWidth
			setContentMask()
		}
		
		/**
		 * Unlike UIControls, UIContainers do not apply a skin directly on 
		 * themselves but interpret the skin file and apply them to the 
		 * different children. So updateDisplayList here does not call
		 * super.updateDisplayList()
		 * 
		 * @inheritDoc
		 */ 
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			if(layoutInvalidated)
			{
				doLayoutChildren()
			}
			if(_verticalScrollBar && _verticalScrollBar.visible==true)
			{
				_verticalScrollBar.x = this.width - _verticalScrollBar.width;
			}
			if(_horizontalScrollBar && _horizontalScrollBar.visible==true)
			{
				_horizontalScrollBar.y = this.height - _horizontalScrollBar.height;
			}	
			super.updateDisplayList(unscaledWidth, unscaledHeight);	
			if(_clipContent){
				//this.scrollRect = new Rectangle(0,0,unscaledWidth, unscaledHeight);
				this.setContentMask()
			}
		}
		
		
		var _clipContent:Bool ;
		
		public function setClipContent(b:Bool):Bool
		{
			if(!b) this.scrollRect = null;
			_clipContent = b;
			return b;
		}
		
		public function getClipContent():Bool
		{
			return _clipContent;
		}
		
		/**
		 * Lays out the layoutChildren based <code>ILayout</code>
		 * object. 
		 * 
		 * @see #layoutChildren
		 */ 
		public override function doLayoutChildren():Void
		{
			_layout.layout(this.layoutChildren);
			layoutInvalidated = false;
		}
		
		/**
		 * Event listener for the vertical scrollbar's
		 * creation and validation event.
		 */ 
		function onVScrollBarUpdateComplete(event:PyroEvent):Void
		{
			if(_horizontalScrollBar){
				_horizontalScrollBar.y = _verticalScrollBar.height;
				if(_clipContent){
					//this.scrollRect = new Rectangle(0,0, this.width, this.height);
					this.setContentMask()
				}
			}
		}
		
		/**
		 * Event listener for the horizontal scrollbar's
		 * creation and validation event.
		 */
		function onHScrollBarUpdateComplete(event:PyroEvent):Void
		{
			if(_verticalScrollBar){
				_verticalScrollBar.x = _horizontalScrollBar.width;
				if(_clipContent){
					//this.scrollRect = new Rectangle(0,0, this.width, this.height);
					this.setContentMask()
				}
			}
		}
		
		function setContentMask():Void{
			var contentW:Float = width
			var contentH:Float = height;
			
			if(_verticalScrollBar && _verticalScrollBar.visible==true){
				contentW-=_verticalScrollBar.width	
			}
			if(_horizontalScrollBar && _horizontalScrollBar.visible==true){
				contentH-=_horizontalScrollBar.height
			}
			if(_verticalScrollBar){
				
			}
			var rect:Rectangle = new Rectangle(scrollX,scrollY,contentW,contentH);
			
			this.contentPane.scrollRect = rect
		}
	}
