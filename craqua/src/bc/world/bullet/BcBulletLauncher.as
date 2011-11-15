package bc.world.bullet 
{
	import bc.core.util.BcStringUtil;
	import bc.core.math.Vector2;
	import bc.game.BcGameGlobal;

	/**
	 * @author Elias Ku
	 */
	public class BcBulletLauncher 
	{
		public static var DIRECTION_NONE:uint = 0;
		public static var DIRECTION_AIM:uint = 1;
		public static var DIRECTION_VELOCITY:uint = 2;
		
		private var n:uint = 1;
		private var min:Number = 0;
		private var max:Number = 0;
		private var a:Number = 0;
		private var w:Number = 0;
		private var f:Number = 0;
		
		private var bullet:BcBulletData;
		public var directionType:uint;
		
		private static var DIRECTION:Vector2 = new Vector2();
		
		public function BcBulletLauncher(xml:XML)
		{
			const toRad:Number = Math.PI/180;
			if(xml.hasOwnProperty("@bullet")) bullet = BcBulletData.getData(xml.@bullet.toString());
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
		
		public function launch(position:Vector2, direction:Vector2, mask:uint, mod:Number, t:Number = 0):void
		{
			var i:uint;
			var da:Number = (max - min)/n;
			var angle:Number = Math.atan2(direction.y, direction.x) + min + a*Math.sin(w*t + f);
			
			for ( i = 0; i < n; ++i )
			{
				DIRECTION.x = Math.cos(angle);
				DIRECTION.y = Math.sin(angle);
				
				BcGameGlobal.world.bullets.launch(bullet, position, DIRECTION, mask, mod);
				
				angle += da;
			}
		}
	}
}


