package com.dmgame.entity
{
	import com.dmgame.map.Map;
	import com.dmgame.sprite.DMSprite;
	import com.dmgame.sprite.DMSpritePool;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * 游戏实体，带绘制功能
	 */
	public class GameEntity extends MapEntity
	{
		protected var sprite_:DMSprite; // 动作画片
		
		public function GameEntity()
		{
		}
		
		/**
		 * 销毁
		 */
		public function destroy():void
		{
			if(sprite_) {
				DMSpritePool.singleton_.freeSprite(sprite_.file);
				sprite_ = null;
			}
		}
		
		/**
		 * 更换皮肤
		 */
		override public function set skinID(value:int):void
		{
			super.skinID = value;
			loadSprite();
		}
		
		/**
		 * 更换动作
		 */
		override public function setAction(value:String, loop:Boolean=false, onEnd:Function=null, effectCallback:Function=null):void
		{
			super.setAction(value, loop, onEnd, effectCallback);
			loadSprite();
		}
		
		/**
		 * 加载精灵图
		 */
		protected function loadSprite():void	
		{
			if(skinAssetEntry_ && actionAssetEntry_) {
				sprite_ = DMSpritePool.singleton_.createSprite(skinAssetEntry_.pictureFolder+'body/'+actionAssetEntry_.picture_, true);
			}
			else {
				if(sprite_) {
					DMSpritePool.singleton_.freeSprite(sprite_.file);
					sprite_ = null;
				}
			}
		}
		
		/**
		 * 绘制
		 */
		public function render(screen:BitmapData, fixPoint:Point):void
		{
			if(actionAssetEntry_) {
				
				if(actionAssetEntry_.diretion_ == 5) {
					render8Directions(screen, fixPoint);
				}
				else if(actionAssetEntry_.diretion_ == 1) {
					render2Directions(screen, fixPoint);
				}
			}
		}

		/**
		 * 绘制5方向
		 */
		public function render8Directions(screen:BitmapData, fixPoint:Point):void
		{
			if(sprite_ && action_) {
				var pos:Point = new Point(pos_.x-fixPoint.x, pos_.y-fixPoint.y);
				
				if(direction_ >= 0) {
					sprite_.render(direction, action_.currentFrame, screen, pos);
				}
				else {
					sprite_.render(-direction_, action_.currentFrame, screen, pos, true, true);
				}
			}
		}
		
		/**
		 * 绘制1方向
		 */
		public function render2Directions(screen:BitmapData, fixPoint:Point):void
		{
			if(sprite_ && action_) {
				var pos:Point = new Point(pos_.x-fixPoint.x, pos_.y-fixPoint.y);
				
				if(direction_ == 2) {
					sprite_.render(0, action_.currentFrame, screen, pos);
				}
				else if(direction_ == -2) {
					sprite_.render(0, action_.currentFrame, screen, pos, true, true);
				}
			}
		}
	}
}