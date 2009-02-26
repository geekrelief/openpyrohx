package com.cimians.openPyro.containers;

	import com.cimians.openPyro.core.Direction;
	import com.cimians.openPyro.core.UIContainer;
	import com.cimians.openPyro.effects.EffectDescriptor;
	import com.cimians.openPyro.effects.PyroEffect;
	
	import flash.display.DisplayObject;
	
	import feffects.easing.Quart;
	
	class SlidePane extends ViewStack {

		public var transitionDirection(getTransitionDirection, setTransitionDirection) : String ;
		public var transitionDuration(getTransitionDuration, setTransitionDuration) : Float ;

		var _transitionDirection:String ;
		var transitionDirectionMultiplier:Int ;
		 
		var _previouslySelectedChild:UIContainer;
		var _previouslySelectedIndex:Int;
		var animationEffect:PyroEffect;

        var _transitionDuration:Float ;
        var trans:Int;
		 
		public function new()
		{
		 	
            _transitionDirection = Direction.HORIZONTAL;
		 	transitionDirectionMultiplier = 1;
		 	_previouslySelectedIndex = -1;

		 	super();

		 	animationEffect = new PyroEffect();
            _transitionDuration = 1;
            trans = -1;
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
            _previouslySelectedChild = _selectedChild;
		 	_previouslySelectedIndex = _selectedIndex;
		 	super.setSelectedIndex(idx);
		 	return idx;
		}
		 
			
		 
		override function showSelectedChild():Void
		{
		 	
            if(_previouslySelectedIndex == -1)
		 	{
		 		super.showSelectedChild();
		 	}
		 	
		 	for(i in 0...viewChildren.length)
		 	{
				var child = viewChildren[i];
				if(i == _selectedIndex)
				{
					child.mvisible = true;
					if(_previouslySelectedIndex < 0) return;
					
					if(i > _previouslySelectedIndex)
					{
						transitionDirectionMultiplier = -trans;
					}
					break;
				}
            }
			
		
			//animate
			
			var oldViewEffectDescriptor = new EffectDescriptor(_previouslySelectedChild, 1, Quart.easeOut);
			var newViewEffectDescriptor = new EffectDescriptor(_selectedChild, 1, Quart.easeOut);
			
			if(_transitionDirection == Direction.HORIZONTAL){
				_selectedChild.x = -1*transitionDirectionMultiplier*this.mwidth;
				oldViewEffectDescriptor.properties = {x:transitionDirectionMultiplier*this.mwidth};
				newViewEffectDescriptor.properties = {x:0};
			}
			else if(_transitionDirection == Direction.VERTICAL)
			{
				_selectedChild.y = -1*transitionDirectionMultiplier*this.mheight;
				oldViewEffectDescriptor.properties = {y:transitionDirectionMultiplier*this.mheight};
				newViewEffectDescriptor.properties = {y:0};
			}
			animationEffect.effectDescriptors = [oldViewEffectDescriptor, newViewEffectDescriptor];
			animationEffect.start();
		 }
	}
