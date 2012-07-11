package com.dmgame.xenon.sprite
{
	/**
	 * 动作对象，根据时间更新帧，支持帧事件
	 */
	public class DMAction
	{
		private var frameTime_:Array = null;
		
		private var frameCount_:uint = 0;
		
		private var isLoop_:Boolean = false;
		
		private var lastTime_:int = 0;
		
		private var currentFrame_:uint = 0;
		
		private var frameEvent_:Array = [];
		
		private var isInited_:Boolean = false;
		
		public function DMAction()
		{
		}
		
		/**
		 * 初始化
		 */
		public function init(frameTime:Array, isLoop:Boolean, currentTime:int):void
		{
			if(isInited_) {
				return;
			}
			isInited_ = true;
			
			frameTime_ = frameTime;
			frameCount_ = frameTime_.length;
			isLoop_ = isLoop;
			lastTime_ = currentTime;
		}
		
		/**
		 * 注册帧事件
		 */
		public function registerFrameEvent(frame:uint, event:Function):Boolean
		{
			if(frame >= frameCount_) {
				return false;
			}
			if(!frameEvent_[frame]) {
				frameEvent_[frame] = new Array;
			}
			frameEvent_[frame].push(event);
			return true;
		}
		
		/**
		 * 更新动作
		 */
		public function update(currentTime:int):Boolean
		{
			// 帧已经到底，且没有循环
			if(currentFrame_ >= frameCount_) {
				return true;
			}
			
			// 刷新帧
			var time:int = currentTime - lastTime_;
			while(time >= frameTime_[currentFrame_])
			{
				time -= frameTime_[currentFrame_];
				lastTime_ += frameTime_[currentFrame_];
				
				++currentFrame_;
				
				if(currentFrame_ >= frameCount_) {
					
					// 循环则从第一帧开始
					if(isLoop_) {
						currentFrame_ = 0;
					}
					else {
						return true;
					}
				}
				else {
					
					// 执行帧事件
					if(frameEvent_[currentFrame_]) {
						
						var eventCount:uint = (frameEvent_[currentFrame_] as Array).length;
						for(var i:int=0; i<eventCount; ++i)
						{
							(frameEvent_[currentFrame_][i] as Function)();
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * 获取当前帧
		 */
		public function get currentFrame():uint
		{
			return currentFrame_;
		}
	}
}