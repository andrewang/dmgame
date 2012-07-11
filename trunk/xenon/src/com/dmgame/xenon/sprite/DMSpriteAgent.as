package com.dmgame.xenon.sprite
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class DMSpriteAgent extends Sprite
	{
		private var defaultBitmapData_:BitmapData;
		private var bitmap_:Bitmap;
		private var sprite_:DMSprite;
		
		public function DMSpriteAgent( defaultBitmapData:BitmapData = null)
		{
			defaultBitmapData_ = defaultBitmapData;
			bitmap_ = new Bitmap(defaultBitmapData_);
			this.addChild(bitmap_);
		}

		public function get bitmap():Bitmap
		{
			return bitmap_;
		}
		
		public function setSprite( file:String, have_mirror:Boolean=false ):void{
			
			free();
			sprite_ = DMSpritePool.singleton_.createSprite(file, have_mirror);
		}

		public function render(line:uint, frame:uint, mirror:Boolean=false):Boolean{
			
			if(sprite_.loaded){
				return sprite_.fill2Agent(line, frame, this, mirror);
			}
			else{
				bitmap_.bitmapData = defaultBitmapData_;
				return false;
			}
		}
		
		public function free():void{
			if(sprite_){
				DMSpritePool.singleton_.freeSprite(sprite_.file)
			}
		}
	}
}