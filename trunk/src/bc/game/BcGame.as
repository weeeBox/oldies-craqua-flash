package bc.game 
{
	import bc.core.audio.BcAudio;
	import bc.core.data.BcData;
	import bc.core.device.BcDevice;
	import bc.core.device.BcIApplication;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;
	import bc.ui.BcGameUI;
	import bc.world.core.BcWorld;

	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;

	/**
	 * @author Elias Ku
	 */
	public class BcGame implements BcIApplication
	{
		private var world:BcWorld;
		private var so:SharedObject;
		
		public function BcGame()
		{
			if(!BcGameGlobal.game)
			{
				BcData.load(Vector.<String>(["data"]));

				initializeLocalStore();
				
				BcGameGlobal.game = this;
				
				BcAudio.configurate("audio_data");
				//BcBitmapData.load("prop_bitmaps");
				BcData.load(Vector.<String>(["music", "prop_bitmaps", "audio_data"]));
				
				BcStrings.initialize();
				
				
				world = new BcWorld();
				BcDevice.application = this;
				
				new BcGameUI();
				
				/*BcDevice.display.addEventListener(GameEvent.SINGLEPLAYER_START_GAME_RESULT, startGameResultHandler);
				BcDevice.display.addEventListener(GameEvent.SINGLEPLAYER_START_GAME_FAIL, startGameFailHandler);
				BcDevice.display.addEventListener(GameEvent.SINGLEPLAYER_END_GAME_RESULT, endGameResultHandler);
				BcDevice.display.addEventListener(GameEvent.SINGLEPLAYER_END_GAME_FAIL, endGameFailHandler);
				BcDevice.display.addEventListener(GameEvent.SINGLEPLAYER_UPDATE_HIGHSCORE_RESULT, updateHighscoreResultHandler);
				BcDevice.display.addEventListener(GameEvent.SINGLEPLAYER_UPDATE_HIGHSCORE_FAIL, updateHighscoreFailHandler);*/
				//BcDevice.display.addEventListener(GameEvent.WRAPPER_PAUSED, gamePausedHandler);
				//BcDevice.display.addEventListener(GameEvent.WRAPPER_UNPAUSED, gameUnpausedHandler);
			}
		}
		
		private var _newGame:Boolean;
		public function startGame(newGame:Boolean):void
		{
			_newGame = newGame;
			/*if(!_gPlaying)
				sendStartGame();
			else if(!newGame)*/
			world.start(_newGame);
		}
		
		/*private var _gPlaying:Boolean;
		private function sendStartGame():void
		{
			if(!_gPlaying)
			{
				trace("send start game");
				if(BcDevice.isLoadedInSWF())
				{ 
					BcDevice.display.dispatchEvent(new GameEvent(GameEvent.SINGLEPLAYER_START_GAME));
				}
				else
				{
					startGameResultHandler(null);
				}
			}
		}
		
		public function sendEndGame():void
		{
			if(_gPlaying)
			{
				trace("send end game");
				if(BcDevice.isLoadedInSWF())
				{ 
					BcDevice.display.dispatchEvent(new GameEvent(GameEvent.SINGLEPLAYER_END_GAME));
				}
			}
		}
		
		public function sendScores():void
		{
			if(_gPlaying)
			{
				trace("send scores");
				var score:int = BcGameGlobal.world.player.getMoney();
				var updateScoreEvent:GameEvent = new GameEvent(GameEvent.SINGLEPLAYER_UPDATE_HIGHSCORE, score);
				if(BcDevice.isLoadedInSWF())
				{
					BcDevice.display.dispatchEvent(updateScoreEvent);
				}
				else
				{
					updateHighscoreResultHandler(updateScoreEvent);
				}
			}
		}*/
		
		public function update(dt:Number):void
		{			
			if(world.playing)
			{
				world.update(dt);
			}
		}
		
		public function activate(active:Boolean):void
		{
			if(world.playing && !active)
			{
				pausePlaying();
			}
		}
		
		public function resumePlaying():void
		{
			if(world.pause == true)
			{
				world.pause = false;
			}
		}
		
		public function pausePlaying():void
		{
			if(world.pause == false)
			{
				world.pause = true;
				BcGameUI.instance.goPause();
			}
		}
		
		public function quitWorld():void
		{
			//sendEndGame();
			world.exit();
			Mouse.show();
		}
				
		public function contextMenu():void
		{
			if(world.playing)
			{
				pausePlaying();
			}
		}
		
		public function mouseMessage(message:BcMouseMessage):void
		{
			if(world.playing)
			{
				world.mouseMessage(message);
			}
		}
		
		public function keyboardMessage(message:BcKeyboardMessage):void
		{
			if(world.playing)
			{
				world.keyboardMessage(message);
				if(message.event==BcKeyboardMessage.KEY_DOWN && message.key == Keyboard.ESCAPE && !message.repeated)
				{
					pausePlaying();
				}
			}
		}
		
		private function initializeLocalStore():void
		{
			so = SharedObject.getLocal("bc20");
			
			if(so)
			{
				BcGameGlobal.localStore = so.data;
				if(so.data.name == null)
				{
					so.data.name = "unnamed";
					so.data.best = 0;
				}
			}
			else
			{
				BcGameGlobal.localStore = new Object();
			}
		}
		
		/*public function startGameResultHandler(e:GameEvent):void
		{
			trace("start game result");
			if(!_gPlaying)
			{
				world.start(_newGame);
				_gPlaying = true;
			}
			else
			{
				_gPlaying = BcGameUI.instance.playAgain();
			}
		}
		
		private function startGameFailHandler(e:GameEvent):void
		{
			trace("Error, could not start game! " + e.data);
		}
		
		public function endGameResultHandler(e:GameEvent):void
		{
			trace("end game result");
			if(_gPlaying)
			{	
				BcGameUI.instance.endGame();
				_gPlaying = false;
			}
		}
		
		private function endGameFailHandler(e:GameEvent):void
		{
			trace("Error, could not end game! " + e.data);
		}
		
		private function updateHighscoreResultHandler(e:GameEvent):void
		{
			
		}
		
		private function updateHighscoreFailHandler(e:GameEvent):void
		{
			trace("Error, could not update highscore! " + e.data);
		}*/
		
		/*private function gamePausedHandler(e:GameEvent):void
		{
			if(world.pause == false)
			{
				world.pause = true;
				BcGameUI.instance.goPause();
			}
		}
		
		private function gameUnpausedHandler(e:GameEvent):void
		{
			if(world.pause == true)
			{
				world.pause = false;
			}
		}*/
		
	}
}

internal class PrivateContructor {} 
