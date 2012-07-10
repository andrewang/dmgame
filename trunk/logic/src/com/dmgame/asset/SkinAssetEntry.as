package com.dmgame.asset
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 外形资料条目
	 */
	public class SkinAssetEntry extends AssetEntry
	{
		public var id:int = 0; //	编号
		
		public var name:String = null; //	名称
		
		public var pictureFolder:String = null; //	图片文件夹
		
		public var actionFile:String = null; //	动作文件
		
		/**
		 * 构造函数
		 */
		public function SkinAssetEntry()
		{
			super();
		}
		
		/**
		 * 条目索引
		 */
		override public function ID():*
		{
			return id;
		}
		
		/**
		 * 读取条目
		 */
		override public function Load(xml:XML):Boolean
		{
			var xmlList:XMLList = xml.child("ID");
			if(xmlList.length() > 0) {
				id = xmlList[0].text();
			}
			
			xmlList = xml.child("Name");
			if(xmlList.length() > 0) {
				name = xmlList[0].text();
			}
			
			xmlList = xml.child("PictureFolder");
			if(xmlList.length() > 0) {
				pictureFolder = xmlList[0].text();
			}
			
			xmlList = xml.child("ActionFile");
			if(xmlList.length() > 0) {
				actionFile = xmlList[0].text();
			}
			return true;
		}
		
		/**
		 * 创建皮肤条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new SkinAssetEntry;
		}
	}
}