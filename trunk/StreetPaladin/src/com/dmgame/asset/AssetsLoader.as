package com.dmgame.asset
{
	import com.dmgame.dmlogic.map.Map;
	import com.dmgame.xenon.asset.Asset;
	import com.dmgame.dmlogic.asset.ActionEntry;
	import com.dmgame.dmlogic.asset.Assets;
	import com.dmgame.dmlogic.asset.MapEntry;
	import com.dmgame.dmlogic.asset.MapConfig;
	import com.dmgame.dmlogic.asset.SkinAssetEntry;

	/**
	 * 游戏资源加载器
	 */
	public class AssetsLoader
	{
		private var assetLoadedCount_:int = 0;
		
		private var assetLoadingCount_:int = 0;
		
		private var onLoadCompleteEvent_:Function = null; // 配置读取完成事件
		
		public function AssetsLoader()
		{
		}
		
		/**
		 * 加载所有必要资源
		 */
		public function load(onLoadCompleteEvent:Function):void
		{
			onLoadCompleteEvent_ = onLoadCompleteEvent;
			
			Assets.singleton_.skinAsset_.load('assets/character/skin.xml', onFirstAssetLoadComplete);
			++assetLoadingCount_;
			
			Assets.singleton_.mapAsset_.load('assets/map/map_list.xml', onFirstAssetLoadComplete);
			++assetLoadingCount_;
		}
		
		/**
		 * 皮肤文件加载完毕
		 */
		private function onFirstAssetLoadComplete():void
		{
			++assetLoadedCount_;
			if(assetLoadedCount_ != assetLoadingCount_) {
				return;
			}
			
			for each(var skinAssetEntry:SkinAssetEntry in Assets.singleton_.skinAsset_.entries_)
			{
				var actionFile:String = skinAssetEntry.actionFile;
				if(Assets.singleton_.actionAsset_[actionFile] == null) {
					
					// 加载动作配置文件
					var asset:Asset = new Asset(ActionEntry.CreateEntry)
					asset.load(actionFile, onSecondAssetLoadComplete);
					Assets.singleton_.actionAsset_[actionFile] = asset;
					
					++assetLoadingCount_;
				}
			}
		}
		
		/**
		 * 固定资源加载数统计
		 */
		private function onSecondAssetLoadComplete():void
		{
			++assetLoadedCount_;
			if(assetLoadedCount_ != assetLoadingCount_) {
				return;
			}
			
			if(onLoadCompleteEvent_ != null) {
				onLoadCompleteEvent_();
				onLoadCompleteEvent_ = null;
			}
		}
	}
}