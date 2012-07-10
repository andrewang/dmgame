package com.dmgame.sprite
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * 带中心点，每帧都是平均大小的精灵图
	 */
	public class DMSprite
	{
		private var file_:String; // 文件名称
		
		private var picture_:String; // 图片文件
		
		private var width_:uint; // 宽度
		
		private var height_:uint; // 高度
		
		private var line_:uint = 1; // 行数
		
		private var frame_:uint = 1; // 列数
		
		private var centerPos_:Point = new Point(0, 0); // 中心点偏移
		
		private var frameWidth_:uint; // 帧宽度
		
		private var frameHeight_:uint; // 帧高度
		
		private var infoLoader_:URLLoader; // 图片信息加载器
		
		private var bitmapData_:BitmapData; // 位图数据
		
		private var bitmapDataMirror_:BitmapData; // 镜像位图数据
		
		private var bitmapDataLoader_:Loader; // 图片加载器
		
		private var mirror_:Boolean = false; // 拥有镜像位图
		
		/**
		 * 构造函数，获取图片配置
		 */
		public function DMSprite(file:String, mirror:Boolean=false)
		{
			var array:Array = file.split('.');
			var format:String = array[array.length-1];
			
			if(format == 'xml') {
				
				// 申请加载图片信息
				infoLoader_ = new URLLoader;
				infoLoader_.load(new URLRequest(file));
				infoLoader_.addEventListener(Event.COMPLETE, onInfoLoadComplete);
			}
			else {
				
				// 申请加载位图资料
				bitmapDataLoader_ = new Loader;
				bitmapDataLoader_.load(new URLRequest(file));
				bitmapDataLoader_.contentLoaderInfo.addEventListener(Event.COMPLETE, onBitmapDataLoadComplete);
			}
			file_ = file;
			mirror_ = mirror;
		}
		
		/**
		 * 销毁函数
		 */
		public function destroy():void
		{
			if(bitmapData_) {
				bitmapData_.dispose();
			}
		}
		
		/**
		 * 获取文件名称
		 */
		public function get file():String
		{
			return file_;
		}
		
		/**
		 * 绘制函数，资料未加载完成之前无法正常绘制
		 */
		public function render(line:uint, frame:uint, screen:BitmapData, pos:Point, mergeAlpha:Boolean=true, mirror:Boolean=false):Boolean
		{
			if(bitmapData_ && line < line_ && frame < frame_) {
				var tempPos:Point = new Point(pos.x - centerPos_.x, pos.y - centerPos_.y);
				screen.copyPixels(mirror ? bitmapDataMirror_ : bitmapData_, new Rectangle(frame*frameWidth_, line*frameHeight_, frameWidth_, frameHeight_), tempPos, null, null, mergeAlpha);
				return true;
			}
			else {
				return false;
			}
		}
		
		/**
		 * 图片信息资料加载完毕
		 */
		private function onInfoLoadComplete(event:Event):void
		{
			loadXml(new XML(infoLoader_.data));
			
			// 移除图片信息加载器
			infoLoader_.removeEventListener(Event.COMPLETE, onInfoLoadComplete);
			infoLoader_ = null;
			
			// 申请加载位图资料
			bitmapDataLoader_ = new Loader;
			bitmapDataLoader_.load(new URLRequest(picture_));
			bitmapDataLoader_.contentLoaderInfo.addEventListener(Event.COMPLETE, onBitmapDataLoadComplete);
		}
		
		/**
		 * 读取xml内容并申请加载位图资料
		 */
		private function loadXml(xml:XML):void
		{
			if(xml.name() == "Data") {
				
				var xmlList:XMLList = xml.child("Picture");
				if(xmlList.length() > 0) {
					picture_ = xmlList[0].text();
				}
				
				xmlList = xml.child("Line");
				if(xmlList.length() > 0) {
					line_ = xmlList[0].text();
				}
				
				xmlList = xml.child("Frame");
				if(xmlList.length() > 0) {
					frame_ = xmlList[0].text();
				}
				
				xmlList = xml.child("CenterPos");
				if(xmlList.length() > 0) {
					var centerPosText:String = xmlList[0].text();
					var centerPos:Array = centerPosText.split(',');
					centerPos_.x = centerPos[0];
					centerPos_.y = centerPos[1];
				}
			}
		}
		
		/**
		 * 位图资料加载完毕
		 */
		private function onBitmapDataLoadComplete(event:Event):void
		{
			var bitmap:Bitmap = (bitmapDataLoader_.contentLoaderInfo.content as Bitmap);
			bitmapData_ = bitmap.bitmapData.clone();
			
			if(mirror_ == true) {
				var matrix:Matrix = new Matrix(-1, 0, 0, 1, bitmap.width);
				bitmapDataMirror_ = new BitmapData(bitmap.width, bitmap.height, true, 0x00000000);
				bitmapDataMirror_.draw(bitmap, matrix);
			}
			
			// 修正大小
			width_ = bitmapData_.width;
			height_ = bitmapData_.height;
			
			frameWidth_ = width_ / frame_;
			frameHeight_ = height_ / line_;

			// 移除位图资料加载器
			bitmapDataLoader_.unload();
			bitmapDataLoader_.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBitmapDataLoadComplete);
			bitmapDataLoader_ = null;
		}
	}
}