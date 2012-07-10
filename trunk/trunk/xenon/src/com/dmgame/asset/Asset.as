package com.dmgame.asset
{
	import flash.events.*;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * 资源模板
	 */
	public class Asset
	{
		public var entries_:Dictionary = new Dictionary; // 条目
		
		private var xmlLoader_:URLLoader = null; // 加载器
		
		private var createEntryFunction_:Function = null; // 条目创建函数
		
		private var onLoadCompleteEvent_:Function = null; // 加载完成事件
		
		/**
		 * 构造函数，设置条目产品创建函数
		 */
		public function Asset(createEntryFunction:Function)
		{
			createEntryFunction_ = createEntryFunction;
		}
		
		/**
		 * 加载文件
		 */
		public function load(file:String, onLoadCompleteEvent:Function):void
		{
			if(createEntryFunction_ == null) {
				return;
			}
			
			onLoadCompleteEvent_ = onLoadCompleteEvent;
			
			xmlLoader_ = new URLLoader(new URLRequest(file));
			xmlLoader_.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		/**
		 * 保存文件
		 */
		public function save(file:String):void
		{
			var fileRef:FileReference = new FileReference();
			fileRef.addEventListener(Event.COMPLETE, onSaveComplete);
			
			var xml:XML = new XML;
			xml.setName('Data');
			
			for each(var assetEntry:AssetEntry in entries_)
			{
				var objectXml:XML = new XML;
				objectXml.setName('Object');

				if(assetEntry.Save(objectXml)) {
					
					// 添加子节点
					xml.appendChild(objectXml);
				}
			}
			fileRef.save(xml.toString(), file);
		}
		
		/**
		 * 资料加载完成
		 */
		private function onLoadComplete(event:Event):void
		{
			var xml:XML = new XML(xmlLoader_.data);
			if(xml.name() == "Data") {
				
				var xmlList:XMLList = xml.child("Object");
				if(xmlList.length() > 0) {
					
					for(var i:int = 0; i<xmlList.length(); ++i)
					{
						var assetEntry:AssetEntry = createEntryFunction_();
						if(assetEntry.Load(xmlList[i])) {
							
							var id:* = assetEntry.ID();
							if(id != null) {
								entries_[id] = assetEntry;
							}
						}
					}
				}
			}
			xmlLoader_.removeEventListener(Event.COMPLETE, onLoadComplete);
			
			// 触发用户请求的事件函数
			if(onLoadCompleteEvent_ != null) {
				onLoadCompleteEvent_();
				onLoadCompleteEvent_ = null;
			}
		}
		
		/**
		 * 资料保存完成
		 */
		private function onSaveComplete(event:Event):void
		{
			
		}
	}
}