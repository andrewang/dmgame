package com.dmgame.logic.asset
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class MapGridAsset
	{
		public var mapWidth_:int; // 地图宽
		
		public var mapHeight_:int; // 地图高
		
		public var tileWidth_:int; // 地表切片宽
		
		public var tileHeight_:int; // 地表切片高
		
		public var tileFormat_:String; // 地表资源后缀
		
		protected var onLoadCompleteEvent_:Function; // 完成事件函数
		
		protected var xmlLoader_:URLLoader; // xml加载器
		
		public function MapGridAsset()
		{
		}
		
		/**
		 * 加载文件
		 */
		public function load(file:String, onLoadCompleteEvent:Function):void
		{
			onLoadCompleteEvent_ = onLoadCompleteEvent;
			
			xmlLoader_ = new URLLoader(new URLRequest(file));
			xmlLoader_.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		/**
		 * 加载完毕
		 */
		protected function onLoadComplete(event:Event):void
		{
			var xml:XML = new XML(xmlLoader_.data);
			loadXml(xml);
			
			// 移除事件
			xmlLoader_.removeEventListener(Event.COMPLETE, onLoadComplete);
			
			// 触发用户请求的事件函数
			if(onLoadCompleteEvent_ != null) {
				onLoadCompleteEvent_();
				onLoadCompleteEvent_ = null;
			}
		}
		
		/**
		 * 读取文件
		 */
		public function loadXml(xml:XML):void
		{
			var xmlList:XMLList;
			
			xmlList = xml.child('mapW');
			if(xmlList.length() > 0) {
				mapWidth_ = xmlList[0].text();
			}
			
			xmlList = xml.child('mapH');
			if(xmlList.length() > 0) {
				mapHeight_ = xmlList[0].text();
			}
			
			xmlList = xml.child('tileX');
			if(xmlList.length() > 0) {
				tileWidth_ = xmlList[0].text();
			}
			
			xmlList = xml.child('tileY');
			if(xmlList.length() > 0) {
				tileHeight_ = xmlList[0].text();
			}
			
			xmlList = xml.child('tileFormat');
			if(xmlList.length() > 0) {
				tileFormat_ = xmlList[0].text();
			}
		}
	}
}