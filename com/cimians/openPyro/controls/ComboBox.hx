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
	
    import feffects.Tween; 
	
	/*[Event(name='open',type='com.cimians.openPyro.controls.events.DropDownEvent')]*/
	/*[Event(name='close',type='com.cimians.openPyro.controls.events.DropDownEvent')]*/
	/*[Event(name="change", type="com.cimians.openPyro.controls.events.ListEvent")]*/
	/*[Event(name="itemClick", type="com.cimians.openPyro.controls.events.ListEvent")]*/

	class ComboBox extends UIControl {
		
		public var button(null, setButton) : Button;
		public var dataProvider(null, setDataProvider) : Array<Dynamic>;
		public var list(null, setList) : List;
		public var maxDropDownHeight(getMaxDropDownHeight, setMaxDropDownHeight) : Float;
		public var selectedIndex(getSelectedIndex, null) : Int;

		var _bttn:Button;
		var listHolder:Sprite;
		var _list:List;
		var _maskShape:Shape;
		
		var _dataProvider:Array<Dynamic>;
		var _selectedIndex:Int ;

		public var _bttnLabelFunction:Dynamic ;
			
		var _isOpen:Bool ;
		var _maxDropDownHeight:Float ;
		
		public function new() {
			super();
            _selectedIndex = -1;
            _bttnLabelFunction = StringUtil.toStringLabel;
            _isOpen = false;
            _maxDropDownHeight = Math.NaN;
		}
		
		public override function initialize():Void
		{
			super.initialize();
			
			listHolder = new Sprite();
			addChild(listHolder);
			
			_maskShape = new Shape();
			addChild(_maskShape);
			if(_bttn == null){
				_bttn = new Button();
				_bttn.addEventListener(ButtonEvent.DOWN, onButtonDown);
				addChild(_bttn);
				if(_dataProvider != null){
					_bttn.label = _bttnLabelFunction(_dataProvider[_selectedIndex]);
				}
				if(this._skin != null){
					if(Std.is( this._skin, IComboBoxSkin))
					{
						_bttn.skin = cast(this._skin, IComboBoxSkin).buttonSkin;
					}
				}
			}
		}
		
		public override function setSkin(skinImpl:ISkin):ISkin{
			super.setSkin(skinImpl);
			if(!(Std.is( skinImpl, IComboBoxSkin))) return null;
			var cbSkin:IComboBoxSkin = cast this._skin;
			if(this._bttn != null)
			{
				_bttn.skin = cbSkin.buttonSkin;
			}
			
			return skinImpl;
		}
		
		public function setDataProvider(data:Array<Dynamic>):Array<Dynamic>{
			_dataProvider = data;
			_selectedIndex = 0;
			if(_bttn != null)
			{
				_bttn.label = _bttnLabelFunction(data[0]);
			}
			return data;
		}
		
		public function setButton(bttn:Button):Button{
			if(_bttn != null){
				_bttn.removeEventListener(ButtonEvent.DOWN, onButtonDown);
			}
			_bttn = bttn;
			_bttn.addEventListener(ButtonEvent.DOWN, onButtonDown);
			return bttn;
		}
		
		public function setList(l:List):List{
			if(_list != null){
				_list.removeEventListener(ListEvent.ITEM_CLICK,onListItemClick);
				_list.removeEventListener(ListEvent.CHANGE, onListChange);
			}
			_list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick);
			_list.addEventListener(ListEvent.CHANGE, onListChange);
			return l;
		}
		
		function onButtonDown(event:Event):Void{
			if(_isOpen)
			{
				close();
			}
			else
			{
				open();
			}
		}
		
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
			
			
			if(_list == null)
			{
				_list = new List();
				_list.skin = new AuroraContainerSkin();
				_list.layout = new VLayout(-1);
				var renderers:ClassFactory = new ClassFactory(DefaultListRenderer);
				renderers.properties = {setPercentWidth:100, setHeight:25};
				_list.itemRenderer = renderers;
				_list.filters = [new DropShadowFilter(2,90, 0, .5,2,2)];
				
				listHolder.addChildAt(_list,0);
				var overlayManager:OverlayManager = OverlayManager.getInstance();
				if(overlayManager.overlayContainer == null){
					var sprite = new Sprite();
					this.stage.addChild(sprite);
					overlayManager.overlayContainer = sprite;
				}
				
				overlayManager.showOnOverlay(listHolder, this);
				
				//overlayManager.showPopUp(listHolder, false, false);
				
				_list.mwidth = this.mwidth;
				
				if(!Math.isNaN(_maxDropDownHeight))
				{
					_list.mheight = _maxDropDownHeight;	
				}
				_list.dataProvider = _dataProvider;	
				_list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick);
				_list.addEventListener(ListEvent.CHANGE, onListChange);
				_list.validateSize();
				
			}
			
			_list.selectedIndex = _selectedIndex;
			
			// draw the mask //
			
			this._maskShape.graphics.clear();
			this._maskShape.graphics.beginFill(0xff0000,.4);
			this._maskShape.graphics.drawRect(-4,this.mheight+2,this.mwidth+8, _list.mheight+4);
			this._maskShape.graphics.endFill();
			listHolder.mask = _maskShape;
			_list.y = this.mheight-_list.mheight;

            var t = new Tween(_list.y, this.mheight+2, 500);
            t.setTweenHandlers(tweenOpenUpdate, tweenOpenComplete);
            t.start();
            /*
			TweenMax.to(_list, .5, {y:this.height+2, onComplete:function():Void{
				stage.addEventListener(MouseEvent.CLICK, onStageClick)
			}})
            */
			
		}

        function tweenOpenUpdate(e:Float) {
            _list.y = e;
        }

        function tweenOpenComplete(e:Float) {
            _list.y = e;
            stage.addEventListener(MouseEvent.CLICK, onStageClick);
        }
		
		function onStageClick(event:MouseEvent):Void{
			trace("curre "+ (event.currentTarget));
			trace("tgt "+ (event.target));
			if(this._isOpen){
				close();
			}
		}
		
		function onListItemClick(event:ListEvent):Void
		{
			this._bttn.label = _bttnLabelFunction(_list.selectedItem);
			_selectedIndex = _list.selectedIndex;
			dispatchEvent(event);
			close();
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
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			_isOpen = false;

            var t = new Tween(_list.y, this.mheight - _list.mheight, 500);
            t.setTweenHandlers(tweenCloseUpdate);
            t.start();
			//TweenMax.to(_list, .5, {y:this.height-_list.height})
		}
	
        function tweenCloseUpdate(e:Float) {
            _list.y = e;
        }
		
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_bttn != null){
				_bttn.mwidth = unscaledWidth;
				_bttn.mheight = unscaledHeight;
			}
		}

	}
