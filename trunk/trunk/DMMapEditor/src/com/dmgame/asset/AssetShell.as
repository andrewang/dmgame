package com.dmgame.asset
{
	import com.dmgame.xenon.asset.Asset;
	import com.dmgame.xenon.asset.AssetEntry;
	
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * 资源模板
	 */
	public class AssetShell extends Asset
	{
		/**
		 * 构造函数，设置条目产品创建函数
		 */
		public function AssetShell(createEntryFunction:Function)
		{
			super(createEntryFunction);
		}
		
		/**
		 * 保存文件
		 */
		public function save(fileName:String):void
		{
			var xml:XML = new XML('<Data/>');
	
			for each(var assetEntry:AssetEntry in entries_)
			{
				var objectXml:XML = new XML('<Object/>');
				objectXml.setName('Object');

				if(assetEntry.Save(objectXml)) {
					
					// 添加子节点
					xml.appendChild(objectXml);
				}
			}
			
			var stream:FileStream = new FileStream();
			var file:File = new File(fileName);               
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(xml.toString());
			stream.close();
		}
	}
}