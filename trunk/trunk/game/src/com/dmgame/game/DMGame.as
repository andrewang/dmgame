package com.dmgame.game
{
	import com.dmgame.asset.Assets;
	import com.dmgame.controller.EntityController;
	import com.dmgame.logic.Logic;
	import com.dmgame.map.GameMap;
	import com.dmgame.map.Map;
	import com.dmgame.sprite.DMSpritePool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * 游戏世界框架
	 */
	public class DMGame extends Sprite
	{
		public var stage_:Stage; // AS游戏场景
		
		protected var screenBitmapData_:BitmapData; // 主画布
		
		public var camera_:DMCamera = new DMCamera; // 游戏场景摄像机
		
		protected var controller_:EntityController; // 实体控制器，负责场景内点击或者键盘操作
		
		public var logic_:Logic = new Logic(createGameMap); // 游戏主逻辑
		
		public var spritePool_:DMSpritePool = new DMSpritePool; // 游戏精灵池
		
		public static var currentTime:int; // 当前游戏时间
		
		public static var singleton_:DMGame; // 单件
		
		/**
		 * 构造函数
		 */
		public function DMGame(stage:Stage)
		{
			super();
			
			singleton_ = this;
			stage_ = stage;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 初始化世界
		 */
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			setupScreen();
			
			// init
			controller_ = new EntityController;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 安装主画布
		 */
		protected function setupScreen():void
		{
			screenBitmapData_ = new BitmapData(stage.stageWidth, stage.stageHeight);
			var screenBitmap:Bitmap = new Bitmap(screenBitmapData_);
			addChild(screenBitmap);
		}
		
		/**
		 * 更新与绘制
		 */
		protected function onEnterFrame(e:Event):void
		{
			currentTime = getTimer();
			
			update();
			render();
		}
		
		/**
		 * 更新
		 */
		protected function update():void
		{
			// 逻辑更新
			logic_.update(currentTime);
			
			// 摄像机更新位置
			camera_.update();
		}
		
		/**
		 * 绘制
		 */
		protected function render():void
		{
			// 清理屏幕
			screenBitmapData_.fillRect(new Rectangle(0,0,screenBitmapData_.width,screenBitmapData_.height), 0xFF000000); 
			
			// 开始绘制
			var gameMap:GameMap = (logic_.map as GameMap);
			if(gameMap) {
				if(camera_.currentPos != null) {
					gameMap.render(screenBitmapData_, new Point(camera_.currentPos.x-stage_.stageWidth/2, camera_.currentPos.y-stage_.stageHeight/2));
				}
			}
		}
		
		/**
		 * 地图工厂函数
		 */
		static private function createGameMap():Map
		{
			return new GameMap;
		}
	}
}