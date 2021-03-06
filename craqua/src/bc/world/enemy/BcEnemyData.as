package bc.world.enemy 
{
	import bc.core.util.BcStringUtil;
	import bc.core.audio.BcSound;
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.display.BcBitmapData;
	import bc.core.display.BcModelData;
	import bc.core.motion.BcAnimationData;
	import bc.world.collision.BcShape;
	import bc.world.enemy.actions.BcEnemyBitmapAction;
	import bc.world.enemy.actions.BcEnemyBonusAction;
	import bc.world.enemy.actions.BcEnemyBulletsAction;
	import bc.world.enemy.actions.BcEnemyCreateAction;
	import bc.world.enemy.actions.BcEnemyExplosionAction;
	import bc.world.enemy.actions.BcEnemyMotionAction;
	import bc.world.enemy.actions.BcEnemyParticlesExp;
	import bc.world.enemy.actions.BcEnemyPathAction;
	import bc.world.enemy.actions.BcEnemyPositionAction;
	import bc.world.enemy.actions.BcEnemySoundAction;
	import bc.world.enemy.actions.BcEnemyTimerAction;
	import bc.world.enemy.actions.BcEnemyWorldAction;
	import bc.world.enemy.actions.BcIEnemyAction;
	import bc.world.enemy.timers.BcEnemyBaseTimer;
	import bc.world.enemy.timers.BcEnemyTimeline;
	import bc.world.enemy.timers.BcEnemyTimer;
	import bc.world.enemy.timers.BcIEnemyTimer;
	import bc.world.enemy.triggers.BcIEnemyTrigger;
	import bc.world.particles.BcParticleData;

	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyData implements BcIObjectData
	{
		public var shape:BcShape;
		
		// Масса, влияет на уровень отброса от пули или взрыва
		public var mass:Number = 0;
		
		public var health:Number = 1;
		
		// Урон игроку за пропуск монстра за линию обороны
		public var fail:uint = 10;
		
		// урон игроку за прикосновение
		public var touch:uint = 2;
		
		// Модификатор урона на взрывы и пули
		public var mod:Number = 1;
		
		// Сколько денег и опыта впадает из убитого монстра
		public var gems:uint = 1;
		public var money:uint = 1;
		
		// Вероятность выпадения денег и опыта
		public var bonusProb:Number = 0.5;
		
		// Разрем /2 по вертикали
		public var size:Number = 16;
		
		public var movingMin:Number = 0;
		public var movingMax:Number = 1;
		public var movingOffset:Number = 0;
		public var movingTime:Number = 1;
		public var movingType:uint = 0;
		
		public var movingRotation:Number = -0.25;
		public var movingRotationMax:Number = 30;	
		
		// Это обычно значит, что монстр - босс :)
		public var boss:Boolean;
		
		public var triggers:Vector.<BcIEnemyTrigger> = new Vector.<BcIEnemyTrigger>();
		public var timers:Vector.<BcIEnemyTimer> = new Vector.<BcIEnemyTimer>();
		
		public var initActions:Vector.<BcIEnemyAction>;
		
		public var hitParticle:BcParticleData;
		public var hitCaps:Vector.<BcEnemyHitCap>;
		public var hitLight:Number = 1;
		public var hitBonus:uint;
		public var hitBonusActions:Vector.<BcIEnemyAction>;
		
		public var deathActions:Vector.<BcIEnemyAction>;
		public var deathSound:BcSound;
		
		public var bitmapBody:BcBitmapData;
		
		public var modelData:BcModelData;
		public var animationData:BcAnimationData;
		
		public var trailParticle:BcParticleData;
		public var trailSpeed:Number = 1;
		public var trailSpread:Number = 0.25;
		
		public var launchPause:Number = 0;
		public var launchMarker:BcParticleData;
		public var launchSpeed:Number = 0;
		
		public function BcEnemyData()
		{
			
		}
		
		public function parse(xml:XML):void
		{			
			var node:XML;
			var subNode:XML;
				
			node = xml.moving[0];
			if(node != null)
			{
				if(node.hasOwnProperty("@min")) movingMin = BcStringUtil.parseNumber(node.@min);
				if(node.hasOwnProperty("@max")) movingMax = BcStringUtil.parseNumber(node.@max);
				if(node.hasOwnProperty("@time")) movingTime = BcStringUtil.parseNumber(node.@time);
				if(node.hasOwnProperty("@offset")) movingOffset = BcStringUtil.parseNumber(node.@offset);
				if(node.hasOwnProperty("@type"))
				{
					var nodeType : String = node.@type.toString();
					if (nodeType == "normal") 
					{
						movingType = 0;
					}
					else if (nodeType == "saw") 
					{
						movingType = 1;
					}
				}
			}
			
			node = xml.properties[0];
			if(node != null)
			{
				if(node.hasOwnProperty("@health")) health = BcStringUtil.parseNumber(node.@health);
				if(node.hasOwnProperty("@fail")) fail = BcStringUtil.parseNumber(node.@fail);
				if(node.hasOwnProperty("@mod")) mod = BcStringUtil.parseNumber(node.@mod);
				if(node.hasOwnProperty("@size")) size = BcStringUtil.parseNumber(node.@size);
				if(node.hasOwnProperty("@mass")) mass = BcStringUtil.parseNumber(node.@mass);
				if(node.hasOwnProperty("@gems")) gems = BcStringUtil.parseUInteger(node.@gems);
				if(node.hasOwnProperty("@money")) money = BcStringUtil.parseUInteger(node.@money);
			}
			
			node = xml.trail[0];
			if(node != null)
			{
				if(node.hasOwnProperty("@particle"))
				{
					trailParticle = BcParticleData.getData(node.@particle);
				}
				if(node.hasOwnProperty("@speed"))
				{
					trailSpeed = BcStringUtil.parseNumber(node.@speed);
				}
				if(node.hasOwnProperty("@spread"))
				{
					trailSpread = BcStringUtil.parseNumber(node.@spread);
				}
			}
			
			for each (node in xml.timer)
			{
				timers.push(createTimer(node));
			}
			
			for each (node in xml.trigger)
			{
				triggers.push(createTrigger(node));
			}
			
			node = xml.hit[0];
			if(node != null)
			{
				if(node.hasOwnProperty("@particle"))
				{
					hitParticle = BcParticleData.getData(node.@particle);
				}
				
				if(node.hasOwnProperty("@light"))
				{
					hitLight = BcStringUtil.parseNumber(node.@light);
				}
				
				
				for each (subNode in node.cap)
				{
					if(hitCaps == null) hitCaps = new Vector.<BcEnemyHitCap>();
					hitCaps.push(new BcEnemyHitCap(subNode));
				}
				
				subNode = node.bonus[0];
				if(subNode != null)
				{
					hitBonus = BcStringUtil.parseUInteger(subNode.@damage);
					hitBonusActions = createActionArray(subNode);
				}
			}
			
			node = xml.death[0];
			if(node != null)
			{
				deathActions = createActionArray(node);
				
				if(node.hasOwnProperty("@sfx"))
				{
					deathSound = BcSound.getData(node.@sfx);
				}
			}
			
			node = xml.init[0];
			if(node != null)
			{
				initActions = createActionArray(node);
			}
			
			shape = BcShape.createFromXML(xml.shape[0]);
				
			node = xml.sprite[0];
			if(node != null)
			{
				if(node.hasOwnProperty("@animation"))
				{
					animationData = BcAnimationData.getData(node.@animation);
				}
				if(node.hasOwnProperty("@model"))
				{
					modelData = BcModelData.getData(node.@model);
				}
			}
			
			
			if(xml.boss[0] != null)
			{
				boss = true;
				bonusProb = 1;
			}
			
			node = xml.launch[0];
			if(node != null)
			{
				launchPause = BcStringUtil.parseNumber(node.@pause);
				launchSpeed = BcStringUtil.parseNumber(node.@speed);
				launchMarker = BcParticleData.getData(node.@marker);
			}
		}
		
		public function getMoving(time:Number):Number
		{
			var moving:Number = movingMin;
			
			time -= movingOffset;
			if(time > 0)
			{
				switch(movingType)
				{
					case 0:
						if(time > movingTime)
						{
							moving = movingMax;
						}
						else
						{
							moving = movingMin + (movingMax - movingMin)*time/movingTime;
						}
						break;
					case 1:
						time -= uint(time/movingTime)*movingTime;
						moving = movingMax - (movingMax - movingMin)*time/movingTime;
						break;
				}
			}
			
			return moving;
		}
		
		public function cloneTimers(enemy:BcEnemy):void
		{
			var array:Vector.<BcIEnemyTimer>;
			var timer:BcIEnemyTimer;
			var clone:BcIEnemyTimer;
			
			if(timers != null)
			{
				for each (timer in timers)
				{
					clone = null;
					
					if(timer is BcEnemyTimer)
					{
						clone = new BcEnemyTimer(BcEnemyTimer(timer));
						
					}
					else if (timer is BcEnemyTimeline)
					{
						clone = new BcEnemyTimeline(BcEnemyTimeline(timer));
					}
					
					if(clone != null)
					{
						if(array == null)
						{
							array = new Vector.<BcIEnemyTimer>();
						}
						
						array.push(clone);
						BcEnemyBaseTimer(clone).enemy = enemy;
					}
				}
			}
			
			enemy.timers = array;
		}

		///////////////
		
		public static function createAction(xml:XML):BcIEnemyAction
		{
			var action:BcIEnemyAction;
			var type:String = xml.name().toString();
			
			if (type == "bullets") {
				action = new BcEnemyBulletsAction(xml);
			}
			else if (type == "motion") {
				action = new BcEnemyMotionAction(xml);
			}
			else if (type == "circle_particles") {
				action = new BcEnemyParticlesExp(xml);
			}
			else if (type == "position") {
				action = new BcEnemyPositionAction(xml);
			}
			else if (type == "path") {
				action = new BcEnemyPathAction(xml);
			}
			else if (type == "world") {
				action = new BcEnemyWorldAction(xml);
			}
			else if (type == "bitmap") {
				action = new BcEnemyBitmapAction(xml);
			}
			else if (type == "sfx") {
				action = new BcEnemySoundAction(xml);
			}
			else if (type == "explosion") {
				action = new BcEnemyExplosionAction(xml);
			}
			else if (type == "timer") {
				action = new BcEnemyTimerAction(xml);
			}
			else if (type == "bonus") {
				action = new BcEnemyBonusAction(xml);
			}
			else if (type == "create") {
				action = new BcEnemyCreateAction(xml);
			}
			
			return action;
			
		}
		
		public static function createActionArray(xml:XML):Vector.<BcIEnemyAction>
		{
			var actions:Vector.<BcIEnemyAction>;
			var list:XMLList = xml.children();
			var node:XML;
			
			for each (node in list)
			{
				if(actions == null)
				{
					actions = new Vector.<BcIEnemyAction>();
				}
				
				actions.push(createAction(node));
			}
			
			return actions;
		}
		
		private static function createTrigger(xml:XML):BcIEnemyTrigger
		{
			var trigger:BcIEnemyTrigger;
			var type:String = xml.@type;
			
			return trigger;
		}
		
		private static function createTimer(xml:XML):BcIEnemyTimer
		{
			var timer:BcIEnemyTimer;
			var type:String;
			
			if(xml.hasOwnProperty("@type"))
			{
				type = xml.@type;
			}
			
			if(type == null || type=="timer")
			{
				timer = new BcEnemyTimer();
			}
			else if(type=="timeline")
			{
				timer = new BcEnemyTimeline();
			}
			
			timer.parse(xml);
			
			return timer;
		}
		
		//////////////
		private static var data:Dictionary = new Dictionary();
		
		public static function register():void
		{		
			BcData.register("enemy", new BcEnemyDataCreator(), data);
		}
		
		public static function getData(id:String):BcEnemyData
		{
			return BcEnemyData(data[id]);
		}
	}
}