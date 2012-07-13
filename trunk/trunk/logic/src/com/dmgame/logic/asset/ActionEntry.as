package com.dmgame.logic.asset
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.dmgame.xenon.asset.AssetEntry;
	
	/**
	 * 动作资料条目
	 */
	public class ActionEntry extends AssetEntry
	{
		public var name:String; // 动作名称
		
		public var amount:int; // 总帧数
		
		public var diretion_:int; // 方向
		
		public var frameTime:Array; // 动态动作帧时间
		
		public var effectFrame_:int = -1; // 生效帧（攻击专用）
		
		public var picture_:String; // 动作对应图片
		
		/**
		 * 构造函数
		 */
		public function ActionEntry()
		{
			super();
		}
	
		/**
		 * 条目索引
		 */
		override public function ID():*
		{
			return name;
		}
		
		/**
		 * 读取条目
		 */
		override public function Load(xml:XML):Boolean
		{
			var xmlList:XMLList = xml.child("Name");
			if(xmlList.length() > 0) {
				name = xmlList[0].text();
			}
			
			xmlList = xml.child("Amount");
			if(xmlList.length() > 0) {
				amount = xmlList[0].text();
			}
			
			xmlList = xml.child("Direction");
			if(xmlList.length() > 0) {
				diretion_ = xmlList[0].text();
			}
			
			xmlList = xml.child("FrameTime");
			if(xmlList.length() > 0) {
				var str:String = xmlList[0].text();
				
				var frameTimeText:Array = str.split(',');
				if(frameTimeText.length != amount) {
					return false;
				}
				
				frameTime = new Array;
				for(var i:int=0; i<frameTimeText.length; ++i)
				{
					frameTime.push(int(frameTimeText[i]));
				}
			}
			
			xmlList = xml.child("EffectFrame");
			if(xmlList.length() > 0) {
				effectFrame_ = xmlList[0].text();
			}
			
			xmlList = xml.child("PictureName");
			if(xmlList.length() > 0) {
				picture_ = xmlList[0].text();
			}
			
			return true;
		}
		
		/**
		 * 创建动作条目
		 */
		public static function CreateEntry():AssetEntry
		{
			return new ActionEntry;
		}
	}
}