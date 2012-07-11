package com.dmgame.xenon.sprite
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class DMSpriteAgent extends Sprite
	{
		private var defaultBitmapData_:BitmapData;
		private var _bitmap_:Bitmap;
		private var _sprite_:DMSprite;
		
		public function DMSpriteAgent( defaultBitmapData:BitmapData = null)
		{
			defaultBitmapData_ = defaultBitmapData;
			_bitmap_ = new Bitmap(defaultBitmapData_);
			this.addChild(bitmap_);
		}

		public function get bitmap_():Bitmap
		{
			return _bitmap_;
		}

		public function set sprite_(value:DMSprite):void
		{
			_sprite_ = value;
		}

		public function render(line:uint, frame:uint, mirror:Boolean=false):Boolean{
			
			return _sprite_.fill2Bitmap(line, frame, this, mirror);
		}
		
		public function free():void{
			if(_sprite_)
				DMSpritePool.singleton_.freeSprite(_sprite_.file)
		}
	}
}