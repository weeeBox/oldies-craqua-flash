package bc.core.motion.easing
{
	/**
	 * @author weee
	 */
	public class BcEaseSineIn implements BcEaseFunction
	{
		public function easing(t : Number) : Number
		{
			return -Math.cos(t * (Math.PI * 0.5)) + 1;
		}
	}
}
