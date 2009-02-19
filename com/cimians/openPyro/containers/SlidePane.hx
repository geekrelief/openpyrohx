package com.cimians.openPyro.containers;

	import com.cimians.openPyro.core.Direction;
	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.effects.EffectDescriptor;
	import com.cimians.openPyro.effects.PyroEffect;
	
	import flash.display.DisplayObject;
	
	import gs.easing.Quart;
	
	class SlidePane extends ViewStack {
		 
		 public var selectedIndex(null, setSelectedIndex) : Int;
		 public var transitionDirection(getTransitionDirection, setTransitionDirection) : String
		 ;
		 public var transitionDuration(getTransitionDuration, setTransitionDuration) : Float
		 ;
		 var _transitionDirection:String ;
		 var transitionDirectionMultiplier:Int ;
		 
		 var _previouslySelectedChild:UIContainer ;
		 var _previouslySelectedIndex:Int ;
		 var animationEffect:PyroEffect;
		 
		 public function new()
		 {
		 	
		 	_transitionDirection = Direction.HORIZONTAL;
		 	transitionDirectionMultiplier = 1;
		 	_previouslySelectedChild = null;
		 	_previouslySelectedIndex = -1;
		 	super()
		 	animationEffect = new PyroEffect();
		 }
		 
		 /**
		 * Sets the direction for the transition among the different
		 * children of the SlidePane. The acceptable values are
		 * either Direction.HORIZONTAL or Direction.VERTICAL
		 */ 
		 public function setTransitionDirection(dir:String):String
		 {
			 _transitionDirection = dir;
		 	return dir;
			}
		 public function getTransitionDirection():String
		 {
		 	return _transitionDirection;
		 }
		 
		 var _transitionDuration:Int ;
		 
		 /**
		 * The number of seconds for which the transition animation will
		 * run. Default is 1 second
		 */ 
		 public function setTransitionDuration(numSeconds:Float):Float
		 {
		 	_transitionDuration = numSeconds;
		 	return numSeconds;
		 }
		 
		 public function getTransitionDuration():Float
		 {
		 	return _transitionDuration;
		 }
		
		 public override function setSelectedIndex(idx:Int):Int{
		 	_previouslySelectedChild = _selectedChild
		 	_previouslySelectedIndex = _selectedIndex
		 	super.selectedIndex = idx;
		 	return idx;
		 }
		 
		 var trans:Int ;
			
		 
		 override function showSelectedChild():Void
		 {
		 	
		 	if(_previouslySelectedIndex == -1)
		 	{
		 		super.showSelectedChild();
		 	}
		 	
		 	for(i in 0...viewChildren.length)
		 	{
				var child:DisplayObject = DisplayObject(viewChildren[i]);
				if(i == _selectedIndex)
				{
					child.visible = true;
					if(_previouslySelectedIndex < 0) return;
					
					if(i > _previouslySelectedIndex)
					{
						transitionDirectionMultiplier = trans* -1 ;
					}
					else
					{
						transitionDirectionMultiplier = trans* +1
					}
					break;
				}
			}
			
		
			//animate
			
			var oldViewEffectDescriptor:EffectDescriptor = new EffectDescriptor(_previouslySelectedChild, 1)
			var newViewEffectDescriptor:EffectDescriptor = new EffectDescriptor(_selectedChild, 1)
			
			if(_transitionDirection == Direction.HORIZONTAL){
				_selectedChild.x = -1*transitionDirectionMultiplier*this.width;
				oldViewEffectDescriptor.properties = {x:transitionDirectionMultiplier*this.width, ease:Quart.easeOut}
				newViewEffectDescriptor.properties = {x:0, ease:Quart.easeOut}	
			}
			else if(_transitionDirection == Direction.VERTICAL)
			{
				_selectedChild.y = -1*transitionDirectionMultiplier*this.height;
				oldViewEffectDescriptor.properties = {y:transitionDirectionMultiplier*this.height, ease:Quart.easeOut}
				newViewEffectDescriptor.properties = {y:0, ease:Quart.easeOut}
			}
			animationEffect.effectDescriptors = [oldViewEffectDescriptor, newViewEffectDescriptor];
			animationEffect.start();
		 }
		 
	}
