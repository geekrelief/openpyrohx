package com.cimians.openPyro.controls;

	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.utils.StringUtil;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	class Label extends UIControl {
		
		public var text(getText, setText) : String;
		public var textField(getTextField, null) : TextField ;
		public var textFormat(getTextFormat, setTextFormat) : TextFormat;
		var _textField:TextField;
		var _text:String;
		
		public function new()
		{
			super();
            _text = "";
		}
		
		override function createChildren():Void{
			_textField = new TextField();
			setTextFieldProperties();
			addChild(_textField);
			
			if(_format != null){
				_textField.defaultTextFormat = _format;
			}
			if(_text != null ){
				_textField.text = _text;
			}
		}
		
		function setTextFieldProperties():Void{
			_textField.selectable = false;
			//_textField.border = true;
		}
		
		/**
		 * Returns the raw textfield used to render
		 * the text
		 */
		public function getTextField():TextField
		{
			return _textField;
		}
		
		var _format:TextFormat;
		
		/**
		 * Sets the <code>TextFormat</code> on the
		 * label.
		 * 
		 * @see flash.text.TextFormat
		 */  
		public function setTextFormat(tf:TextFormat):TextFormat{
			_format = tf;
			if(_textField == null) return null;
			
			_textField.defaultTextFormat = tf;
			if(_text != null){
				this.text = _text;
			}
			return tf;
		}
		
		public function getTextFormat():TextFormat{
			return _format;
		}
		
		
		
		/**
		 * Sets the string that will be displayed
		 * on the label
		 */ 
		public function setText(str:String):String{
			this._text = str;
			if(_textField == null) return "";
			this.invalidateSize();
			this.forceInvalidateDisplayList = true;
			this.invalidateDisplayList();
			return str;
		}
		
		public function getText():String{
			return _text;
		}
		
		override function doChildBasedValidation():Void
		{
			//
			// Set the _textField's text so that we can measure based on
			// the textWidths
			//
			if(_textField == null) return;
			_textField.text = _text;
			if(Math.isNaN(this._explicitWidth) && Math.isNaN(this._percentWidth) && Math.isNaN(_percentUnusedWidth))
			{
				var computedWidth:Float = this._textField.textWidth+5 + _padding.left + _padding.right;
				if(!Math.isNaN(_maximumWidth)){
					computedWidth = Math.min(computedWidth, _maximumWidth);
				}
				measuredWidth = computedWidth;
			}
			if(Math.isNaN(this._explicitHeight) && Math.isNaN(this._percentHeight) && Math.isNaN(_percentUnusedHeight))
			{
				var computedHeight:Float = this._textField.textHeight+5 + _padding.top + _padding.bottom;
				if(!Math.isNaN(_maximumHeight)){
					computedHeight = Math.min(computedHeight, _maximumHeight);
				}
				measuredHeight = computedHeight;
			}
			
			//
			// Measured Width and height may not have changed so updateDisplaylist may not 
			// be called. So do the text truncation again (may be redundant though)
			//
			if(_textField.textWidth > _textField.width){
				StringUtil.omitWordsToFit(_textField);
			}
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_textField.x = this._padding.left;
			_textField.y = this._padding.top;
			_textField.width = unscaledWidth - _padding.left - _padding.right;
			_textField.height = unscaledHeight - _padding.top - _padding.bottom;
			_textField.text = _text;
			if(_textField.textWidth > _textField.width){
				StringUtil.omitWordsToFit(_textField);
			}
			
		}

	}
