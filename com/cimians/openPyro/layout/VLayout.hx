package com.cimians.openPyro.layout;
	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.effects.EffectDescriptor;
	import com.cimians.openPyro.effects.PyroEffect;
	
	import flash.display.DisplayObject;
	
	class VLayout implements ILayout, implements IContainerMeasurementHelper {
		
		
		
		public var container(null, setContainer) : UIContainer;
		
		public var initX(null, setInitX) : Float;
		
		public var initY(null, setInitY) : Float;
		
		public var prepare(null, setPrepare) : Dynamic;
		
		var _vGap:Int ;
		
		public function new(?vGap:Int=0){
			
			_vGap = 0;
			_vGap = vGap;
		}
		
		var _container:UIContainer;
		public function setContainer(container:UIContainer):UIContainer{
			_container = container;
			return container;
		}
		
		var _initY:Int ;
		var _initX:Int ;
		
		public function setInitX(n:Float):Float{
			_initX = n;	
			return n;
		}
		
		public function setInitY(n:Float):Float{
			_initY = n;
			return n;
		}
		
		public function getMaxWidth(children:Array<Dynamic>):Float
		{
			var maxW:Int=0;
			for(i in 0...children.length)
			{
				if(DisplayObject(children[i]).width > maxW)
				{
					maxW = DisplayObject(children[i]).width
				}
			}
			return maxW;			
		}
		
		
		public function getMaxHeight(children:Array<Dynamic>):Float
		{
			var nowY:Float=_initY;
			for(i in 0...children.length){
				var c:DisplayObject = cast( children[i], DisplayObject);
				nowY+=c.height;
				nowY+=this._vGap
			}
			return nowY-_vGap;
		}
		
		var _prepare:Dynamic;
		public function setPrepare(f:Dynamic):Dynamic{
			_prepare = f;
			return f;
		}
		
		public var animationDuration:Int ;
		
		public function layout(children:Array<Dynamic>):Void{
			
			if(_prepare != null){
				_prepare(children)
			}	
			
			var nowY:Float=_initY;
			var effectDescriptors:Array<Dynamic>  = new Array();
			for(i in 0...children.length){
				var c:DisplayObject = cast( children[i], DisplayObject);
				//c.y = nowY;
				var eff:EffectDescriptor = new EffectDescriptor(c, animationDuration, {y:nowY})
				effectDescriptors.push(eff);
				c.x = _initX;
				nowY+=c.height;
				nowY+=this._vGap
			}
			var move:PyroEffect = new PyroEffect()
			move.effectDescriptors = effectDescriptors;
			move.start()		
		}
		
		/**		
		*Find all the children with explicitWidth/ explicit Height set
		*This part depends on the layout since HLayout will start trimming
		*the objects available h space, and v layout will do the same 
		*for vertically available space
		**/
		
		public function calculateSizes(children:Array<Dynamic>,container:UIContainer):Void
		{
			for(i in 0...children.length)
			{
				initY = container.padding.top;
			
				if(i>0){
					container.explicitlyAllocatedHeight+=_vGap;
				}
				
				if(Std.is( children[i], MeasurableControl))				
				{
					var sizeableChild:MeasurableControl = MeasurableControl(children[i]);
					if(!isNaN(sizeableChild.explicitHeight))
					{
					container.explicitlyAllocatedHeight+=sizeableChild.explicitHeight;	
					}
				}

			}
		}
	}
