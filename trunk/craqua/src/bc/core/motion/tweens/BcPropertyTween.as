package bc.core.motion.tweens 
{
	import bc.core.util.BcStringUtil;
	import bc.core.motion.tweens.BcITween;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcPropertyTween implements BcITween 
	{
		public var property:String;
		public var start:Number = 0;
		public var change:Number = 0;
		
		public function BcPropertyTween(property:String = null, start:Number = 0, change:Number = 0)
		{
			this.property = property;
			this.start = start;
			this.change = change;
		}
		
		public function parse(xml:XML):void
		{
			property = xml.@property.toString();
			start = BcStringUtil.parseNumber(xml.@start);
			change = BcStringUtil.parseNumber(xml.@change);
		}

		public function apply(progress:Number, displayObject:DisplayObject = null, weight:Number = 1):void
		{
			if(displayObject)
			{
				const value:Number = start + change * progress;
				
				if(weight >= 1)
				{
					displayObject[property] = value;
				}
				else
				{
					const invWeight:Number = 1 - weight;
					displayObject[property] = displayObject[property]*invWeight + value*weight;
				}
			}
		}
	}
}
