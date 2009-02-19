package com.cimians.openPyro.containers;

	import com.cimians.openPyro.core.ClassFactory;
	import com.cimians.openPyro.core.MeasurableControl;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.layout.ILayout;
	import com.cimians.openPyro.layout.VLayout;
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
	class VDividedBox extends DividedBox {
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
			_styleName = "VDividedBox";
		}
		
		public override function initialize():Void{
			super.layout = new VLayout();
			super.initialize()
		}
		
		override function getDefaultDividerFactory():ClassFactory{
			var df:ClassFactory = new ClassFactory(UIControl);
			df.properties = {percentWidth:100, height:6, backgroundPainter:new GradientFillPainter([0x999999, 0x666666])}
			return df;	
		}
		
		override function onDividerMouseDown(event:MouseEvent):Void{
			var dragManager:DragManager = DragManager.getInstance()
			dragManager.addEventListener(DragEvent.DRAG_COMPLETE, onDividerDragComplete);
			dragManager.makeDraggable(DisplayObject(event.currentTarget), 
													new Rectangle(0,0,0,this.height-DisplayObject(event.currentTarget).height));
		}
		
		
		function onDividerDragComplete(event:DragEvent):Void{
			var dragManager:DragManager = DragManager.getInstance()
			dragManager.removeEventListener(DragEvent.DRAG_COMPLETE, onDividerDragComplete);
		
			/* 
			If the divider moves up, delta is -ve, otherwise +ve
			*/
			var delta:Float = event.mouseYDelta//point.y - event.dragInitiator.y 
		
			var topUIC:MeasurableControl
			var bottomUIC:MeasurableControl
			
			for(i in 0...contentPane.numChildren){
				var child:DisplayObject = contentPane.getChildAt(i)
				if(child == event.dragInitiator){
					topUIC = MeasurableControl(contentPane.getChildAt(i-1));
					bottomUIC = MeasurableControl(contentPane.getChildAt(i+1));
					break;
				}
				
			}
			
			var unallocatedHeight:Float = (this.height - this.explicitlyAllocatedHeight);
			var newUnallocatedHeight:Float = unallocatedHeight;
			
			if(isNaN(topUIC.explicitHeight) && isNaN(bottomUIC.explicitHeight)){
				
				/*
				* The change in dimensions can be compensated by recalculating the 
				* two percents. 
				*/
				var newTopH:Float = topUIC.height + delta;
				var newBottomH:Float = bottomUIC.height - delta;
				topUIC.percentUnusedHeight = newTopH*100/unallocatedHeight;
				bottomUIC.percentUnusedHeight = newBottomH*100/unallocatedHeight
			}
			
			
			else if(!isNaN(topUIC.explicitHeight) && !isNaN(bottomUIC.explicitHeight)){
				
				/*
				 * The dimension changes can be safely calculated 
				 */
				topUIC.height+=delta
				bottomUIC.height-=delta;
			}
			
			
			else if(!isNaN(topUIC.explicitHeight)) {
				
				/*
				 * Left child is explicitly sized , right is percent sized
				 */ 
				
				topUIC.height+=delta;
				newUnallocatedHeight = unallocatedHeight-delta;
				for(j in 0...contentPane.numChildren){
					var currChildL:MeasurableControl = cast( contentPane.getChildAt(j), MeasurableControl);
					if(dividers.indexOf(currChildL) != -1) continue;
					if(currChildL == topUIC) continue;
					if(currChildL == bottomUIC){
						var newH:Float = currChildL.height-delta;
						bottomUIC.percentUnusedHeight = newH*100/newUnallocatedHeight
					}
					else if(!isNaN(currChildL.percentUnusedHeight)){
						currChildL.percentUnusedHeight = currChildL.percentUnusedHeight*unallocatedHeight/newUnallocatedHeight;
						
					}
				}				
			}
			else{
				/*
				 * Right child is explicitly sized , left is percent sized
				 */ 
				bottomUIC.height-=delta;
				newUnallocatedHeight = unallocatedHeight+delta;
				
				for(k in 0...contentPane.numChildren){
					var currChild:MeasurableControl = cast( contentPane.getChildAt(k), MeasurableControl);
					if(dividers.indexOf(currChild) != -1) continue;
					if(currChild == bottomUIC) continue;
					if(currChild == topUIC){
						var newLH:Float = currChild.height+delta;
						topUIC.percentUnusedHeight = newLH*100/newUnallocatedHeight
					}
					else if(!isNaN(currChild.percentUnusedHeight)){
						currChild.percentUnusedHeight = currChild.percentUnusedHeight*unallocatedHeight/newUnallocatedHeight;
					}
				}
			}	
		}
		
		public override function setLayout(l:ILayout):ILayout{
			throw new Error(getQualifiedClassName(this)+" cannot have layouts applied to it")
			return l;
		}
		
	}
