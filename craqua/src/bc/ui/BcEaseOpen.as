package bc.ui
{
	import bc.core.motion.easing.BcEaseFunction;
	/**
	 * @author weee
	 */
	public class BcEaseOpen implements BcEaseFunction
	{
		public function easing(t : Number) : Number
		{
			var x : Number = 1 - t;
			return 1 - x * x * x;
		}
	}
}
