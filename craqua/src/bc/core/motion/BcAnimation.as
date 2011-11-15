package bc.core.motion 
{
	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcAnimation 
	{
		public var data:BcAnimationData;
		public var motions:Vector.<BcMotion> = new Vector.<BcMotion>();
		public var target:DisplayObject;
		
		public function BcAnimation(target:DisplayObject = null, data:BcAnimationData = null)
		{
			if(target != null)
			{
				setTarget(target);
			}
			
			if(data != null)
			{
				setData(data);
			}
		}
		
		public function setTarget(target:DisplayObject):void
		{
			this.target = target;
			for each (var motion:BcMotion in motions)
			{
				motion.setTarget(target);
			}
		}
		
		public function setData(data:BcAnimationData):void
		{
			this.data = data;
			motions.length = 0;
			
			if(data != null)
			{	
				for each (var motionData:BcMotionData in data.motions)
				{
					motions.push(new BcMotion(target, motionData));
				}
			}
		}
		
		public function playMotion(id:String):void
		{
			var motionData:BcMotionData = data.lookup[id];
			
			if(motionData != null)
			{
				for each (var motion:BcMotion in motions)
				{
					if(motion.data == motionData)
					{
						motion.play();
					}
				}
			}
		}
		
		public function stopMotion(id:String):void
		{
			var motionData:BcMotionData = data.lookup[id];
			
			if(motionData != null)
			{
				for each (var motion:BcMotion in motions)
				{
					if(motion.data == motionData)
					{
						motion.stop();
					}
				}
			}
		}
		
		public function getMotion(id:String):BcMotion
		{
			var motionData:BcMotionData = data.lookup[id];
			var found:BcMotion;
			
			if(motionData != null)
			{
				for each (var motion:BcMotion in motions)
				{
					if(motion.data == motionData)
					{
						found = motion;
						break;
					}
				}
			}
			
			return found;
		}
		
		public function update(dt:Number):void
		{
			for each (var motion:BcMotion in motions)
			{
				motion.update(dt);
			}
		}
	}
}
