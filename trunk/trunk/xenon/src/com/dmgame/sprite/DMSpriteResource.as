package com.dmgame.sprite
{
	/**
	 * 精灵资源，拥有引用计数
	 */
	public class DMSpriteResource
	{
		public var ref_:int; // 引用计数
		
		public var sprite_:DMSprite; // 精灵
		
		public function DMSpriteResource(file:String, mirror:Boolean=false)
		{
			sprite_ = new DMSprite(file, mirror);
		}
		
		public function destroy():void
		{
			sprite_.destroy();
		}
	}
}