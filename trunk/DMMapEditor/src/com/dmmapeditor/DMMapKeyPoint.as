package com.dmmapeditor
{
	import com.dmgame.logic.asset.MapKeyPointEntry;
	import com.dmgame.xenon.asset.Asset;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class DMMapKeyPoint
	{
		protected var circle_:Shape = new Shape; // 形状
		
		protected var keyPointAsset_:Asset; // 跳转配置
		
		public function DMMapKeyPoint(keyPointAsset:Asset)
		{
			keyPointAsset_ = keyPointAsset;
			
			circle_.graphics.lineStyle(1,0x000000,1);//圆形边框线条样式
			circle_.graphics.beginFill(0x00ffff, .5);//圆形内的填充颜色
			circle_.graphics.drawCircle(0,0,50);//绘制圆形
			circle_.graphics.endFill()
		}
		
		public function render(bitmapData:BitmapData, posx:int, posy:int):void
		{
			for each(var entry:MapKeyPointEntry in keyPointAsset_.entries_)
			{
				bitmapData.draw(circle_, new Matrix(1,0,0,1,entry.posx_-posx,entry.posy_-posy));
			}
		}
	}
}