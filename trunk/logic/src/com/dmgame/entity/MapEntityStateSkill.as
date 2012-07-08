package com.dmgame.entity
{
	public class MapEntityStateSkill extends MapEntityState
	{
		protected var actionQueue_:Array = []; // 动作序列
		
		protected var skillCallback_:Function; // 技能生效回调
		
		protected var actionEnd_:Boolean = false; // 动作是否结束
		
		protected var actionIndex_:int; // 动作编号
		
		protected var stateMoveDirection_:MapEntityStateMoveDirection; // 方向移动子状态机
		
		public function MapEntityStateSkill(mapEntity:MapEntity)
		{
			super(mapEntity);
			
			stateMoveDirection_ = new MapEntityStateMoveDirection(mapEntity);
			stateMoveDirection_.moveSpeed_ = 100;
		}
		
		/**
		 * 名称
		 */
		public static function get name():String
		{
			return 'skill';
		}
		
		/**
		 * 初始化
		 */
		public function init(actionQueue:Array, skillCallback:Function):Boolean
		{
			actionQueue_ = actionQueue.concat();
			skillCallback_ = skillCallback;
			return true;
		}
		
		/**
		 * 进入
		 */
		override public function enter():void
		{
			actionEnd_ = false;
			
			actionIndex_ = 0;
			mapEntity_.setAction(actionQueue_[actionIndex_], false, nextAction, skillCallback_);
			
			stateMoveDirection_.init(mapEntity_.direction);
			stateMoveDirection_.enter();
		}
		
		/**
		 * 离开
		 */
		override public function leave():void
		{
			stateMoveDirection_.leave();
		}
		
		/**
		 * 更新
		 */
		override public function update():Boolean
		{
			stateMoveDirection_.update();
			return actionEnd_;
		}
		
		/**
		 * 下一个招式
		 */
		protected function nextAction():void
		{
			++actionIndex_;
			if(actionIndex_ >= actionQueue_.length) {
				actionEnd_ = true;
			}
			else {
				mapEntity_.setAction(actionQueue_[actionIndex_], false, nextAction, skillCallback_);
			}
		}
	}
}