package bc.world.enemy.actions 
{
	import bc.core.util.BcStringUtil;
	import bc.core.math.Vector2;
	import bc.world.bullet.BcBulletData;
	import bc.world.bullet.BcBulletLauncher;
	import bc.world.common.BcObject;
	import bc.world.core.BcWorld;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyBulletsAction implements BcIEnemyAction 
	{
		private static var DIRECTION:Vector2 = new Vector2();
		
		private static var DIRECTION_NONE:uint = 0;
		private static var DIRECTION_AIM:uint = 1;
		private static var DIRECTION_VELOCITY:uint = 2;
		
		private var n:uint = 1;
		private var min:Number = 0;
		private var max:Number = 0;
		private var a:Number = 0;
		private var w:Number = 0;
		private var f:Number = 0;
		
		private var bullet:BcBulletData;
		private var directionType:uint;
		
		public function BcEnemyBulletsAction(xml:XML)
		{
			const toRad:Number = Math.PI/180;
			if(xml.hasOwnProperty("@bullet")) bullet = BcBulletData.getData(xml.@bullet);
			if(xml.hasOwnProperty("@n")) n = BcStringUtil.parseUInteger(xml.@n);
			if(xml.hasOwnProperty("@min")) min = BcStringUtil.parseNumber(xml.@min)*toRad;
			if(xml.hasOwnProperty("@max")) max = BcStringUtil.parseNumber(xml.@max)*toRad;
			if(xml.hasOwnProperty("@a")) a = BcStringUtil.parseNumber(xml.@a)*toRad;
			if(xml.hasOwnProperty("@w")) w = BcStringUtil.parseNumber(xml.@w)*toRad;
			if(xml.hasOwnProperty("@f")) f = BcStringUtil.parseNumber(xml.@f)*toRad;
			
			if(xml.hasOwnProperty("@direction"))
			{
				var direction : String = xml.@direction.toString();
				if (direction == "none")
				{
					directionType = DIRECTION_NONE;
				}
				else if (direction == "aim")
				{
					directionType = DIRECTION_AIM;
				}
				else if (direction == "velocity")
				{
					directionType = DIRECTION_VELOCITY;
				}
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			var world:BcWorld = enemy.world;
			var mobPosition:Vector2 = enemy.position;
			var heroPosition:Vector2 = world.player.position;
			
			var i:uint;
			var da:Number = (max - min)/n;
			var angle:Number = min + a*Math.sin(w*enemy.time + f);
			
			switch(directionType)
			{
				case BcBulletLauncher.DIRECTION_AIM:
					DIRECTION.x = heroPosition.x - mobPosition.x;
					DIRECTION.y = heroPosition.y - mobPosition.y;
					DIRECTION.normalize();
					angle += Math.atan2(DIRECTION.y, DIRECTION.x);
					break;
				case BcBulletLauncher.DIRECTION_VELOCITY:
					DIRECTION.x = enemy.velocity.x;
					DIRECTION.y = enemy.velocity.y;
					DIRECTION.normalize();
					angle += Math.atan2(DIRECTION.y, DIRECTION.x);
					break;
			}
			
			
			
			for ( i = 0; i < n; ++i )
			{
				DIRECTION.x = Math.cos(angle);
				DIRECTION.y = Math.sin(angle);
				
				world.bullets.launch(bullet, mobPosition, DIRECTION, BcObject.MASK_PLAYER, enemy.data.mod);
				
				angle += da;
			}
		}

	}
}
