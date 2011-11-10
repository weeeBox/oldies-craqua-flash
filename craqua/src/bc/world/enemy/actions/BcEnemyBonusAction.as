package bc.world.enemy.actions 
{
	import bc.core.util.BcStringUtil;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyBonusAction implements BcIEnemyAction 
	{
		private var money:int = 1;
		private var gems:int = 1;
		private var prob:Number = 1;

		
		public function BcEnemyBonusAction(xml:XML)
		{
			if(xml.hasOwnProperty("@money"))
			{
				money = BcStringUtil.parseInteger(xml.@money);
			}
			if(xml.hasOwnProperty("@gems"))
			{
				gems = BcStringUtil.parseInteger(xml.@gems);
			}
			if(xml.hasOwnProperty("@prob"))
			{
				prob = BcStringUtil.parseNumber(xml.@prob);
			}
		}
		
		public function action(enemy:BcEnemy):void
		{
			enemy.world.items.launchEnemyBonus(enemy.position, gems, money, prob, enemy.sprite);
		}
	}
}
