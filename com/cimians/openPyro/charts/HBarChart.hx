package com.cimians.openPyro.charts;

	import com.cimians.openPyro.controls.List;
	
	import flash.display.DisplayObject;
	
	class HBarChart extends List {
		
	    public var yField(null, setYField) : String;

		var _yField:String;
		var maxYValue:Float;
		
    	public function new(){
			super();
		    _yField = "value";
            maxYValue = 0;
		}
		
		public function setYField(fieldName:String):String{
			_yField = fieldName;
			return fieldName;
		}
		
		public override function setDataProvider(dpObject:Dynamic):Dynamic{	
			
			var dp:Array<Dynamic> = cast dpObject;
			for(i in 0...dp.length)
			{
				var object:Dynamic = dp[i];
				try
				{
					var yfValue:Float = Reflect.field(object, _yField);
					if(yfValue > maxYValue){
						maxYValue = yfValue;
					}
				}
				catch(e:Dynamic)
				{
					continue;	
				}
			}
			super.setDataProvider(dp);
			return dpObject;	
			
		}
		
		override function setRendererData(renderer:DisplayObject, data:Dynamic, index:Int):Void
		{
			super.setRendererData(renderer, data, index);
			if(Std.is( renderer, IVerticalChartItemRenderer))
			{
				cast(renderer, IVerticalChartItemRenderer).maxYValue = this.maxYValue;
			}
		}

	}
