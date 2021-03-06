package bc.core.motion 
{
	import bc.core.util.BcStringUtil;

	/**
	 * @author Elias Ku
	 */
	public class BcMotionWeight 
	{
		public var time:Number = 0;
		public var value:Number = 1;
		
		public function BcMotionWeight(time:Number = 0, value:Number = 1)
		{
			this.time = time;
			this.value = value;
		}

		public function parse(xml:XML):void
		{
			if(xml.hasOwnProperty("@time"))
			{
				time = BcStringUtil.parseNumber(xml.@time);
			}
			
			if(xml.hasOwnProperty("@value"))
			{
				value = BcStringUtil.parseNumber(xml.@value);
			}
		}
	}
}
