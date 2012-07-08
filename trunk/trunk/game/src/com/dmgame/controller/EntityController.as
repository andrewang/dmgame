package com.dmgame.controller
{
	import com.dmgame.entity.Entity;
	import com.dmgame.entity.EntityDirections;
	import com.dmgame.entity.MapEntity;
	import com.dmgame.game.DMGame;
	import com.dmgame.logic.Logic;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;

	/**
	 * 实体操作器
	 */
	public class EntityController
	{
		protected var targetPos_:Point; // 鼠标移动模式中的移动目标点
		
		protected var path_:Array; // 寻路路径
		
		protected var me_:MapEntity; // 操作实体
		
		protected var yKey_:int; // y轴移动
		
		protected var xKey_:int; // x轴移动
		
		/**
		 * 构造函数
		 */
		public function EntityController()
		{
			setupListener();
		}
		
		/**
		 * 安装监听者
		 */
		private function setupListener():void
		{
			DMGame.singleton_.stage_.doubleClickEnabled = true;
			
			DMGame.singleton_.stage_.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			DMGame.singleton_.stage_.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			DMGame.singleton_.stage_.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
		}
		
		/**
		 * 安装操作实体
		 */
		public function setupEntity(entity:MapEntity):void
		{
			me_ = entity;
		}
		
		/**
		 * 鼠标响应驱动
		 */ 
		private function onClick(event:MouseEvent):void
		{
			// 检查是否点到某实体
			var entity:Entity;//perception.getClicker(e.stageX,e.stageY);
			if(entity != null) {
				clickEntity(entity);
				return;
			}
			
			// 计算鼠标落点，转换为世界坐标
			
			// 寻路得出路径
			
			// 测试摄像机移动
			if(me_) {
				me_.stateGroup_.moveTarget(new Point(event.stageX+DMGame.singleton_.camera_.mapPos.x, 
					event.stageY+DMGame.singleton_.camera_.mapPos.y));
				
//				me_.skill(0);
			}
			
			// 移动事件接出
			//onMove(me_.pos, new Point(event.stageX, event.stageY));
		}
		
		/**
		 * 键盘响应驱动
		 */ 
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 38:
					// W & UP
					if(yKey_ == 0) {
						yKey_ = -1;
						calcKeyMove();
					}
					break;
				case 37:
					// A & LEFT
					if(xKey_ == 0) {
						xKey_ = -1;
						calcKeyMove();
					}
					break;
				case 40:
					// S & DOWN
					if(yKey_ == 0) {
						yKey_ = 1;
						calcKeyMove();
					}
					break;
				case 39:
					// D & RIGHT
					if(xKey_ == 0) {
						xKey_ = 1;
						calcKeyMove();
					}
					break;
				case 32:
					// SPACE
					if(me_) {
						me_.stateGroup_.skill(["必杀1", "必杀2", "必杀3"], onTestSkill);
					}
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 38:
					// W & UP
					yKey_ = 0;
					calcKeyMove();
					break;
				case 37:
					// A & LEFT
					xKey_ = 0;
					calcKeyMove();
					break;
				case 40:
					// S & DOWN
					yKey_ = 0;
					calcKeyMove();
					break;
				case 39:
					// D & RIGHT
					xKey_ = 0;
					calcKeyMove();
					break;
			}
		}
		
		private function calcKeyMove():void
		{
			switch(xKey_)
			{
				case 1:
					if(yKey_==1)
					{
						if(me_) {
							me_.stateGroup_.moveDirection(EntityDirections.rightDown);
						}
					}else if(yKey_==-1){
						if(me_) {
							me_.stateGroup_.moveDirection(EntityDirections.rightUp);
						}
					}else{
						if(me_) {
							me_.stateGroup_.moveDirection(EntityDirections.right);
						}
					}
					break;
				case -1:
					if(yKey_==1)
					{
						if(me_) {
							me_.stateGroup_.moveDirection(EntityDirections.leftDown);
						}
					}else if(yKey_==-1){
						if(me_) {
							me_.stateGroup_.moveDirection(EntityDirections.leftUp);
						}
					}else{
						if(me_) {
							me_.stateGroup_.moveDirection(EntityDirections.left);
						}
					}
					break;
				case 0:
					if(yKey_==1)
					{
						if(me_) {
							me_.stateGroup_.moveDirection(EntityDirections.down);
						}
					}else if(yKey_==-1){
						if(me_) {
							me_.stateGroup_.moveDirection(EntityDirections.up);
						}
					}else{
						if(me_) {
							me_.stateGroup_.standBy();
						}
					}
					break;
			}
		}
		
		private function onTestSkill():void
		{
			trace('我打！');
		}
		
		/**
		 * 移动请求
		 */
		protected function onMove(startPos:Point, targetPos:Point):void
		{
			
		}
		
		private function clickEntity(entity:Entity):void
		{
			
		}
	}
}