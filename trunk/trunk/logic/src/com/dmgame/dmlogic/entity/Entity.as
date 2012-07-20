package com.dmgame.dmlogic.entity
{
	import com.dmgame.dmlogic.asset.ActionEntry;
	import com.dmgame.xenon.asset.Asset;
	import com.dmgame.dmlogic.asset.Assets;
	import com.dmgame.dmlogic.asset.SkinAssetEntry;
	import com.dmgame.dmlogic.map.Map;
	import com.dmgame.xenon.sprite.DMAction;
	import com.dmgame.xenon.sprite.DMSprite;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class Entity
	{
		protected var skinID_:int; // 皮肤
		
		protected var actionName_:String; // 行为名称
		
		protected var skinAssetEntry_:SkinAssetEntry; // 皮肤配置条目
		
		protected var actionAsset_:Asset; // 动作配置
		
		protected var actionAssetEntry_:ActionEntry; // 动作配置条目
		
		protected var action_:DMAction = new DMAction; // 动作配置
		
		protected var direction_:int = EntityDirections.down; // 方向
		
		protected var actionLoop_:Boolean = false; // 动作循环
		
		protected var actionEnd_:Function; // 动作结束事件
		
		/**
		 * 构造函数
		 */
		public function Entity()
		{
			
		}
		
		/**
		 * 更换皮肤
		 */
		public function set skinID(value:int):void
		{
			if(skinID_ == value) {
				return;
			}
				
			skinID_ = value;
			skinAssetEntry_ = (Assets.singleton_.skinAsset_.entries_[skinID_] as SkinAssetEntry);
			
			// 事件会丢失
			loadAction(null);
		}
		
		/**
		 * 更换动作
		 */
		public function setAction(value:String, loop:Boolean=false, actionEnd:Function=null, effectCallback:Function=null):void
		{
			// 相同名称的循环动作，不需要重新开始播放
			if(value == actionName_ && 
				actionLoop_ == true && 
				actionLoop_ == loop) {
				return;
			}
				
			actionName_ = value;
			actionLoop_ = loop;
			actionEnd_ = actionEnd;
			
			loadAction(effectCallback);
		}
		
		/**
		 * 更新动作对象
		 */
		protected function loadAction(effectCallback:Function):void
		{
			// 确认皮肤文件存在
			if(skinAssetEntry_ == null) {
				return;
			}
				
			// 获取皮肤中对应动作配置
			actionAsset_ = (Assets.singleton_.actionAsset_[skinAssetEntry_.actionFile] as Asset);
			if(actionAsset_ == null) {
				return;
			}
			
			// 读取动作条目
			actionAssetEntry_ = (actionAsset_.entries_[actionName_] as ActionEntry);
			if(actionAssetEntry_) {
				
				// 创建动作对象
				action_.init(actionAssetEntry_.frameTime, actionLoop_, getTimer());
				
				if(effectCallback != null && actionAssetEntry_.effectFrame_ >= 0) {
					action_.registerFrameEvent(actionAssetEntry_.effectFrame_, effectCallback);
				}
			}
		}
		
		/**
		 * 设置与获取方向
		 */
		public function set direction(value:int):void
		{
			direction_ = value;
		}
		
		public function get direction():int
		{
			return direction_;
		}
		
		/**
		 * 实体更新
		 */
		public function update(currentTime:int):void
		{
			if(action_) {
				
				if(action_.update(currentTime) && actionEnd_ != null) {
					actionEnd_();
				}
			}
		}
		
		/**
		 * 获取皮肤配置
		 */
		public function get skinAssetEntry():SkinAssetEntry
		{
			return skinAssetEntry_;
		}
		
		/**
		 * 获取动作配置
		 */
		public function get actionAssetEntry():ActionEntry
		{
			return actionAssetEntry_;
		}
		
		/**
		 * 获取动作对象
		 */
		public function get action():DMAction
		{
			return action_;
		}
	}
}