package com.dmgame.xenon.sprite
{
	/**
	 * 精灵资源，拥有引用计数
	 */
	public class DMSpriteReference
	{
		public var ref_:int; // 引用计数
		
		public var sprite_:DMSprite; // 精灵
		
		public function DMSpriteReference(file:String, have_mirror:Boolean=false)
		{
			sprite_ = new DMSprite(file, have_mirror);
		}
		
		public function destroy():void
		{
			sprite_.destroy();
		}
	}
}