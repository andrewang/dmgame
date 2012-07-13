package com.dmgame.asset
{
	import com.dmgame.logic.asset.MapConfig;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class BaseMapConfigShell extends MapConfig
	{
		public function BaseMapConfigShell()
		{
		}
		
		/**
		 * 保存文件
		 */
		public function save(fileName:String):void
		{
			var xml:XML = new XML('<Data></Data>');
			saveXml(xml);

			var stream:FileStream = new FileStream();
			var file:File = new File(fileName);               
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(xml.toString());
			stream.close();
		}
		
		/**
		 * 保存文件
		 */
		protected function saveXml(xml:XML):Boolean
		{
			var childXml:XML = <Width>{mapWidth_}</Width>;
			xml.appendChild(childXml);
			
			childXml = <Height>{mapHeight_}</Height>;
			xml.appendChild(childXml);
			
			childXml = <TileW>{tileWidth_}</TileW>;
			xml.appendChild(childXml);

			childXml = <TileH>{tileHeight_}</TileH>;
			xml.appendChild(childXml);
			
			return true;
		}
	}
}