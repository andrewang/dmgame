package com.dmgame.dmsprite
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * 带中心点，每帧都是平均大小的精灵图
	 */
	public class DMSprite
	{
		private var info_:DMSpriteInfo = null; // 图片信息
		
		private var frameBitmapData_:Array = null; // 帧位图数据
		
		private var infoLoader_:URLLoader = null; // 图片信息加载器
		
		private var bitmapDataLoader_:Loader = null; // 图片加载器
		
		public function DMSprite(file:String)
		{
			infoLoader_ = new URLLoader;
			infoLoader_.dataFormat = URLLoaderDataFormat.BINARY;
			infoLoader_.load(new URLRequest(file+'.inf'));
			infoLoader_.addEventListener(Event.COMPLETE, onInfoLoadComplete);
			
			bitmapDataLoader_ = new Loader;
			bitmapDataLoader_.load(new URLRequest(file));
			bitmapDataLoader_.contentLoaderInfo.addEventListener(Event.COMPLETE, onBitmapDataLoadComplete);
		}
		
		public function render(line:uint, frame:uint, screen:BitmapData, pos:Point):Boolean
		{
			if(frameBitmapData_ && info_ && line < info_.line && frame < info_.frame) {
				var frameBitmapData:BitmapData = (frameBitmapData_[line] as Array)[frame];
				var tempPos:Point = null;
				if(info_.centerPos) {
					tempPos = new Point(pos.x - info_.centerPos.x, pos.y - info_.centerPos.y);
				}
				else {
					tempPos = pos;
				}
				screen.copyPixels(frameBitmapData, new Rectangle(0,0,frameBitmapData.width,frameBitmapData.height), tempPos);
				return true;
			}
			else {
				return false;
			}
		}
		
		private function onInfoLoadComplete(event:Event):void
		{
			info_ = new DMSpriteInfo;
			info_.parseFromBytes(infoLoader_.data as ByteArray);
			
			infoLoader_.removeEventListener(Event.COMPLETE, onInfoLoadComplete);
			infoLoader_ = null;
		}
		
		private function onBitmapDataLoadComplete(event:Event):void
		{
			var bitmapData:BitmapData = (bitmapDataLoader_.contentLoaderInfo.content as Bitmap).bitmapData;
			
			if(info_ && bitmapData.width == info_.width && bitmapData.height == info_.height) {
				
				frameBitmapData_ = new Array;
				
				for(var i:int=0; i<info_.line; ++i)
				{
					frameBitmapData_.push(new Array);
					
					for(var j:int=0; j<info_.frame; ++j)
					{
						var frameBitmapData:BitmapData = new BitmapData(info_.frameWidth, info_.frameHeight);
						frameBitmapData.copyPixels(bitmapData, 
							new Rectangle(j*info_.frameWidth, i*info_.frameHeight, (j+1)*info_.frameWidth, (i+1)*info_.frameHeight),
							new Point(0, 0));
						frameBitmapData_[i].push(frameBitmapData);
					}
				}
			}

			bitmapDataLoader_.unload();
			bitmapDataLoader_.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBitmapDataLoadComplete);
			bitmapDataLoader_ = null;
		}
	}
}