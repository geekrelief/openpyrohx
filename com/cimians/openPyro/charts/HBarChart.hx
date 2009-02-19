package com.cimians.openPyro.charts;

	import com.cimians.openPyro.controls.List;
	
	import flash.display.DisplayObject;
	
	class HBarChart extends List {
		
	
		
	public var dataProvider(null, setDataProvider) : Dynamic;
		
	public var yField(null, setYField) : String;
		
	public function new(){
			super();
			
			//this.layout = new VLayout();
		}
		
		var _yField:String ;
		public function setYField(fieldName:String):String{
			_yField = fieldName;
			return fieldName;
		}
		
		var maxYValue:Int ;
		public override function setDataProvider(dpObject:Dynamic):Dynamic{	
			
			var dp:Array<Dynamic> = cast( dpObject, Array);
			for(i in 0...dp.length)
			{
				var object:Dynamic = dp[i];
				try
				{
					var yfValue:Float = Number(object[_yField])
					if(yfValue > maxYValue){
						maxYValue = yfValue;
					}
				}
				catch(e:Error)
				{
					continue;	
				}
			}
			super.dataProvider = dp;
			return dpObject;	
			
		}
		
		override function setRendererData(renderer:DisplayObject, data:Dynamic, index:Int):Void
		{
			super.setRendererData(renderer, data, index);
			if(Std.is( renderer, IVerticalChartItemRenderer))
			{
				IVerticalChartItemRenderer(renderer).maxYValue = this.maxYValue;
			}
		}

	}
