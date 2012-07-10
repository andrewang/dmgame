package com.dmgame.sprite
{
	/**
	 * 精灵池
	 */
	public class DMSpritePool
	{
		public var sprites_:Array = []; // 精灵表
		
		static public var singleton_:DMSpritePool; // 单件
		
		public function DMSpritePool()
		{
			singleton_ = this;
		}
		
		/**
		 * 获取精灵
		 */
		public function createSprite(file:String, mirror:Boolean=false):DMSprite
		{
			var spriteResource:DMSpriteResource = sprites_[file];
			
			if(spriteResource == null) {
				
				spriteResource = new DMSpriteResource(file, mirror);
				sprites_[file] = spriteResource;
			}
			++spriteResource.ref_;
			return spriteResource.sprite_;
		}
		
		/**
		 * 释放精灵
		 */
		public function freeSprite(file:String):void
		{
			var spriteResource:DMSpriteResource = sprites_[file];
			
			if(spriteResource != null && spriteResource.ref_ > 0) {
				
				--spriteResource.ref_;
				if(spriteResource.ref_ == 0) {
					
					// 放入垃圾回收列表，当前先不做回收
				}
			}
		}
		
		/**
		 * 清理垃圾
		 */
		protected function gcSprite(file:String):void
		{
			var spriteResource:DMSpriteResource = sprites_[file];
			spriteResource.destroy();
			
			delete sprites_[file];
		}
	}
}