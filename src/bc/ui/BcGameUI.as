package bc.ui 
{
	import bc.core.audio.BcAudio;
	import bc.core.audio.BcMusic;
	import bc.core.device.BcAsset;
	import bc.core.device.BcDevice;
	import bc.core.display.BcBitmapData;
	import bc.core.ui.UI;
	import bc.core.ui.UIButton;
	import bc.core.ui.UICheckBox;
	import bc.core.ui.UIImage;
	import bc.core.ui.UILabel;
	import bc.core.ui.UILayer;
	import bc.core.ui.UIObject;
	import bc.core.ui.UIPanel;
	import bc.core.ui.UIStyle;
	import bc.core.ui.UITransition;
	import bc.game.BcGameGlobal;
	import bc.game.BcStrings;
	import bc.world.player.BcPlayer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Elias Ku
	 */
	public class BcGameUI 
	{
		public var oSponsorLogo:Boolean = false;
		public var oSponsorSplash:Boolean = true;
		public var oSponsorCredits:Boolean = true;
		public var oShowScoresButton:Boolean = false;
		public var oBestScore:Boolean = false;
		
		
		public static var instance:BcGameUI;
		
		private var layerBack:UILayer = new UILayer();
		private var layerMain:UILayer = new UILayer();
		private var layerOverlay:UILayer = new UILayer();
		
		private var backPanel:UIPanel = new UIPanel(layerBack);
		private var backFader:UIObject;
		private var backTitle:UIGameTitle;
		private var backBubbles:UIBubbles;
		
		public function BcGameUI()
		{
			if(instance) throw new Error();
			
			instance = this;
			
			UI.addLayer(layerBack);
			UI.addLayer(layerMain);
			UI.addLayer(layerOverlay);
			
			new UIImage(backPanel, 0, 0, "ui_bg");
			backFader = new UIObject(backPanel);
			initBackFader();
			
			backPanel.play(transBackStart, 1, loadingComplete);
		}
		
		private var mainPanel:UIPanel = new UIPanel(layerMain);
		private var mainButtons:UIObject = new UIObject(mainPanel);
		private var mainNewGame:UIButton;
		private var mainContinue:UIButton;
		private var mainHighScores:UIButton;
		private var mainHelp:UIButton;
		private var mainFader:UIObject;
		private var mainFaderBitmap:Bitmap;
		private var mainSponsor:UIImage;
		
		private var mainBest:UILabel;
		
		private var creditsPanel:UIPanel = new UIPanel(layerMain, 0, 0, false);
		private var creditsClose:UIButton;
		
		private var hsPanel:UIPanel = new UIPanel(layerMain, 0, 0, false);
		private var hsBack:UIButton;
		//private var g5Hiscores:ZattikkaHiScores;
		
		private var gameFader:UIGameEffect = new UIGameEffect(layerBack);
		
		private var pausePanel:UIPanel = new UIPanel(layerMain);
		//private var pauseEnd:UIButton;
		private var pauseResume:UIButton;
		
		private var endPanel:UIPanel = new UIPanel(layerMain);
		private var endLabel:UILabel;
		private var endRank:UILabel;
		private var endResult:UILabel;
		private var endContinue:UIButton;
		//private var endSubmit:UIButton;
		//private var endGame:UIButton;
		//private var endReplay:UIButton;
		
		
		
		private var stQuality:UIStyle;
		private var stMusic:UIStyle;
		private var stSound:UIStyle;
		private var stButtonMedium:UIStyle = new UIStyle(UIButton.DEFAULT_STYLE, {scale:0.75});
		private var stButtonOther:UIStyle = new UIStyle(UIButton.DEFAULT_STYLE, {scale:0.85});
		private var stButtonSmall:UIStyle = new UIStyle(UIButton.DEFAULT_STYLE, {scale:0.5});
		private var stTitle:UIStyle = new UIStyle(UILabel.DEFAULT_STYLE, 
			{
				font: "main",
				textSize: 30,
				textColor: 0xffffff,
				strokeBlur: 3,
				strokeColor: 0x033754,
				strokeAlpha: 1,
				strokeStrength: 6
			});
			
		private var stInfo:UIStyle = new UIStyle(stTitle, {	textSize: 25 });
		private var stInfoSmall:UIStyle = new UIStyle(stTitle, { textSize: 15 });
		
		private var settingsPanel:UIPanel = new UIPanel(layerOverlay);
		private var settingsQ:UICheckBox;
		private var settingsM:UICheckBox;
		private var settingsS:UICheckBox;

		public function loadingComplete(o:UIObject):void
		{
			var bd:BcBitmapData = new BcBitmapData();
			bd.bitmapData = BcAsset.getImage("sponsor_logo");
			bd.x = -bd.bitmapData.width*0.5;
			bd.y = -bd.bitmapData.height*0.5;
			BcBitmapData.addData("sponsor_logo", bd);
			
			stQuality = new UIStyle(UICheckBox.DEFAULT_STYLE, {text1:BcStrings.UI_QUALITY_HIGH, text2:BcStrings.UI_QUALITY_LOW, back1:"ui_qb", back2:"ui_qb", body1:"ui_q", body2:"ui_q"});
			stMusic = new UIStyle(UICheckBox.DEFAULT_STYLE, {text1:BcStrings.UI_MUSIC_ON, text2:BcStrings.UI_MUSIC_OFF, back1:"ui_m1b", back2:"ui_m2b", body1:"ui_m1", body2:"ui_m2"});
			stSound = new UIStyle(UICheckBox.DEFAULT_STYLE, {text1:BcStrings.UI_SFX_ON, text2:BcStrings.UI_SFX_OFF, back1:"ui_s1b", back2:"ui_s2b", body1:"ui_s1", body2:"ui_s2"});
			
			new UIImage(mainButtons, 511, 423+4, "sponsor_logo");
			
			backBubbles = new UIBubbles(backPanel);
			backTitle = new UIGameTitle(backPanel, 320, -165);
			
			// MAIN
			mainNewGame = new UIButton(mainButtons, 510, 182, BcStrings.UI_NEW_GAME, null, onButtonClick);
			mainNewGame.highlight = true;
			mainContinue = new UIButton(mainButtons, 510, 260, BcStrings.UI_CONTINUE, null, onButtonClick);
			mainContinue.multiline = true;
			
			if(oShowScoresButton)
			{
				mainHighScores = new UIButton(mainButtons, 510, 360-16-8-2, BcStrings.UI_HIGHSCORES, stButtonOther, onButtonClick);
			}
			else
			{
				if(oBestScore)
				{
					mainBest = new UILabel(mainButtons, 510, 360-8-2-48, "", stTitle);
					mainBest.multiline = true;
				}
			}
			
			if(!oBestScore && !oShowScoresButton)
			{
				mainHelp = new UIButton(mainButtons, 510, 360-24, BcStrings.UI_CREDITS, stButtonOther, onButtonClick);
			}
			else
			{
				mainHelp = new UIButton(mainButtons, 510, 400+2, BcStrings.UI_CREDITS, stButtonOther, onButtonClick);
			}
			initMainFader();
			
			creditsClose = new UIButton(creditsPanel, 320, 420, BcStrings.UI_BACK, null, onButtonClick);
			var label:UILabel;
			var image:UIImage;
			
			
				
			
			
			if(oSponsorCredits)
			{
				image = new UIImage(creditsPanel, 160, 160, "ui_ddg");
				image.sprite.scaleX = 
				image.sprite.scaleY = 0.6;
				(new UILabel(creditsPanel, 320, 100-20, "DIGIDUCK GAMES", stInfoSmall)).centerX = 160;
				
				
				
				image = new UIImage(creditsPanel, 320+160, 160, "sponsor_logo");
				//image.sprite.scaleX = 
				//image.sprite.scaleY = 0.6;
				(new UILabel(creditsPanel, 320, 100-20, "SPONSORED BY:", stInfoSmall)).centerX = 320+160;
				
				if(oSponsorLogo)
				{
					mainSponsor = new UIImage(backPanel, -68, 480-36-8, "sponsor_logo");
					mainSponsor.sprite.scaleX = 
					mainSponsor.sprite.scaleY = 0.4;
				}
			}
			else
			{
				new UIImage(creditsPanel, 320, 180, "ui_ddg");
				(new UILabel(creditsPanel, 320, 30, "DIGIDUCK GAMES", stTitle)).centerX = 320;
			}
			
			label = new UILabel(creditsPanel, 200, 285, "", stInfoSmall);
			label.multiline = true;
			label.html = "<p align=\"center\"><font color=\"#33ff33\">DEVELOPED BY:</font><br>Kuzmichev Ilya<br>aka<br>Elias Ku</p>";
			label.centerX = 110;
			label = new UILabel(creditsPanel, 200, 285, "", stInfoSmall);
			label.multiline = true;
			label.html = "<p align=\"center\"><font color=\"#33ff33\">MUSIC/SFX BY:</font><br>Korobeynik Alexey<br>aka<br>Alexis Scorpio</p>";
			label.centerX = 530;
			
			label = new UILabel(creditsPanel, 200, 305, "", stInfoSmall);
			label.multiline = true;
			label.html = "<p align=\"center\"><font color=\"#33ff33\">THANKS TO:</font><br>StormEx, grouzdev, Myxa</p>";
			label.centerX = 320;
			
			hsBack = new UIButton(hsPanel, 320, 435, "CONTINUE", null, onButtonClick);
			
			/** PAUSE **/
			(new UILabel(pausePanel, 320, 200, BcStrings.UI_PAUSED, stTitle)).centerX = 320;
			pauseResume = new UIButton(pausePanel, 320, 300, BcStrings.UI_RESUME, null, onButtonClick);
			pauseResume.highlight = true;
			//pauseEnd = new UIButton(pausePanel, 320, 400, BcStrings.UI_END_GAME, stButtonSmall, onButtonClick);
			
			// END
			endLabel = new UILabel(endPanel, 320, 50-32, "", stTitle);
			
			endRank = new UILabel(endPanel, 320, 400-64-24, "", stInfo);
			endResult = new UILabel(endPanel, 320, 400-32-16, "", stInfo);
			
			initStats();

			endContinue = new UIButton(endPanel, 320, 100+16, BcStrings.UI_CONTINUE, null, onButtonClick);
			endContinue.highlight = true;
			//endSubmit = new UIButton(endPanel, 320, 400+32, "SUBMIT", null, onButtonClick);
			//endSubmit.multiline = true;
			//endSubmit.html = "<p align=\"center\"><font size=\"25\">" + BcStrings.UI_SUBMIT_SCORES + "</font></p>";
			
			//endGame = new UIButton(endPanel, 320-232, 100-32, BcStrings.UI_END_GAME, stButtonSmall, onButtonClick);
			//endReplay = new UIButton(endPanel, 320+232, 100-32, BcStrings.UI_REPLAY, stButtonSmall, onButtonClick);
			
			// SETTINGS
			settingsQ = new UICheckBox(settingsPanel, 620-527+16, 466-8, stQuality, onSettingClick);
			settingsS = new UICheckBox(settingsPanel, 584-527+16, 466-8, stSound, onSettingClick);
			settingsM = new UICheckBox(settingsPanel, 547-527+16, 466-8, stMusic, onSettingClick);
			
			selectMainButtonsLight();
			mainPanel.play(transWindowOpen, 1);
			mainButtons.play(transMainButtonsOpen, 1);
			if(mainSponsor) mainSponsor.play(transMainSponsorOpen, 1);
			backTitle.play(transTitleShow, 1);
			backFader.play(transObjectHide, 1);
			settingsPanel.play(transWindowOpen, 1);
			BcMusic.getMusic("menu").play(1);
		}
		
		private function selectMainButtonsLight():void
		{
			const cont:Boolean = BcGameGlobal.world.checkPoint.wave > 0;
			
			mainNewGame.highlight = !cont;
			mainContinue.highlight = cont;
			
			mainContinue.html = "<p align=\"center\">" + BcStrings.UI_CONTINUE + "<br><font size=\"12\">" + 
			BcStrings.INFO_STAGE_N + (BcGameGlobal.world.checkPoint.wave+1).toString() +
				"</font></p>";
			
			if(!oShowScoresButton && oBestScore)
			{
				mainBest.html = "<p align=\"center\">" + BcStrings.INFO_YOUR_BEST_SCORE + "<br><font size=\"20\">" + 
					uint(BcGameGlobal.localStore.best).toString() +
					"</font></p>";
				mainBest.centerX = 510;
			}
		}
		
		private function onButtonClick(button:UIButton):void
		{
			switch(button)
			{
				case mainNewGame:
					continueGame = false;
					closeMain();
					break;
				case mainContinue:
					continueGame = true;
					closeMain();
					break;
				case mainHelp:
					showCredits();
					break;
				case mainHighScores:
					showHighscores();
					break;
				case pauseResume:
					resumeGame = true;
					closePause();
					break;
				/*case pauseEnd:
					resumeGame = false;
					closePause();
					break;*/
				/*case endGame:
					endClickEnd();
					break;*/
				/*case endReplay:
					endClickReplay();
					break;*/
				case endContinue:
					endClickContinue();
					break;
				/*case endSubmit:
					endClickSubmit();
					break;*/
					
				case creditsClose:
					enableMain();
					creditsPanel.play(transWindowClose, 1);
					break;
					
				case hsBack:
					/*BcDevice.stage.removeChild(g5Hiscores);*/
					endPanel.play(transWindowOpen, 0.5);
					hsPanel.play(transWindowClose, 0);
					break;
			}
			
		}
		
		private function showCredits():void
		{
			disableMain();
			creditsPanel.play(transWindowOpen, 1);
		}
		
		private function showHighscores():void
		{
			//
		}
		
		private function enterEndGame():void
		{
			if(BcGameGlobal.world.player.getMoney() > 0 && !BcGameGlobal.world.uiDeath)
			{
				//BcGameGlobal.game.sendScores();
				//endPanel.play(transWindowOpen, 1, function (o:UIObject):void {showSubmit();});
			}
			
			if(BcGameGlobal.world.uiVictory || BcGameGlobal.world.uiDeath)
			{
				BcGameUI.instance.endGame();
			}
			
			/*if(oShockHS)
			{
				endPanel.play(transWindowClose, 1);
				hsPanel.play(transWindowOpen, 1);
				//BcDevice.stage.addChild(g5Hiscores);
				
				var score:int = BcGameGlobal.world.player.getMoney();
				//g5Hiscores.setDetails(27, 0, "shooter", "n4mm5nfjspo94fn", false, score, score.toString(), "points!");
			}*/
		}
		
		public function endGame():void
		{
			BcMusic.stopAll(1);
			
			if(BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss)
			{
				BcGameGlobal.game.quitWorld();
			}
			
			gameFader.play(transFaderExit, 0.5);
			endPanel.play(transWindowClose, 0.5, 
				function(o:UIObject):void
				{
					openMain(false);
				}
			);
		}
		
		
		public function playAgain():Boolean
		{
			if(BcGameGlobal.world.uiVictory)
			{
				BcMusic.getMusic("victory").stop(1);
				gameFader.play(transFaderExit, 0.5);
				endPanel.play(transWindowClose, 0.5, 
					function(o:UIObject):void
					{
						openMain(false);
					}
				);
				return false;
			}
			else if(BcGameGlobal.world.uiDeath)
			{
				gameFader.play(transFaderExit, 0.5);
				endPanel.play(transWindowClose, 0.5);
				settingsPanel.play(transWindowClose, 0.5, 
					function(o:UIObject):void
					{
						BcGameGlobal.game.startGame(false);
						gameFader.initBack();
						gameFader.play(transFaderStart, 1);
					}
				);
			}
			return true;
		}
		
		
		private function onSettingClick(check:UICheckBox):void
		{
			switch(check)
			{
				case settingsQ:
				
					if(settingsQ.checked) BcDevice.quality = 0;
					else BcDevice.quality = 2;

					break;
				case settingsM:
				
					if(settingsM.checked) BcMusic.setVolume(0);
					else BcMusic.setVolume(1);
					
					break;
				case settingsS:

					if(settingsS.checked) BcAudio.setSFXVolume(0);
					else BcAudio.setSFXVolume(1);

					break;
			}
		}

		private function openMain(openSettings:Boolean = true):void
		{
			selectMainButtonsLight();
			mainPanel.play(transWindowOpen, 1);
			mainButtons.play(transMainButtonsOpen, 1);
			if(mainSponsor) mainSponsor.play(transMainSponsorOpen, 1);
			backTitle.play(transTitleShow, 1);
			backPanel.play(transBackOpen, 1);
			if(openSettings) settingsPanel.play(transWindowOpen, 1);
			BcMusic.getMusic("menu").play(2);
		}
		
		private function closeMain():void
		{
			mainPanel.play(transWindowClose, 1);
			mainButtons.play(transMainButtonsClose, 1);
			if(mainSponsor) mainSponsor.play(transMainSponsorClose, 1);
			backTitle.play(transTitleHide, 1);
			backPanel.play(transBackClose, 1, goGame);
			settingsPanel.play(transWindowClose, 1);
			BcMusic.getMusic("menu").stop(2);
		}
		
		private var continueGame:Boolean;
		
		private function goGame(object:UIObject):void
		{
			BcGameGlobal.game.startGame(!continueGame);
			
			gameFader.initBack();
			gameFader.play(transFaderStart, 1);
		}
		
		private var resumeGame:Boolean;
		
		public function goPause():void
		{
			gameFader.initBack();
			gameFader.play(transFaderOpen, 1);
			pausePanel.play(transWindowOpen, 1);
			settingsPanel.play(transWindowOpen, 1);
		}
		
		private function closePause():void
		{
			if(resumeGame)
			{
				gameFader.play(transFaderClose, 0.5);
				BcGameGlobal.game.resumePlaying();
				pausePanel.play(transWindowClose, 0.25);
			}
			/*else
			{
				BcMusic.stopAll(1);
				gameFader.play(transFaderExit, 1, exitPause);
				pausePanel.play(transWindowClose, 0.25);
			}*/
			
			settingsPanel.play(transWindowClose, 0.25);
		}
		
		/*private function exitPause(object:UIObject):void
		{
			if(!resumeGame)
			{
				BcGameGlobal.game.quitWorld();
				openMain();
			}
		}*/
		
		public function goEnd():void
		{
			var pausing:Boolean = BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss;

			endLabel.text = BcGameGlobal.world.uiMessage;
			endRank.text = BcStrings.INFO_RANK + BcGameGlobal.world.uiRank;
			endResult.text = BcStrings.INFO_RESULT + BcGameGlobal.world.player.getMoney().toString();
			
			endLabel.centerX = 
			endRank.centerX = 
			endResult.centerX = 320;
			
			gameFader.initBack();
			
			if(pausing)
			{
				BcGameGlobal.world.pause = true;
				gameFader.play(transFaderOpen, 1);
			}
			else
			{
				gameFader.play(transFaderOpen, 1, 
					function(o:UIObject):void
					{
						BcGameGlobal.game.quitWorld();
					}
				);
			}
			
			/*if(BcGameGlobal.world.uiBoss || BcGameGlobal.world.uiVictory)
			{
				endReplay.play(transDisable, 0);
				endReplay.sprite.alpha = 0.5;
			}
			else
			{
				endReplay.play(transEnable, 0);
				endReplay.sprite.alpha = 1;
			}
			
			if(BcGameGlobal.world.player.getMoney() == 0)
			{
				endSubmit.play(transDisable, 0);
				endSubmit.sprite.alpha = 0.5;
			}
			else
			{
				endSubmit.play(transEnable, 0);
				endSubmit.sprite.alpha = 1;
			}*/
			
			//if((BcGameGlobal.world.uiVictory || BcGameGlobal.world.uiDeath) && BcGameGlobal.world.uiBest)
			if(BcGameGlobal.world.player.getMoney() > 0 && !BcGameGlobal.world.uiDeath)
			{
				//endPanel.play(transWindowOpen, 1, function (o:UIObject):void {showSubmit();});
			}
			//else
			//{
			endPanel.play(transWindowOpen, 1, function (o:UIObject):void {enterEndGame();});
			//}
			
			settingsPanel.play(transWindowOpen, 1);
			
			goStats();
		}
		
		private function endClickContinue():void
		{
			if(BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss)
			{
				gameFader.play(transFaderClose, 0.5);
				endPanel.play(transWindowClose, 0.5);
				settingsPanel.play(transWindowClose, 0.5);
				BcGameGlobal.world.pause = false;
				BcMusic.getMusic("victory").stop(1);
				BcMusic.getMusic("stage").play(1);
			}
			//else BcGameGlobal.game.startGameResultHandler(null);
		}

		/*private function endClickSubmit():void
		{
			//if(sw.ready)
			showSubmit();
		}
		
		private function endClickEnd():void
		{
			BcMusic.stopAll(1);
			
			if(BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss)
			{
				BcGameGlobal.game.quitWorld();
			}
			
			gameFader.play(transFaderExit, 0.5);
			endPanel.play(transWindowClose, 0.5, 
				function(o:UIObject):void
				{
					openMain(false);
				}
			);
		}
		
		private function endClickReplay():void
		{
			if(BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss)
			{
				BcGameGlobal.game.quitWorld();
			}
			
			BcMusic.stopAll(0.5);
			
			gameFader.play(transFaderExit, 0.5);
			endPanel.play(transWindowClose, 0.5);
			settingsPanel.play(transWindowClose, 0.5, 
				function(o:UIObject):void
				{
					BcGameGlobal.game.startGame(false);
					gameFader.initBack();
					gameFader.play(transFaderStart, 1);
				}
			);
		}*/
		
		private var transBackStart:UITransition = new UITransition({
				color:[0xff000000, 0, 0xffffffff, 0], flags:UITransition.OPEN, ease:easeOpen
				});
		private var transObjectShow:UITransition = new UITransition({
				a:[0, 1], ease:easeOpen, flags:[UITransition.FLAG_SHOW, 0]
				});
		private var transObjectHide:UITransition = new UITransition({
				a:[1, 0], ease:easeOpen, flags:[0, UITransition.FLAG_HIDE]
				});
		private var transBackOpen:UITransition = new UITransition({
				color:[0xff000000, 0, 0xffffffff, 0], flags:UITransition.OPEN, ease:easeOpen
				});
		private var transBackClose:UITransition = new UITransition({
				color:[0xffffffff, 0, 0xff000000, 0], flags:UITransition.CLOSE, ease:easeOpen
				});
		private var transWindowOpen:UITransition = new UITransition({
				a:[0, 1], flags:UITransition.OPEN, ease:easeOpen
				});
		private var transWindowClose:UITransition = new UITransition({ 
				a:[1, 0], flags:UITransition.CLOSE, ease:easeOpen 
				});
				
		private var transMainButtonsOpen:UITransition = new UITransition({
				x:[320, 0], ease:easeOpen
				});
		private var transMainButtonsClose:UITransition = new UITransition({ 
				x:[0, 320], ease:easeOpen 
				});
				
		private var transMainSponsorOpen:UITransition = new UITransition({
				x:[-68, 70], ease:easeOpen
				});
		private var transMainSponsorClose:UITransition = new UITransition({ 
				x:[70, -68], ease:easeOpen 
				});
				
		private var transDisable:UITransition = new UITransition({ 
				flags:[UITransition.FLAG_DISABLE, 0] 
				});
				
		private var transEnable:UITransition = new UITransition({ 
				flags:[0, UITransition.FLAG_ENABLE] 
				});
			
		private var transButtonShow:UITransition = new UITransition({ 
				sx:[0, 1], sy:[0, 1], a:[0, 1], ease:easeOpen 
				});
				
		private var transTitleShow:UITransition = new UITransition({ 
				y:[-165, 0], ease:easeOpen 
				});
				
		private var transTitleHide:UITransition = new UITransition({ 
				y:[0, -165], ease:easeOpen 
				});
				
				
		private var transFaderStart:UITransition = new UITransition({ 
				a:[1, 0], color:[0xff000000, 0, 0xffffffff, 0], flags:[UITransition.FLAG_ACTIVATE | UITransition.FLAG_SHOW, UITransition.FLAG_DEACTIVATE | UITransition.FLAG_HIDE], ease:easeOpen
				});
				
		private var transFaderOpen:UITransition = new UITransition({ 
				a:[0, 1], flags:UITransition.OPEN, ease:easeOpen
				});
				
		private var transFaderClose:UITransition = new UITransition({ 
				a:[1, 0], flags:UITransition.CLOSE, ease:easeOpen
				});
				
		private var transFaderExit:UITransition = new UITransition({ 
				color:[0xffffffff, 0, 0xff000000, 0], flags:UITransition.CLOSE, ease:easeOpen
				});
				
		private var transLabelHide:UITransition = new UITransition({ 
				a:[1, 0], ease:easeOpen, flags:[0, UITransition.FLAG_HIDE] 
				});

		private static function easeOpen(t:Number):Number
		{
			const x:Number = 1-t;
			return 1-x*x*x; 
		}
		
		private static function easeClose(t:Number):Number
		{
			return t*t*t; 
		}
		
		private function initBackFader():void
		{
			var nbd:BitmapData = new BitmapData(640, 480, false, 0x0);
			nbd.applyFilter(BcAsset.getImage("ui_bg"), new Rectangle(0, 0, 640, 480), new Point(), new BlurFilter(8, 8));
			var bm:Bitmap = new Bitmap(nbd);
			bm.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5);
			backFader.sprite.addChild(bm);
		}
		
		private function initMainFader():void
		{
			mainFader = new UIObject(mainPanel);
			mainFaderBitmap = new Bitmap(new BitmapData(640, 480, false, 0x0));
			mainFader.sprite.addChild(mainFaderBitmap);
			mainFader.sprite.visible = false;
		}
		
		private function disableMain():void
		{
			mainFaderBitmap.bitmapData.draw(layerBack.sprite);
			mainFaderBitmap.bitmapData.draw(layerMain.sprite);
			mainFaderBitmap.bitmapData.applyFilter(mainFaderBitmap.bitmapData, new Rectangle(0, 0, 640, 480), new Point(), new BlurFilter(8, 8));
			mainFaderBitmap.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5);
			mainFader.play(transObjectShow, 1);
			mainPanel.play(transDisable, 1);
		}
		
		private function enableMain():void
		{
			mainFader.play(transObjectHide, 0.5);
			mainPanel.play(transEnable, 0.5);
		}
		
		private var descRockets:UILabel;
		private var descDamage:UILabel;
		private var descBottom:UILabel;
		private var descBonus:UILabel;
		private var descComplete:UILabel;

		private function initStats():void
		{
			var y:Number = 166+10;
			var labelSpace:Number = 24;
			
			descRockets = new UILabel(endPanel, 150, y, BcStrings.DESC_ROCKETS + int(BcPlayer.M_ROCKETS*100).toString() + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
			descDamage = new UILabel(endPanel, 150, y, BcStrings.DESC_DAMAGE + int(BcPlayer.M_DAMAGE*100).toString() + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
			descBottom = new UILabel(endPanel, 150, y, BcStrings.DESC_BOTTOM + int(BcPlayer.M_BOTTOM*100).toString() + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
			descBonus = new UILabel(endPanel, 150, y, BcStrings.DESC_BONUS + int(BcPlayer.M_BONUS*100).toString() + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
			descComplete = new UILabel(endPanel, 150, y, BcStrings.DESC_COMPLETE + int(BcPlayer.M_COMPLETE*100).toString() + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
		}
		
		private function goStats():void
		{
			var player:BcPlayer = BcGameGlobal.world.player;
			
			if(player.uiRockets)
				descRockets.play(transStatEnable, 3);
			else
				descRockets.play(transStatDisable, 3);
			
			if(player.uiDamage)
				descDamage.play(transStatEnable, 3);
			else
				descDamage.play(transStatDisable, 3);
				
			if(player.uiBottom)
				descBottom.play(transStatEnable, 3);
			else
				descBottom.play(transStatDisable, 3);
				
			if(player.uiBonus)
				descBonus.play(transStatEnable, 3);
			else
				descBonus.play(transStatDisable, 3);
				
			if(player.uiComplete)
				descComplete.play(transStatEnable, 3);
			else
				descComplete.play(transStatDisable, 3);
		}
		
		private var transStatEnable:UITransition = new UITransition({ 
				a:[0.2, 1], color:[0xffffffff, 0xff00ff00], ease:easeOpen 
				});
			
		private var transStatDisable:UITransition = new UITransition({ 
				a:[1, 0.2], color:[0xff00ff00, 0xffffffff], ease:easeOpen 
				});
		
		
		
	}
}
