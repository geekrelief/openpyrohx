package com.cimians.openPyro.aurora;

	
	import com.cimians.openPyro.aurora.skinClasses.GradientRectSkin;
	import com.cimians.openPyro.controls.skins.ISliderSkin;
	import com.cimians.openPyro.core.UIControl;
	import com.cimians.openPyro.painters.Stroke;
	import com.cimians.openPyro.skins.ISkin;
	
	class AuroraSliderSkin implements ISliderSkin {
		
		public var skinnedControl(null, setSkinnedControl) : UIControl; 
		public var thumbSkin(getThumbSkin, null) : ISkin ;
		public var trackSkin(getTrackSkin, null) : ISkin ;
		
		public var trackGradientRotation:Float;
		
		var track:GradientRectSkin;
		var _thumbSkin:AuroraButtonSkin;
		
		public function new()
		{
		    trackGradientRotation = 0;
		}
	
		public function getThumbSkin():ISkin
		{
			_thumbSkin = new AuroraButtonSkin();
			return _thumbSkin;
		}
		
		public function setSkinnedControl(uic:UIControl):UIControl{	return uic;}
		
		public function getTrackSkin():ISkin
		{
			track =  new GradientRectSkin();
			track.stroke = new Stroke(1,0xcccccc);
			track.gradientRotation = trackGradientRotation;
			return track;
		}
		public function dispose():Void
		{
			if(_thumbSkin.parent != null)
			{
				_thumbSkin.parent.removeChild(_thumbSkin);
			}
			_thumbSkin = null;
			if(track.parent != null){
				track.parent.removeChild(track);
			}
			track = null;
		}
	}
