package com.dmmapeditor
{
	import com.dmgame.asset.BaseMapEntryShell;
	import com.dmgame.asset.BaseMapConfigShell;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import org.osmf.media.LoadableElementBase;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;

	public class DMSmallMapView
	{
		public static var singleton_:DMSmallMapView; // 单件
		
		protected var bitmapData_:BitmapData; // 位图
		
		protected var smallMapBitmapData_:BitmapData; // 小地图位图
		
		protected var group_:Group; // 组
		
		protected var mapTileAsset_:BaseMapConfigShell; // 地表配置
		
		public var scale_:Number; // 缩放倍率
		
		public function DMSmallMapView(group:Group)
		{
			singleton_ = this;
			
			group_ = group;
			
			// 提供一个bitmap的画板给我
			bitmapData_ = new BitmapData(group_.width, group_.height, false, 0);
			
			var spriteElement:SpriteVisualElement = new SpriteVisualElement;
			spriteElement.addChild(new Bitmap(bitmapData_));
			
			group_.addElement(spriteElement);
		}
		
		public function Init(mapAssetEntry:BaseMapEntryShell, mapTileAsset:BaseMapConfigShell):void
		{
			mapTileAsset_ = mapTileAsset;
			
			// 获取缩略图
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSmallMapLoadComplete);
			loader.load(new URLRequest(DMMapEditorCore.singleton_.url_+'assets/tiles/'+mapAssetEntry.id_+'/s.jpg'));
		}
		
		protected function onSmallMapLoadComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onSmallMapLoadComplete);
			
			smallMapBitmapData_ = (loaderInfo.content as Bitmap).bitmapData.clone();
			
			scale_ = mapTileAsset_.mapWidth_ / smallMapBitmapData_.width;
		}
		
		public function Update():void
		{
			// 更新绘制
			if(smallMapBitmapData_) {
				bitmapData_.copyPixels(smallMapBitmapData_, new Rectangle(0,0,smallMapBitmapData_.width,smallMapBitmapData_.height), new Point);
			}
		}
	}
}