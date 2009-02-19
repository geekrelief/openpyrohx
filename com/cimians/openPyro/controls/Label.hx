package com.cimians.openPyro.controls;

	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.utils.StringUtil;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	class Label extends UIControl {
		
		public var text(getText, setText) : String;
		public var textField(getTextField, null) : TextField
		;
		public var textFormat(getTextFormat, setTextFormat) : TextFormat;
		var _textField:TextField;
		
		public function new()
		{
			super();
		}
		
		override function createChildren():Void{
			_textField = new TextField();
			setTextFieldProperties()
			addChild(_textField);
			
			if(_format){
				_textField.defaultTextFormat = _format;
			}
			if(_text){
				_textField.text = _text
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
			if(!_textField)return;
			
			_textField.defaultTextFormat = tf;
			if(_text){
				this.text = _text;
			}
			return tf;
		}
		
		public function getTextFormat():TextFormat{
			return _format
		}
		
		
		var _text:String ;
		
		/**
		 * Sets the string that will be displayed
		 * on the label
		 */ 
		public function setText(str:String):String{
			this._text = str;
			if(!_textField)return;
			this.invalidateSize();
			this.forceInvalidateDisplayList=true
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
			if(!_textField) return;
			_textField.text = _text;
			if(isNaN(this._explicitWidth) && isNaN(this._percentWidth) && isNaN(_percentUnusedWidth))
			{
				var computedWidth:Int = this._textField.textWidth+5 + _padding.left + _padding.right;
				if(!isNaN(_maximumWidth)){
					computedWidth = Math.min(computedWidth, _maximumWidth);
				}
				super.measuredWidth = computedWidth;
			}
			if(isNaN(this._explicitHeight) && isNaN(this._percentHeight) && isNaN(_percentUnusedHeight))
			{
				var computedHeight:Int = this._textField.textHeight+5 + _padding.top + _padding.bottom;
				if(!isNaN(_maximumHeight)){
					computedHeight = Math.min(computedHeight, _maximumHeight)
				}
				super.measuredHeight = computedHeight;
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
