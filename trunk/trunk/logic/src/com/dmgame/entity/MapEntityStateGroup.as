package com.dmgame.entity
{
	import flash.geom.Point;

	public class MapEntityStateGroup
	{
		protected var mapEntity_:MapEntity; // 状态机拥有者实体
		
		protected var stateCurrent_:MapEntityState; // 当前动作相关状态机
		
		protected var stateDefault_:MapEntityState; // 默认状态机
		
		public var stateStandBy_:MapEntityStateStandBy; // 站立状态机
		
		public var stateMoveTarget_:MapEntityStateMoveTarget; // 移动状态机
		
		public var stateMoveDirection_:MapEntityStateMoveDirection; // 移动状态机
		
		public var stateSkill_:MapEntityStateSkill; // 技能状态机
		
		public function MapEntityStateGroup(mapEntity:MapEntity)
		{
			mapEntity_ = mapEntity;
			
			stateStandBy_ = new MapEntityStateStandBy(mapEntity); // 站立状态机
			stateMoveTarget_ = new MapEntityStateMoveTarget(mapEntity); // 移动状态机
			stateMoveDirection_ = new MapEntityStateMoveDirection(mapEntity); // 移动状态机
			stateSkill_ = new MapEntityStateSkill(mapEntity); // 技能状态机
			
			stateCurrent_ = stateStandBy_;
			stateDefault_ = stateCurrent_;
		}
		
		/**
		 * 切换坐标相关状态机
		 */
		protected function changeState(state:MapEntityState):void
		{
			if(stateCurrent_ != null) {
				stateCurrent_.leave();
			}
			if(state != null) {
				state.enter();
			}
			stateCurrent_ = state;
		}
		
		/**
		 * 更新状态机
		 */
		public function update():void
		{
			if(stateCurrent_ != null) {
				
				if(stateCurrent_.update()) {
					changeState(stateDefault_);
				}
			}
		}
		
		/**
		 * 申请站立
		 */
		public function standBy():void
		{
			// 进入站立状态机
			changeState(stateStandBy_);
		}
		
		/**
		 * 移动到指定目标
		 */
		public function moveTarget(targetPos:Point):void
		{
			// 初始化移动状态机
			stateMoveTarget_.init(targetPos);
			
			// 进入移动状态机
			changeState(stateMoveTarget_);
			
			// 开始奔跑
			mapEntity_.setAction('移动', true);
		}
		
		/**
		 * 移动方向
		 */
		public function moveDirection(direction:int):void
		{
			// 初始化移动状态机
			stateMoveDirection_.init(direction);
			
			// 进入移动状态机
			changeState(stateMoveDirection_);
			
			// 开始奔跑
			mapEntity_.setAction('移动', true);
		}
		
		/**
		 * 申请攻击，攻击可以是一套动作，并且是action跑完再接下一个，攻击可以注册回调事件
		 */
		public function skill(actionQueue:Array, skillCallback:Function):void
		{
			// 初始化技能状态机
			if(!stateSkill_.init(actionQueue, skillCallback)) {
				return;
			}
			
			// 进入站立状态机
			changeState(stateSkill_);
		}
	}
}