package com.dmgame.asset
{
	/**
	 * 游戏核心资料加载器
	 */
	public class Assets
	{
		public var mapAsset_:Asset = new Asset(MapAssetEntry.CreateEntry); // 地图配置
		
		public var skinAsset_:Asset = new Asset(SkinAssetEntry.CreateEntry); // 皮肤配置
		
		public var actionAsset_:Array = []; // 动作配置集合

		public var mapGridAsset_:Array = []; // 地表文件配置
		
		public static var singleton_:Assets; // 单件
		
		/**
		 * 构造函数，设置单件
		 */
		public function Assets()
		{
			singleton_ = this;
		}
	}
}