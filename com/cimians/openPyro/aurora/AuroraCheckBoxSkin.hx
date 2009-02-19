package com.cimians.openPyro.aurora;

	import com.cimians.openPyro.controls.Button;
	import com.cimians.openPyro.controls.events.ButtonEvent;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.events.PyroEvent;
	import com.cimians.openPyro.painters.GradientFillPainter;
	import com.cimians.openPyro.painters.Stroke;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	class AuroraCheckBoxSkin extends AuroraPainterButtonSkin {
		
		
		
		public var checkIcon(null, setCheckIcon) : DisplayObject;
		
		public var skinnedControl(null, setSkinnedControl) : UIControl;
		
		public var uncheckIcon(null, setUncheckIcon) : DisplayObject;
		
		/*[Embed(source="/assets/graphic_assets.swf", symbol="checkIcon")]*/
		var TickGraphic:Class<Dynamic>
		
		public function new()
		{
		}
		
		var _checkIcon:DisplayObject
		
		public var cornerRadius:Int public var boxLabelGap:Int ;
		
		public function setCheckIcon(icon:DisplayObject):DisplayObject{
			_checkIcon = icon
			return icon;
		}
		
		var _uncheckIcon:DisplayObject
		public function setUncheckIcon(icon:DisplayObject):DisplayObject{
			_uncheckIcon = icon;
			return icon;
		}
		
		public override function setSkinnedControl(uic:UIControl):UIControl{
			super.skinnedControl = uic
			checkSelectedStatus()
			return uic;
		}
		
		override function onSkinnedControlPropertyChange(event:PyroEvent):Void{
			super.onSkinnedControlPropertyChange(event);
			checkSelectedStatus()
		}
		
		public override function changeState(fromState:String, toState:String):Void
		{
			if(toState==ButtonEvent.UP)
			{
				this.backgroundPainter = upPainter;
			}
			
			else if(toState==ButtonEvent.OVER)
			{
				this.backgroundPainter = overPainter;
			}
			
			else if(toState == ButtonEvent.DOWN)
			{
				this.backgroundPainter = downPainter;
				if(Std.is( _skinnedControl, Button)){
					var b:Button = cast( _skinnedControl, Button);
					checkSelectedStatus()
				}
			}
			else
			{
				this.backgroundPainter = upPainter;
			}
		}
		
		function checkSelectedStatus():Void{
			if(Button(_skinnedControl).toggle){
				if(Button(_skinnedControl).selected){
					if(!_checkIcon){
						_checkIcon = createDefaultCheckIcon()
						
					}
					_checkIcon.visible = true
					if(_uncheckIcon){
						_uncheckIcon.visible = false;
					}	
				}
				else {
					if(!_uncheckIcon){
						_uncheckIcon = createDefaultUnCheckIcon()
						
					}
					_uncheckIcon.visible = true
					if(_checkIcon){
						_checkIcon.visible=false
					}
				}
			}
		}
		
		public override function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
				if(!label){
					if(_checkIcon)
						_checkIcon.x = (unscaledWidth-_checkIcon.width)/2;
					if(_uncheckIcon)
						_uncheckIcon.x = 	(unscaledWidth-_uncheckIcon.width)/2
				}
				else{
						if(_checkIcon){
							_checkIcon.x = _skinnedControl.padding.left;
							_checkIcon.y = (unscaledHeight-_checkIcon.height)/2;
			
						}
						if(_uncheckIcon){
							_uncheckIcon.x =  _skinnedControl.padding.left;;
							_uncheckIcon.y = (unscaledHeight-_uncheckIcon.height)/2;
						}
						var checkIconW:Int = _checkIcon ? _checkIcon.width:0
						var uncheckIconW:Int = _uncheckIcon?_uncheckIcon.width:0
						label.x = Math.max(checkIconW, uncheckIconW)+boxLabelGap;
					}
			
		}
		
		function createDefaultUnCheckIcon():Sprite{
			var sp:Sprite = new Sprite()
			var gr:GradientFillPainter = new GradientFillPainter([0xffffff, 0xdddddd])
			gr.stroke = new Stroke(1,0x666666,1,true)
			gr.rotation = Math.PI/2
			gr.cornerRadius = cornerRadius
			gr.draw(sp.graphics, 15,15)
			addChild(sp)
			return sp
		}
		
		function createDefaultCheckIcon():Sprite{
			var sp:Sprite = new Sprite()
			var gr:GradientFillPainter = new GradientFillPainter([0xffffff, 0xdddddd])
			gr.stroke = new Stroke(1,0x666666,1,true)
			gr.rotation = Math.PI/2
			gr.cornerRadius = cornerRadius
			gr.draw(sp.graphics, 15,15)
			addChild(sp)
			
			var tick:DisplayObject = new TickGraphic()
			sp.addChild(tick)
			sp.mouseChildren=false;
			return sp
		}
		

	}
