package com.cimians.openPyro.charts;

	import com.cimians.openPyro.controls.List;
	
	import flash.display.DisplayObject;
	
	class VBarChart extends List {
		
    	public var xField(null, setXField) : String;
		
		var _xField:String;
		var maxXValue:Float;

    	public function new(){
			super();
            _xField = "value";
            maxXValue = 0;
		}
		
		public function setXField(fieldName:String):String{
			_xField = fieldName;
			return fieldName;
		}
		
		public override function setDataProvider(dpObject:Dynamic):Dynamic{	

			var dp:Array<Dynamic> = cast dpObject;
			for(i in 0...dp.length)
			{
				var object:Dynamic = dp[i];
				try
				{
					var xfValue:Float = Reflect.field(object, _xField);
					if(xfValue > maxXValue){
						maxXValue = xfValue;
					}
				}
				catch(e:Dynamic)
				{
					trace("Could not find xValue value");
					continue;	
				}
			}
			super.setDataProvider(dp);
			return dpObject;	
			
		}
		
		override function setRendererData(renderer:DisplayObject, data:Dynamic, index:Int):Void
		{
			super.setRendererData(renderer, data, index);
			if(Std.is( renderer, IHorizontalChartItemRenderer))
			{
				cast(renderer, IHorizontalChartItemRenderer).maxXValue = this.maxXValue;
			}
		}

	}
