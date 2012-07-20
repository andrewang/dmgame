package com.dmgame.dmlogic.asset
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class MapConfig
	{
		public var mapWidth_:int; // 地图宽
		
		public var mapHeight_:int; // 地图高
		
		public var tileWidth_:int; // 地表切片宽
		
		public var tileHeight_:int; // 地表切片高
		
		public var tileFormat_:String; // 地表资源后缀
		
		protected var onLoadCompleteEvent_:Function; // 完成事件函数
		
		public function MapConfig()
		{
		}
		
		/**
		 * 加载文件
		 */
		public function load(fileName:String, onLoadCompleteEvent:Function):void
		{
			onLoadCompleteEvent_ = onLoadCompleteEvent;
			
			var xmlLoader:URLLoader = new URLLoader(new URLRequest(fileName));
			xmlLoader.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		/**
		 * 加载完毕
		 */
		protected function onLoadComplete(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			loadXml(xml);
			
			// 移除事件
			event.target.removeEventListener(Event.COMPLETE, onLoadComplete);
			
			// 触发用户请求的事件函数
			if(onLoadCompleteEvent_ != null) {
				onLoadCompleteEvent_();
				onLoadCompleteEvent_ = null;
			}
		}
		
		/**
		 * 读取文件
		 */
		protected function loadXml(xml:XML):void
		{
			var xmlList:XMLList;
			
			xmlList = xml.child('Width');
			if(xmlList.length() > 0) {
				mapWidth_ = xmlList[0].text();
			}
			
			xmlList = xml.child('Height');
			if(xmlList.length() > 0) {
				mapHeight_ = xmlList[0].text();
			}
			
			xmlList = xml.child('TileW');
			if(xmlList.length() > 0) {
				tileWidth_ = xmlList[0].text();
			}
			
			xmlList = xml.child('TileH');
			if(xmlList.length() > 0) {
				tileHeight_ = xmlList[0].text();
			}
			
			xmlList = xml.child('TileFormat');
			if(xmlList.length() > 0) {
				tileFormat_ = xmlList[0].text();
			}
			else {
				tileFormat_ = 'jpg';
			}
		}
	}
}