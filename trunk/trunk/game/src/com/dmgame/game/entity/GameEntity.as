package com.dmgame.game.entity
{
	import com.dmgame.game.scene.DMGame;
	import com.dmgame.logic.map.Map;
	import com.dmgame.xenon.sprite.DMSprite;
	import com.dmgame.xenon.sprite.DMSpriteAgent;
	import com.dmgame.xenon.sprite.DMSpritePool;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.dmgame.logic.entity.MapEntity;
	
	/**
	 * 游戏实体，带绘制功能
	 */
	public class GameEntity extends MapEntity
	{
		protected var sprite_:DMSprite; // 动作画片
		
		protected var body_:Sprite=new Sprite;
		protected var sprite_agent_:DMSpriteAgent = new DMSpriteAgent
		
		public function GameEntity()
		{
			DMGame.singleton_.addChild(body_);
			body_.addChild(sprite_agent_)
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
			
			sprite_agent_.free();
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
			if( skinAssetEntry_ && actionAssetEntry_ ) {
				sprite_ = DMSpritePool.singleton_.createSprite(skinAssetEntry_.pictureFolder+'body/'+actionAssetEntry_.picture_, true);
				sprite_agent_.setSprite(skinAssetEntry_.pictureFolder+'body/'+actionAssetEntry_.picture_, true);
			}
			else {
				if(sprite_) {
					DMSpritePool.singleton_.freeSprite(sprite_.file);
					sprite_ = null;
					sprite_agent_.free();
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
					
					sprite_agent_.render(direction, action_.currentFrame);
					body_.x = pos_.x - fixPoint.x - 50;
					body_.y = pos_.y - fixPoint.y;	
				}
				else {
					sprite_.render(-direction_, action_.currentFrame, screen, pos, true, true);
					
					sprite_agent_.render(-direction, action_.currentFrame, true);
					body_.x = pos_.x - fixPoint.x - 50;
					body_.y = pos_.y - fixPoint.y;	
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
					
					sprite_agent_.render(0, action_.currentFrame);
					body_.x = pos_.x - fixPoint.x - 50;
					body_.y = pos_.y - fixPoint.y;	
				}
				else {
					sprite_.render(0, action_.currentFrame, screen, pos, true, true);
					
					sprite_agent_.render(0, action_.currentFrame, true);
					body_.x = pos_.x - fixPoint.x - 50;
					body_.y = pos_.y - fixPoint.y;		
				}
			}
		}
	}
}