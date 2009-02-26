package com.cimians.openPyro.containers;

	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.layout.HLayout;
	import com.cimians.openPyro.layout.ILayout;
	import com.cimians.openPyro.managers.DragManager;
	import com.cimians.openPyro.managers.events.DragEvent;
	import com.cimians.openPyro.painters.GradientFillPainter;
	import com.cimians.openPyro.utils.ArrayUtil;
    
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	class HDividedBox extends DividedBox {
		
		/**
		 * Constructor
		 */ 
		public function new(){
			super();
			_styleName = "HDividedBox";
		}
		
		public override function initialize():Void{
			super.setLayout(new HLayout());
			super.initialize();
		}
		
		override function getDefaultDividerFactory():ClassFactory{
			var df:ClassFactory = new ClassFactory(UIControl);
			df.properties = {setPercentHeight:100, setWidth:6, backgroundPainter:new GradientFillPainter([0x999999, 0x666666])};
			return df;
		}
		
		
		var leftUIC:MeasurableControl;
		var rightUIC:MeasurableControl;
		
		override function onDividerMouseDown(event:MouseEvent):Void{
			var dragManager:DragManager = DragManager.getInstance();
			dragManager.addEventListener(DragEvent.DRAG_COMPLETE, onDividerDragComplete);
			
			for(i in 0...contentPane.numChildren){
				var child:DisplayObject = contentPane.getChildAt(i);
				if(child == event.currentTarget){
					leftUIC = cast contentPane.getChildAt(i-1);
					rightUIC = cast contentPane.getChildAt(i+1);
					break;
				}
				
			}
			
			leftUIC.cancelMouseEvents();
			rightUIC.cancelMouseEvents();
            if(Std.is(event.currentTarget, MeasurableControl)) {
    			dragManager.makeDraggable(cast(event.currentTarget, DisplayObject), 
													new Rectangle(0,0,this.mwidth-cast(event.currentTarget, MeasurableControl).mwidth, 0));
            } else {
    			dragManager.makeDraggable(cast(event.currentTarget, DisplayObject), 
													new Rectangle(0,0,this.mwidth-cast(event.currentTarget, DisplayObject).width, 0));
            }
		}
		
		
		function onDividerDragComplete(event:DragEvent):Void{
			var dragManager:DragManager = DragManager.getInstance();
			dragManager.removeEventListener(DragEvent.DRAG_COMPLETE, onDividerDragComplete);
			
			/* 
			If the divider moves left, delta is -ve, otherwise +ve
			*/
			var delta:Float = event.mouseXDelta;
			
			var unallocatedWidth:Float = (this.mwidth - this.explicitlyAllocatedWidth);
			var newUnallocatedWidth:Float = unallocatedWidth;
			
			if(Math.isNaN(leftUIC.explicitWidth) && Math.isNaN(rightUIC.explicitWidth)){
				
				/*
				* The change in dimensions can be compensated by recalculating the 
				* two percents. 
				*/
				var newLeftW:Float = leftUIC.mwidth + delta;
				var newRightW:Float = rightUIC.mwidth - delta;
				leftUIC.percentUnusedWidth = newLeftW*100/unallocatedWidth;
				rightUIC.percentUnusedWidth = newRightW*100/unallocatedWidth;

			} else if(!Math.isNaN(leftUIC.explicitWidth) && !Math.isNaN(rightUIC.explicitWidth)){
				
				/*
				 * The dimension changes can be safely calculated 
				 */
				leftUIC.mwidth+=delta;
				rightUIC.mwidth-=delta;

			} else if(!Math.isNaN(leftUIC.explicitWidth)) {
				
				/*
				 * Left child is explicitly sized , right is percent sized
				 */ 
				
				leftUIC.mwidth+=delta;
				newUnallocatedWidth = unallocatedWidth-delta;
				for(j in 0...contentPane.numChildren){
					var currChildL:MeasurableControl =  cast contentPane.getChildAt(j);
					if(ArrayUtil.indexOf(dividers, currChildL) != -1) continue;
					if(currChildL == leftUIC) continue;
					if(currChildL == rightUIC){
						var newW:Float = currChildL.mwidth-delta;
						rightUIC.percentUnusedWidth = newW*100/newUnallocatedWidth;
					}
					else if(!Math.isNaN(currChildL.percentUnusedWidth)){
						currChildL.percentUnusedWidth = currChildL.percentUnusedWidth*unallocatedWidth/newUnallocatedWidth;
					}
				}				
			} else{
				/*
				 * Right child is explicitly sized , left is percent sized
				 */ 
				rightUIC.mwidth-=delta;
				newUnallocatedWidth = unallocatedWidth+delta;
				
				for(k in 0...contentPane.numChildren){
					var currChild:MeasurableControl = cast contentPane.getChildAt(k);
					if(ArrayUtil.indexOf(dividers, currChild) != -1) continue;
					if(currChild == rightUIC) continue;
					if(currChild == leftUIC){
						var newLW:Float = currChild.mwidth+delta;
						leftUIC.percentUnusedWidth = newLW*100/newUnallocatedWidth;
					}
					else if(!Math.isNaN(currChild.percentUnusedWidth)){
						currChild.percentUnusedWidth = currChild.percentUnusedWidth*unallocatedWidth/newUnallocatedWidth;
					}
				}
			}
			
			leftUIC.enableMouseEvents();
			rightUIC.enableMouseEvents();
			
		}
		
		public override function setLayout(l:ILayout):ILayout{
			throw ("HDividedBox cannot have layouts applied to it");
			return l;
		}
		
	}
