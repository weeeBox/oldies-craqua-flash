package bc.core.motion.easing
{
	import bc.core.motion.easing.BcEaseFunction;

	/**
	 * @author weee
	 */
	public class BcEaseSineOut implements BcEaseFunction
	{
		public function easing(t : Number) : Number
		{
			return Math.sin(t * (Math.PI * 0.5));
		}
	}
}
