package com.cimians.openPyro.charts;

	import com.cimians.openPyro.controls.List;
	
	import flash.display.DisplayObject;
	
	class VBarChart extends List {
		
	
		
	public var dataProvider(null, setDataProvider) : Dynamic;
		
	public var xField(null, setXField) : String;
		
	public function new(){
			super();
			
			//this.layout = new VLayout();
		}
		
		var _xField:String ;
		public function setXField(fieldName:String):String{
			_xField = fieldName;
			return fieldName;
		}
		
		var maxXValue:Int ;
		public override function setDataProvider(dpObject:Dynamic):Dynamic{	
			
			var dp:Array<Dynamic> = cast( dpObject, Array);
			for(i in 0...dp.length)
			{
				var object:Dynamic = dp[i];
				try
				{
					var xfValue:Float = Number(object[_xField])
					if(xfValue > maxXValue){
						maxXValue = xfValue;
					}
				}
				catch(e:Error)
				{
					trace("Could not find xValue value")
					continue;	
				}
			}
			super.dataProvider = dp;
			return dpObject;	
			
		}
		
		override function setRendererData(renderer:DisplayObject, data:Dynamic, index:Int):Void
		{
			super.setRendererData(renderer, data, index);
			if(Std.is( renderer, IHorizontalChartItemRenderer))
			{
				IHorizontalChartItemRenderer(renderer).maxXValue = this.maxXValue;
			}
		}

	}
