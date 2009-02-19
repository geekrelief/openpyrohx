package com.cimians.openPyro.controls;

	import com.cimians.openPyro.aurora.AuroraContainerSkin;
	import com.cimians.openPyro.controls.events.ButtonEvent;
	import com.cimians.openPyro.controls.events.ListEvent;
	import com.cimians.openPyro.controls.listClasses.DefaultListRenderer;
	import com.cimians.openPyro.controls.skins.IComboBoxSkin;
	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.layout.VLayout;
	import com.cimians.openPyro.managers.OverlayManager;
	import com.cimians.openPyro.skins.ISkin;
	import com.cimians.openPyro.utils.StringUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import gs.TweenMax;
	
	/*[Event(name='open',type='com.cimians.openPyro.controls.events.DropDownEvent')]*/
	/*[Event(name='close',type='com.cimians.openPyro.controls.events.DropDownEvent')]*/
	/*[Event(name="change", type="com.cimians.openPyro.controls.events.ListEvent")]*/
	/*[Event(name="itemClick", type="com.cimians.openPyro.controls.events.ListEvent")]*/

	class ComboBox extends UIControl {
		
		public var button(null, setButton) : Button;
		public var dataProvider(null, setDataProvider) : Array<Dynamic>;
		public var list(null, setList) : List;
		public var maxDropDownHeight(getMaxDropDownHeight, setMaxDropDownHeight) : Float
		;
		public var selectedIndex(getSelectedIndex, null) : Int
		;
		public var skin(null, setSkin) : ISkin;
		var _bttn:Button;
		var listHolder:Sprite;
		var _list:List;
		var _maskShape:Shape;
		
		public function new() {
			super();
		}
		
		public override function initialize():Void
		{
			super.initialize();
			
			listHolder = new Sprite()
			addChild(listHolder);
			
			_maskShape = new Shape()
			addChild(_maskShape);
			if(!_bttn){
				_bttn = new Button()
				_bttn.addEventListener(ButtonEvent.DOWN, onButtonDown)
				addChild(_bttn);
				if(_dataProvider){
					_bttn.label = _bttnLabelFunction(_dataProvider[_selectedIndex]);
				}
				if(this._skin){
					if(Std.is( this._skin, IComboBoxSkin))
					{
						_bttn.skin = IComboBoxSkin(this._skin).buttonSkin
					}
				}
			}
		}
		
		public override function setSkin(skinImpl:ISkin):ISkin{
			super.skin = skinImpl;
			if(!(Std.is( skinImpl, IComboBoxSkin))) return;
			var cbSkin:IComboBoxSkin = IComboBoxSkin(this._skin);
			if(this._bttn)
			{
				_bttn.skin = cbSkin.buttonSkin;
			}
			
			return skinImpl;
		}
		
		var _dataProvider:Array<Dynamic>;
		var _selectedIndex:Int ;
		public function setDataProvider(data:Array<Dynamic>):Array<Dynamic>{
			_dataProvider = data;
			_selectedIndex = 0;
			if(_bttn)
			{
				_bttn.label = _bttnLabelFunction(data[0]);
			}
			return data;
		}
		
		public var _bttnLabelFunction:Dynamic ;
			
		public function setButton(bttn:Button):Button{
			if(_bttn){
				_bttn.removeEventListener(ButtonEvent.DOWN, onButtonDown)	
			}
			_bttn = bttn;
			_bttn.addEventListener(ButtonEvent.DOWN, onButtonDown)
			return bttn;
		}
		
		public function setList(l:List):List{
			if(_list){
				_list.removeEventListener(ListEvent.ITEM_CLICK,onListItemClick);
				_list.removeEventListener(ListEvent.CHANGE, onListChange);
			}
			_list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick)
			_list.addEventListener(ListEvent.CHANGE, onListChange);
			return l;
		}
		
		var _isOpen:Bool ;
		
		function onButtonDown(event:Event):Void{
			if(_isOpen)
			{
				close()
			}
			else
			{
				open()
			}
			
		}
		
		var _maxDropDownHeight:Float ;
		
		/**
		 * Sets the height of the dropdown list. If this value
		 * is set and the list's data needs more height than that
		 * was set as the <code>maxDropDownHeight</code>, the list
		 * tries to create a scrollbar as long as the IComboButtonSkin
		 * specifies a List skin with Scrollbars defined.
		 * 
		 * @see com.cimians.openPyro.controls.skins.IComboBoxSkin
		 */ 
		public function setMaxDropDownHeight(value:Float):Float
		{
			_maxDropDownHeight = value;	
			return value;
		}
		
		/**
		 * @private
		 */ 
		public function getMaxDropDownHeight():Float
		{
			return _maxDropDownHeight;
		}
		
		public function open():Void
		{
			if(_isOpen) return;
			_isOpen = true;
			
			
			
			if(!_list)
			{
				_list = new List()
				_list.skin = new AuroraContainerSkin()
				_list.layout = new VLayout(-1);
				var renderers:ClassFactory = new ClassFactory(DefaultListRenderer)
				renderers.properties = {percentWidth:100, height:25}
				_list.itemRenderer = renderers;
				_list.filters = [new DropShadowFilter(2,90, 0, .5,2,2)];
				
				listHolder.addChildAt(_list,0);
				var overlayManager:OverlayManager = OverlayManager.getInstance()
				if(!overlayManager.overlayContainer){
					var sprite:Sprite = new Sprite()
					this.stage.addChild(sprite)
					overlayManager.overlayContainer = sprite
				}
				
				overlayManager.showOnOverlay(listHolder, this);
				
			
				
				
				//overlayManager.showPopUp(listHolder, false, false);
				
				
				_list.width = this.width;
				
				if(!isNaN(_maxDropDownHeight))
				{
					_list.height = _maxDropDownHeight;	
				}
				_list.dataProvider = _dataProvider;	
				_list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick);
				_list.addEventListener(ListEvent.CHANGE, onListChange);
				_list.validateSize()
				
			}
			
			_list.selectedIndex = _selectedIndex;
			
			// draw the mask //
			
			this._maskShape.graphics.clear()
			this._maskShape.graphics.beginFill(0xff0000,.4)
			this._maskShape.graphics.drawRect(-4,this.height+2,this.width+8, _list.height+4)
			this._maskShape.graphics.endFill()
			listHolder.mask = _maskShape;
			_list.y = this.height-_list.height
			TweenMax.to(_list, .5, {y:this.height+2, onComplete:function():Void{
				stage.addEventListener(MouseEvent.CLICK, onStageClick)
			}})
			
		}
		
		function onStageClick(event:MouseEvent):Void{
			trace("curre "+ (event.currentTarget))
			trace("tgt "+ (event.target))
			if(this._isOpen){
				close();
			}
		}
		
		function onListItemClick(event:ListEvent):Void
		{
			this._bttn.label = _bttnLabelFunction(_list.selectedItem);
			_selectedIndex = _list.selectedIndex;
			dispatchEvent(event);
			close()
		}
		
		public function getSelectedIndex():Int
		{
			return _selectedIndex;
		}
		
		function onListChange(event:ListEvent):Void
		{
			_selectedIndex = _list.selectedIndex;
			dispatchEvent(event.clone());
		}
		
		public function close():Void
		{
			if(!_isOpen) return;
			stage.removeEventListener(MouseEvent.CLICK, onStageClick)
			_isOpen = false;
			TweenMax.to(_list, .5, {y:this.height-_list.height})
		}
		
		
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_bttn){
				_bttn.width = unscaledWidth;
				_bttn.height = unscaledHeight;
			}
		}

	}
