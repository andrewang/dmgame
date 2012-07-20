package com.dmgame.dmgame.scene
{
	import com.dmgame.dmlogic.entity.Entity;
	import com.dmgame.dmlogic.entity.MapEntity;
	import com.dmgame.dmgame.map.GameMap;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * 摄像机控制器，摄像机有两种模式，实体跟踪模式与坐标模式
	 */
	public class DMCamera
	{
		protected var cameraView_:Rectangle; // 摄像机可视区域
		
		protected var gameMap_:GameMap; // 场景地图
		
		protected var viewWidth_:int; // 视野宽
		
		protected var viewHeight_:int; // 视野高
		
		protected var entityFocus_:MapEntity; // 实体注视模式（永远盯着一个实体不放）
		
		protected var lastTime_:int; // 最后一次镜头跟踪时间
		
		protected var targetPos_:Point = new Point(0,0); // 摄像机实际移动的目标点
		
		protected var currentPos_:Point = new Point(0,0); // 摄像机当前位置
		
		protected var moveInterval_:int = 20; // 移动速度，调整一次的时间间隔
		
		protected var moveSpeedx_:Number = 1; // 提速
		
		protected var moveSpeedy_:Number = 1; // 提速
		
		protected var movePer_:int = 50; // 移动距离百分比
		
		protected var moveMinDistancex_:int = 200; // 超过该值就需要移动摄像机
		
		protected var moveMinDistancey_:int = 100; // 超过该值就需要移动摄像机
		
		protected var moveMaxDistancex_:int = 400; // 超过该值就需要加速移动摄像机
		
		protected var moveMaxDistancey_:int = 200; // 超过该值就需要加速移动摄像机
		
		/**
		 * 构造函数
		 */
		public function DMCamera()
		{
		}
		
		/**
		 * 设置摄像机视野大小
		 */
		public function setViewSize(viewWidth:int, viewHeight:int):void
		{
			viewWidth_ = viewWidth;
			viewHeight_ = viewHeight;
			
			// 提供正常的摄像机初始位置（最左上角）
			fixPos(currentPos_);
			targetPos_.copyFrom(currentPos_);
		}
		
		/**
		 * 设置场景边界
		 */
		public function setGameMap(gameMap:GameMap):void
		{
			gameMap_ = gameMap;
			
			// 提供正常的摄像机初始位置（最左上角）
			fixPos(currentPos_);
			targetPos_.copyFrom(currentPos_);
		}
		
		/**
		 * 注视实体
		 */
		public function lookAtEntity(entity:MapEntity, reset:Boolean = true):void
		{
			entityFocus_ = entity;
			
			if(reset) {
				currentPos.copyFrom(entityFocus_.pos);
				fixPos(currentPos_);
			}
		}
		
		/**
		 * 注视坐标
		 */
		public function lookAtPos(pos:Point, reset:Boolean = true):void
		{
			if(reset) {
				currentPos.copyFrom(pos);
				fixPos(currentPos_);
				
				targetPos_.copyFrom(currentPos_);
			}
			else {
				targetPos_.copyFrom(pos);
			}
		}
		
		/**
		 * 获取地图左上角
		 */
		public function get mapPos():Point
		{
			var mapPos:Point;
			
			if(currentPos_) {
				
				mapPos = currentPos_.clone();
				mapPos.x -= viewWidth_/2;
				mapPos.y -= viewHeight_/2;
			}
			return mapPos;
		}
		
		/**
		 * 修正摄像机位置
		 */
		protected function fixPos(pos:Point):void
		{
			if(pos == null || gameMap_ == null) {
				return;
			}
			
			if(pos.x < viewWidth_/2) {
				pos.x = viewWidth_/2;
			}
			else if(pos.x > gameMap_.width_ - viewWidth_/2) {
				pos.x = gameMap_.width_ - viewWidth_/2;
			}
			
			if(pos.y < viewHeight_/2) {
				pos.y = viewHeight_/2;
			}
			else if(pos.y > gameMap_.height_ - viewHeight_/2) {
				pos.y = gameMap_.height_ - viewHeight_/2;
			}
		}
		
		/**
		 * 更新摄像机位置
		 */
		public function update():void
		{
			if(entityFocus_ != null) {
				targetPos_.copyFrom(entityFocus_.pos);
			}
			fixPos(targetPos_);
	
			var time:int = DMGame.currentTime - lastTime_;
			while(time >= moveInterval_) 
			{
				time -= moveInterval_;
				lastTime_ += moveInterval_;
				
				var dx:int = targetPos_.x - currentPos_.x;
				var dy:int = targetPos_.y - currentPos_.y;
					
				if(Math.abs(dx) > moveMaxDistancex_) {
					moveSpeedx_ += Math.abs(dx)/moveMaxDistancex_;
				}
				else if(Math.abs(dx) > 10) {
					moveSpeedx_ = 1;
				}
				else {
					moveSpeedx_ = 0;
				}
					
				if(Math.abs(dy) > moveMaxDistancey_) {
					moveSpeedy_ += Math.abs(dy)/moveMaxDistancey_;
				}
				else if(Math.abs(dy) > 10) {
					moveSpeedy_ = 1;
				}
				else {
					moveSpeedy_ = 0;
				}
					
				if(moveSpeedx_ == 0 && moveSpeedy_ == 0) {
					break;
				}
				else {
					currentPos_.x += dx/movePer_*moveSpeedx_;
					currentPos_.y += dy/movePer_*moveSpeedy_;
				}
			}
		}
		
		public function get currentPos():Point
		{
			return currentPos_;
		}
	}
}