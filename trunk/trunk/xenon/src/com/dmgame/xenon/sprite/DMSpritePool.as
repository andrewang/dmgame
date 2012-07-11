package com.dmgame.xenon.sprite
{
	import flash.utils.Dictionary;

	/**
	 * 精灵池
	 */
	public class DMSpritePool
	{
		public var spriteReferences_:Dictionary = new Dictionary; // 精灵表
		
		public var gcSpriteQuene_:Array = [];
		
		static public var singleton_:DMSpritePool; // 单件
		
		public function DMSpritePool()
		{
			singleton_ = this;
		}
		
		/**
		 * 获取精灵
		 */
		public function createSprite(file:String, have_mirror:Boolean=false):DMSprite
		{
			var spriteReference:DMSpriteReference = spriteReferences_[file];
			
			if(spriteReference == null) {
				
				spriteReference = new DMSpriteReference(file, have_mirror);
				spriteReferences_[file] = spriteReference;
			}
			++spriteReference.ref_;
			
			// 从垃圾列表中移除
			var index:int = gcSpriteQuene_.indexOf(spriteReference);
			if(index != -1){
				gcSpriteQuene_.splice(index, 1);
			}
			
			return spriteReference.sprite_;
		}
		
		/**
		 * 释放精灵
		 */
		public function freeSprite(file:String):void
		{
			var spriteReference:DMSpriteReference = spriteReferences_[file];
			
			if(spriteReference != null && spriteReference.ref_ > 0) {
				
				--spriteReference.ref_;
				if(spriteReference.ref_ == 0) {
					
					// 放入垃圾回收列表，当前先不做回收
					gcSpriteQuene_.push(spriteReference);
					if(gcSpriteQuene_.length > 20){
						spriteReference = gcSpriteQuene_[0];
						gcSpriteQuene_.shift();
						gcSprite(spriteReference.sprite_.file);
					}
				}
			}
		}
		
		/**
		 * 清理垃圾
		 */
		protected function gcSprite(file:String):void
		{
			var spriteReference:DMSpriteReference = spriteReferences_[file];
			spriteReference.destroy();
			delete spriteReferences_[file];
		}
	}
}