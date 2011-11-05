package bc.core.motion.easing
{
	/**
	 * @author weee
	 */
	public class BcEaseStepOut implements BcEaseFunction
	{
		public function easing(t : Number) : Number
		{
			if (t < 1) return 1;
			return 0;
		}
	}
}
