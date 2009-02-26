package com.cimians.openPyro.containers;

	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.layout.ILayout;
	import com.cimians.openPyro.layout.VLayout;
	import com.cimians.openPyro.managers.DragManager;
	import com.cimians.openPyro.managers.events.DragEvent;
	import com.cimians.openPyro.painters.GradientFillPainter;
    import com.cimians.openPyro.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 
	 */ 
	class VDividedBox extends DividedBox {
		
		/**
		 * Constructor
		 */ 
		public function new(){
			super();
			_styleName = "VDividedBox";
		}
		
		public override function initialize():Void{
			super.setLayout(new VLayout());
			super.initialize();
		}
		
		override function getDefaultDividerFactory():ClassFactory{
			var df:ClassFactory = new ClassFactory(UIControl);
			df.properties = {setPercentWidth:100, setHeight:6, backgroundPainter:new GradientFillPainter([0x999999, 0x666666])}
			return df;	
		}
		
		override function onDividerMouseDown(event:MouseEvent):Void{
			var dragManager:DragManager = DragManager.getInstance();
			dragManager.addEventListener(DragEvent.DRAG_COMPLETE, onDividerDragComplete);
            if(Std.is(event.currentTarget, MeasurableControl)) {
			    dragManager.makeDraggable(cast(event.currentTarget, DisplayObject), 
													new Rectangle(0,0,0,this.mheight-cast(event.currentTarget, MeasurableControl).mheight));
            } else {
			    dragManager.makeDraggable(cast(event.currentTarget, DisplayObject), 
													new Rectangle(0,0,0,this.mheight-cast(event.currentTarget, DisplayObject).height));
            }
		}
		
		
		function onDividerDragComplete(event:DragEvent):Void{
			var dragManager:DragManager = DragManager.getInstance();
			dragManager.removeEventListener(DragEvent.DRAG_COMPLETE, onDividerDragComplete);
		
			/* 
			If the divider moves up, delta is -ve, otherwise +ve
			*/
			var delta:Float = event.mouseYDelta;//point.y - event.dragInitiator.y 
		
			var topUIC:MeasurableControl = null;
			var bottomUIC:MeasurableControl = null;
			
			for(i in 0...contentPane.numChildren){
				var child:DisplayObject = contentPane.getChildAt(i);
				if(child == event.dragInitiator){
					topUIC = cast contentPane.getChildAt(i-1);
					bottomUIC = cast contentPane.getChildAt(i+1);
					break;
				}
				
			}
			
			var unallocatedHeight:Float = (this.mheight - this.explicitlyAllocatedHeight);
			var newUnallocatedHeight:Float = unallocatedHeight;
			
			if(Math.isNaN(topUIC.explicitHeight) && Math.isNaN(bottomUIC.explicitHeight)){
				
				/*
				* The change in dimensions can be compensated by recalculating the 
				* two percents. 
				*/
				var newTopH:Float = topUIC.mheight + delta;
				var newBottomH:Float = bottomUIC.mheight - delta;
				topUIC.percentUnusedHeight = newTopH*100/unallocatedHeight;
				bottomUIC.percentUnusedHeight = newBottomH*100/unallocatedHeight;
			}
			
			
			else if(!Math.isNaN(topUIC.explicitHeight) && !Math.isNaN(bottomUIC.explicitHeight)){
				
				/*
				 * The dimension changes can be safely calculated 
				 */
				topUIC.mheight+=delta;
				bottomUIC.mheight-=delta;
			}
			
			
			else if(!Math.isNaN(topUIC.explicitHeight)) {
				
				/*
				 * top child is explicitly sized , bottom is percent sized
				 */ 
				
				topUIC.mheight+=delta;
				newUnallocatedHeight = unallocatedHeight-delta;
				for(j in 0...contentPane.numChildren){
					var currChildL:MeasurableControl = cast contentPane.getChildAt(j);
					if(ArrayUtil.indexOf(dividers, currChildL) != -1) continue;
					if(currChildL == topUIC) continue;
					if(currChildL == bottomUIC){
						var newH:Float = currChildL.mheight-delta;
						bottomUIC.percentUnusedHeight = newH*100/newUnallocatedHeight;
					}
					else if(!Math.isNaN(currChildL.percentUnusedHeight)){
						currChildL.percentUnusedHeight = currChildL.percentUnusedHeight*unallocatedHeight/newUnallocatedHeight;
					}
				}				
			}
			else{
				/*
				 * bottom child is explicitly sized , top is percent sized
				 */ 
				bottomUIC.mheight-=delta;
				newUnallocatedHeight = unallocatedHeight+delta;
				
				for(k in 0...contentPane.numChildren){
					var currChild:MeasurableControl = cast contentPane.getChildAt(k);
					if(ArrayUtil.indexOf(dividers, currChild) != -1) continue;
					if(currChild == bottomUIC) continue;
					if(currChild == topUIC){
						var newLH:Float = currChild.mheight+delta;
						topUIC.percentUnusedHeight = newLH*100/newUnallocatedHeight;
					}
					else if(!Math.isNaN(currChild.percentUnusedHeight)){
						currChild.percentUnusedHeight = currChild.percentUnusedHeight*unallocatedHeight/newUnallocatedHeight;
					}
				}
			}	
		}
		
		public override function setLayout(l:ILayout):ILayout{
			throw ("VDividedBox cannot have layouts applied to it");
			return l;
		}
		
	}
