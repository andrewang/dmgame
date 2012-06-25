package com.dmgame.dmsprite
{
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class DMSpriteInfo
	{
		private var width_:uint = 0; // 宽度
		
		private var height_:uint = 0; // 高度
		
		private var line_:uint = 0; // 行数
		
		private var frame_:uint = 0; // 列数
		
		private var centerPos_:Point = new Point(0, 0); // 中心点偏移
		
		private var frameWidth_:uint = 0; // 帧宽度
		
		private var frameHeight_:uint = 0; // 帧高度
		
		public function DMSpriteInfo()
		{
		}
		
		public function initSize(width:uint, height:uint, line:uint, frame:uint):void
		{
			width_ = width;
			height_ = height;
			line_ = line;
			frame_ = frame;

			frameWidth_ = width_ / frame_;
			frameHeight_ = height_ / line_;
		}
		
		public function parseFromBytes(bytes:ByteArray):void
		{
			width_ = bytes.readUnsignedInt();
			height_ = bytes.readUnsignedInt();
			line_ = bytes.readUnsignedInt();
			frame_ = bytes.readUnsignedInt();
			centerPos_.x = bytes.readUnsignedInt();
			centerPos_.y = bytes.readUnsignedInt();
			
			frameWidth_ = width_ / frame_;
			frameHeight_ = height_ / line_;
		}
		
		public function serializeToBytes(bytes:ByteArray):void
		{
			bytes.writeUnsignedInt(width_);
			bytes.writeUnsignedInt(height_);
			bytes.writeUnsignedInt(line_);
			bytes.writeUnsignedInt(frame_);
			bytes.writeUnsignedInt(centerPos_.x as uint);
			bytes.writeUnsignedInt(centerPos_.y as uint);
		}
		
		public function get width():uint
		{
			return width_;
		}
		
		public function get height():uint
		{
			return height_;
		}
		
		public function get line():uint
		{
			return line_;
		}
		
		public function get frame():uint
		{
			return frame_;
		}
		
		public function get centerPos():Point
		{
			return centerPos_;
		}
		
		public function set centerPos(value:Point):void
		{
			centerPos_ = value;
		}
		
		public function get frameWidth():uint
		{
			return frameWidth_;
		}
		
		public function get frameHeight():uint
		{
			return frameHeight_;
		}
	}
}