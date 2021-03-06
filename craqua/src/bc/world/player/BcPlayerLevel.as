package bc.world.player 
{
	import bc.core.util.BcStringUtil;

	/**
	 * @author Elias Ku
	 */
	internal class BcPlayerLevel 
	{
		// Модификатор скорости стрельбы
		public var modRate:Number = 1;
		
		// Модификатор урона
		public var modDamage:Number = 1;
		
		// Время на восстановление одной жизни
		public var regenHealth:Number = 1;
		
		// Время на восстановление бомбы
		public var regenBomb:Number = 1;
		
		// уровень опыта до след уровня
		public var exp:uint;
		
		public var weapons:Vector.<BcPlayerWeapon> = new Vector.<BcPlayerWeapon>(3, true);
		public var bombs:Vector.<BcPlayerWeapon> = new Vector.<BcPlayerWeapon>();
		
		public function BcPlayerLevel()
		{
			
		}
		
		public function parse(xml:XML):void
		{
			var i:int;
			var weapon:BcPlayerWeapon;
			var node:XML;
			
			exp = BcStringUtil.parseUInteger(xml.@exp);
			
			node = xml.mod[0];
			if(node != null)
			{
				modRate = BcStringUtil.parseNumber(node.@rate);
				modDamage = BcStringUtil.parseNumber(node.@damage);
			}
			
			node = xml.regen[0];
			if(node != null)
			{
				regenHealth = BcStringUtil.parseNumber(node.@health);
				regenBomb = BcStringUtil.parseNumber(node.@bomb);
			}
			
			for each (node in xml.weapon)
			{
				weapon = new BcPlayerWeapon();
				weapon.parse(node);
				weapons[i] = weapon;
				i++;
			}
			
			for each (node in xml.bomb)
			{
				weapon = new BcPlayerWeapon();
				weapon.parse(node);
				bombs.push(weapon);
			}
		}
	}
}
