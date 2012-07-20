package com.dmgame.dmgame.object
{
	import com.dmgame.dmgame.entity.GameEntity;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 实体绘制对象
	 */
	public class EntityObject extends RenderObject
	{
		protected var entity_:GameEntity; // 实体
		
		/**
		 * 构造函数
		 */
		public function EntityObject()
		{
		}
		
		/**
		 * 实体设置
		 */
		public function set entity(value:GameEntity):void
		{
			entity_ = value;
		}
		
		/**
		 * 排序参考
		 */
		override public function get zOrder():int
		{
			return entity_.pos.y;
		}
		
		/**
		 * 绘制
		 */
		override public function render(screen:BitmapData, pos:Point):void
		{
			if(entity_) {
				entity_.render(screen, pos);
			}
		}
	}
}