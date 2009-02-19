package com.cimians.openPyro.skins;

	import com.cimians.openPyro.core.UIControl;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * This class defines the skins that are composed of raw graphic elements.
	 * For example this class defines button skins that use a graphic element
	 * embedded in the swf.
	 */ 
	class GraphicSkin extends Sprite, implements ISkin {
		
		public var graphic(getGraphic, setGraphic) : DisplayObject
		;
		public var skinnedControl(null, setSkinnedControl) : UIControl;
		var _graphic:DisplayObject
		public function new(?graphicObject:DisplayObject=null, ?useButtonMode:Bool=true)
		{
			graphic = graphicObject;
			if(useButtonMode)
			{
				this.buttonMode = true;
				this.useHandCursor = true;
				this.mouseChildren = false;
			}
		}
		
		/**
		 * Sets the graphic element that needs to be used as 
		 * the skin
		 */ 
		public function setGraphic(gr:DisplayObject):DisplayObject
		{
			if(_graphic)
			{
				removeChild(_graphic)
				_graphic = null;
			}
			_graphic = gr;
			addChild(_graphic);
			return gr;
		}
		
		/**
		 * @private
		 */ 
		public function getGraphic():DisplayObject
		{
			return _graphic
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function setSkinnedControl(uic:UIControl):UIControl{				
			uic.addChildAt(this,0);
			return uic;				
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function dispose():Void
		{
			if (this.parent)
			{
				this.parent.removeChild(this)
			}	
		}

	}
