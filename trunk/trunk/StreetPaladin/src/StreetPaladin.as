package
{
	import com.dmgame.asset.AssetsLoader;
	import com.dmgame.entity.GameEntity;
	import com.dmgame.game.DMGame;
	import com.dmgame.map.GameMap;
	import com.dmgame.object.EntityObject;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class StreetPaladin extends DMGame
	{
		protected var assetsLoader:AssetsLoader = new AssetsLoader; // 必要资源加载器
		
		public function StreetPaladin(stage:Stage)
		{
			super(stage);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override protected function init(event:Event):void
		{
			super.init(event);
			
			// 加载资源
			assetsLoader.load(onLoadAssetsComplete);
		}
		
		public function onLoadAssetsComplete():void
		{
			// 初始化地图
			logic_.mapID = 1;
			
			// 放置一个玩家到地图中
			var entity:GameEntity = new GameEntity;
			entity.skinID = 1;
			entity.direction = 2;
			entity.pos.x = 200;
			entity.pos.y = 200;
			
			logic_.map.addEntity(entity);
			
			// 操纵人
			controller_.setupEntity(entity);
			
			// 摄像机看人
			camera_.setGameMap(logic_.map as GameMap);
			camera_.setViewSize(stage_.stageWidth, stage_.stageHeight);
			camera_.lookAtEntity(entity, false);
		}
	}
}