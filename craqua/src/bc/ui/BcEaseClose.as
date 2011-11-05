package bc.ui
{
	import bc.core.motion.easing.BcEaseFunction;

	/**
	 * @author weee
	 */
	public class BcEaseClose implements BcEaseFunction
	{
		public function easing(t : Number) : Number
		{
			return t * t * t;
		}
	}
}
