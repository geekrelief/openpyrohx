package com.cimians.openPyro.containers;

	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.layout.HLayout;
	import com.cimians.openPyro.layout.ILayout;
	import com.cimians.openPyro.managers.DragManager;
	import com.cimians.openPyro.managers.events.DragEvent;
	import com.cimians.openPyro.painters.GradientFillPainter;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 
	 */ 
	class HDividedBox extends DividedBox {
		/**
		 * Constructor
		 */ 
		
		public var defaultDividerFactory(getDefaultDividerFactory, null) : ClassFactory;
		public var layout(null, setLayout) : ILayout;
		/**
		 * Constructor
		 */ 
		public function new(){
			super();
			_styleName = "HDividedBox";
		}
		
		public override function initialize():Void{
			super.layout = new HLayout();
			super.initialize()
		}
		
		override function getDefaultDividerFactory():ClassFactory{
			var df:ClassFactory = new ClassFactory(UIControl);
			df.properties = {percentHeight:100, width:6, backgroundPainter:new GradientFillPainter([0x999999, 0x666666])}			
			return df;
		}
		
		
		var leftUIC:MeasurableControl
		var rightUIC:MeasurableControl
		
		override function onDividerMouseDown(event:MouseEvent):Void{
			var dragManager:DragManager = DragManager.getInstance()
			dragManager.addEventListener(DragEvent.DRAG_COMPLETE, onDividerDragComplete);
			
			for(i in 0...contentPane.numChildren){
				var child:DisplayObject = contentPane.getChildAt(i)
				if(child == event.currentTarget){
					leftUIC = MeasurableControl(contentPane.getChildAt(i-1));
					rightUIC = MeasurableControl(contentPane.getChildAt(i+1));
					break;
				}
				
			}
			
			leftUIC.cancelMouseEvents()
			rightUIC.cancelMouseEvents()
			dragManager.makeDraggable(DisplayObject(event.currentTarget), 
													new Rectangle(0,0,this.width-DisplayObject(event.currentTarget).width, 0));
		}
		
		
		function onDividerDragComplete(event:DragEvent):Void{
			var dragManager:DragManager = DragManager.getInstance()
			dragManager.removeEventListener(DragEvent.DRAG_COMPLETE, onDividerDragComplete);
			
			/* 
			If the divider moves left, delta is -ve, otherwise +ve
			*/
			var delta:Float = event.mouseXDelta
			
			
			
			var unallocatedWidth:Float = (this.width - this.explicitlyAllocatedWidth);
			var newUnallocatedWidth:Float = unallocatedWidth;
			
			if(isNaN(leftUIC.explicitWidth) && isNaN(rightUIC.explicitWidth)){
				
				/*
				* The change in dimensions can be compensated by recalculating the 
				* two percents. 
				*/
				var newLeftW:Float = leftUIC.width + delta;
				var newRightW:Float = rightUIC.width - delta;
				leftUIC.percentUnusedWidth = newLeftW*100/unallocatedWidth;
				rightUIC.percentUnusedWidth = newRightW*100/unallocatedWidth
			}
			
			
			else if(!isNaN(leftUIC.explicitWidth) && !isNaN(rightUIC.explicitWidth)){
				
				/*
				 * The dimension changes can be safely calculated 
				 */
				leftUIC.width+=delta
				rightUIC.width-=delta;
			}
			
			
			else if(!isNaN(leftUIC.explicitWidth)) {
				
				/*
				 * Left child is explicitly sized , right is percent sized
				 */ 
				
				leftUIC.width+=delta;
				newUnallocatedWidth = unallocatedWidth-delta;
				for(j in 0...contentPane.numChildren){
					var currChildL:MeasurableControl = cast( contentPane.getChildAt(j), MeasurableControl);
					if(dividers.indexOf(currChildL) != -1) continue;
					if(currChildL == leftUIC) continue;
					if(currChildL == rightUIC){
						var newW:Float = currChildL.width-delta;
						rightUIC.percentUnusedWidth = newW*100/newUnallocatedWidth
					}
					else if(!isNaN(currChildL.percentUnusedWidth)){
						currChildL.percentUnusedWidth = currChildL.percentUnusedWidth*unallocatedWidth/newUnallocatedWidth;
						
					}
				}				
			}
			else{
				/*
				 * Right child is explicitly sized , left is percent sized
				 */ 
				rightUIC.width-=delta;
				newUnallocatedWidth = unallocatedWidth+delta;
				
				for(k in 0...contentPane.numChildren){
					var currChild:MeasurableControl = cast( contentPane.getChildAt(k), MeasurableControl);
					if(dividers.indexOf(currChild) != -1) continue;
					if(currChild == rightUIC) continue;
					if(currChild == leftUIC){
						var newLW:Float = currChild.width+delta;
						leftUIC.percentUnusedWidth = newLW*100/newUnallocatedWidth
					}
					else if(!isNaN(currChild.percentUnusedWidth)){
						currChild.percentUnusedWidth = currChild.percentUnusedWidth*unallocatedWidth/newUnallocatedWidth;
					}
				}
			}
			
			leftUIC.enableMouseEvents()
			rightUIC.enableMouseEvents();
			
		}
		
		public override function setLayout(l:ILayout):ILayout{
			throw new Error(getQualifiedClassName(this)+" cannot have layouts applied to it")
			return l;
		}
		
	}
