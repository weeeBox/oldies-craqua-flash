package bc.core.motion.easing
{
	/**
	 * @author weee
	 */
	public class BcEaseStepIn implements BcEaseFunction
	{
		public function easing(t : Number) : Number
		{
			if (t < 1) return 0;
			return 1;
		}
	}
}
