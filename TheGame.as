package 
{
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import GameOver;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.display.Sprite;
		import flash.events.MouseEvent;

	public class TheGame extends MovieClip
	{
		var stageRef:Stage;
		var bg:Sprite;


		var upArrowPressed:Boolean = false;
		var downArrowPressed:Boolean = false;
		var leftArrowPressed:Boolean = false;
		var rightArrowPressed:Boolean = false;

		var initialArrowX:int = 140;
		var initialArrowY:int = 400;
		var _speed:int = 5;
		var frequency = 1000;
		var level = 1;
		var boundingBox1:BoundingBox= new BoundingBox();
		var boundingBox2:BoundingBox= new BoundingBox();
		var player1:Player= new Player();
		var player2:Player_2= new Player_2();
		var health1:Number = 100;
		var health2:Number = 100;
		var energy1:Number = 5;
		var energy2:Number = 5;
		var damage:Number = 5;
		var boost:Number = 5;

		var arrowArray:Array = new Array(UpArrow,DownArrow,LeftArrow,RightArrow);
		var arrowsOnStage:Array = new Array();
		var arrowsOnStageInts:Array = new Array();
		var arrow:MovieClip;
		var myTimer:Timer = new Timer(frequency / level + 250);
		var pickedArrow:Number;
		var currentArrow:MovieClip;
		var initialTimer = new Timer(1000,4);
		var countdown:int = 3;
		var countdownText:TextField = new TextField();

		//Draw Health Bar for player 1
		var hpbar1:MovieClip = new healthBar();
		var hpbarBorder1:MovieClip = new healthBorder();
		var healthArray1:Array = new Array(hpbar1,hpbarBorder1);
		//Draw Health Bar for player 2
		var hpbar2:MovieClip = new healthBar();
		var hpbarBorder2:MovieClip = new healthBorder();
		var healthArray2:Array = new Array(hpbar2,hpbarBorder2);
		//Draw Energy bar for player 1
		var energyBar1:MovieClip = new energyBar();
		var energyBorder1:MovieClip = new energyBarBorder();
		var energyArray1 = new Array(energyBar1,energyBorder1);
		//Draw energy bar for player 2
		var energyBar2:MovieClip = new energyBar();
		var energyBorder2:MovieClip = new energyBarBorder();
		var energyArray2 = new Array(energyBar2,energyBorder2);
		var sand:SandBG = new SandBG();
		var score:Number = 0;
		var score1:Number = 0;
		var scoreText:TextField = new TextField();
		var scoreText2:TextField = new TextField();
		var displayScoreText1:TextFormat = new TextFormat();
		var displayScoreText2:TextFormat = new TextFormat();
		//Punch Sound
		var sndPunch:Punch_sound=new Punch_sound();
		var sndPunchChannel:SoundChannel;
		//Cheering Sound
		var sndCheering:Hooray=new Hooray();
		var sndCheeringChannel:SoundChannel;
		//Ahh Sound
		var sndAhh:Ahh_Soft=new Ahh_Soft();
		var sndAhhChannel:SoundChannel;
		//Ahh Sound
		var sndOoos:Ooos=new Ooos();
		var sndOoosChannel:SoundChannel;
		var muteSound:Mute= new Mute();
		var mutedSound:Muted= new Muted();
		var mute:Boolean=false;
		
		public function calcScore()
		{
			score +=  health1 - (energy1 * 2)+500;
			score1 +=  health2 - (energy2 * 2)+500;
			trace("score "+score);
			trace("score1 "+score1);
			displayScore();
			
		} 

		public function displayScore()
		{
			scoreText.x=280;
			scoreText2.x=530;
			scoreText.y=10;
			scoreText2.y=10;
			scoreText2.text = "Score "+String(score1);
			scoreText.text = "Score "+String(score);
			scoreText2.width = 250; 
			scoreText.width = 250; 
			displayScoreText1.color =displayScoreText2.color = 0xDB571D;
			displayScoreText1.size=displayScoreText2.size=30;
			displayScoreText1.bold=displayScoreText2.bold=true;
			scoreText.setTextFormat(displayScoreText1);
			scoreText2.setTextFormat(displayScoreText2);
			scoreText.mouseEnabled = false;
			scoreText2.mouseEnabled = false;
			bg.addChild(scoreText);
			bg.addChild(scoreText2);
		}
		
		function movePlayer(frameNo:Number)
		{
			player1.gotoAndStop(frameNo);
		}
		//player1.gotoAndStop(1);

		function moveOpponent(frameNo:Number)
		{
			player2.gotoAndStop(frameNo);
		}
		//player2.gotoAndStop(1);

		public function TheGame(stageRef:Stage, bg:Sprite)
		{
			this.stageRef = stageRef;
			this.bg = bg;
			initializeEverything();
		}

		function drawUI():void
		{
			muteSound.x = 900;
			muteSound.y = 600;
			muteSound.buttonMode = true;
			muteSound.addEventListener(MouseEvent.CLICK, muteTheSound);
			addChild(muteSound);
			mutedSound.x = 900;
			mutedSound.y = 600;
			mutedSound.buttonMode = true;
			mutedSound.addEventListener(MouseEvent.CLICK, mutedTheSound);
			boundingBox1.x = 140;
			boundingBox2.x = 820;
			boundingBox1.y = boundingBox2.y = 140;
			bg.addChild(boundingBox1);
			bg.addChild(boundingBox2);
			player1.x = 775;
			player2.x = 875;
			sand.x = 450;
			sand.y = 500;
			bg.addChild(sand);
			player1.y = 360;
			player2.y = 360;
			bg.addChild(player1);
			bg.addChild(player2);
			for (var i:int = 0; i < healthArray1.length; i++)
			{
				bg.addChild(healthArray1[i]);
			}

			for (i = 0; i < healthArray2.length; i++)
			{
				bg.addChild(healthArray2[i]);
				healthArray2[i].x = 684;
			}


			for (i = 0; i < energyArray1.length; i++)
			{
				energyArray1[i].y = 36;
				energyArray1[i].x = 5;
				bg.addChild(energyArray1[i]);
			}

			for (i = 0; i < energyArray2.length; i++)
			{
				energyArray2[i].y = 36;
				energyArray2[i].x = 689;
				bg.addChild(energyArray2[i]);
			}
			displayScore();
		}
		function muteTheSound(e:MouseEvent):void
		{
			mute = true;
			muteSound.visible=false;
			mutedSound.visible=true;
			addChild(mutedSound);
			mutedSound.addEventListener(MouseEvent.CLICK, mutedTheSound);
		}
		function mutedTheSound(e:MouseEvent):void
		{
			mute = false;
			muteSound.visible=true;
			muteSound.x = 900;
			muteSound.y = 600;
			mutedSound.visible=false;
			
		}

		function initializeEverything()
		{
			drawUI();
			initialTimer.addEventListener(TimerEvent.TIMER, countDownDelay);
			initialTimer.start();
		}
		
		function countDownDelay(e:Event)
		{
			/*
			**Check to see whether the countdown has already been added to the display list
			**If so, remove from display list
			*/
			if(countdownText.parent != null)
			{
				bg.removeChild(countdownText);
			}
			
			var countdownTextFormat:TextFormat = new  TextFormat(null,54,0xDB571D,true);
			countdownText.text = countdown.toString();
			countdownText.setTextFormat(countdownTextFormat);
			countdownText.mouseEnabled = false;
			countdownText.x = stageRef.stageWidth / 2;
			countdownText.y = 50;
			bg.addChild(countdownText);
			
			if (countdown == 0)
			{
				stageRef.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
				stageRef.addEventListener(KeyboardEvent.KEY_UP, keyPressedUp);
				myTimer.addEventListener(TimerEvent.TIMER, generateArrow);
				myTimer.start();
				bg.addEventListener(Event.ENTER_FRAME, moveArrow);
				bg.removeChild(countdownText);
			}
			
			countdown--;
		}

		function generateArrow(e:Event):void
		{
			pickedArrow = int(Math.random() * arrowArray.length);
			var pickArrow = arrowArray[pickedArrow];
			arrow = new pickArrow();
			bg.addChild(arrow);
			arrow.x = initialArrowX;
			arrow.y = initialArrowY;
			arrow.speed = _speed;
			arrowsOnStage.push(arrow);
			arrowsOnStageInts.push(pickedArrow);
		}

		function moveArrow(e:Event):void
		{
			for (var i:int = 0; i < arrowsOnStage.length; i++)
			{
				currentArrow = arrowsOnStage[i];
				currentArrow.y -=  currentArrow.speed;
				if (currentArrow.y == 100)
				{
					removeArrow(currentArrow);
				}
			}
		}

		function removeArrow(currentArrow:MovieClip)
		{
			if (currentArrow.y == 100)
			{
				decreaseHealth1();
				increaseHealth2();
				myTimer.delay += 50;
				bg.removeChild(currentArrow);
				arrowsOnStage.splice(0,1);
				arrowsOnStageInts.splice(0,1);
			}
		}

		function checkCollision()
		{
			if (boundingBox1.hitTestObject(arrowsOnStage[0]))
			{
				trace("collision with arrow: "+arrowsOnStage[0]);

				decreaseHealth2();
				bg.removeChild(arrowsOnStage[0]);
				arrowsOnStage.splice(0,1);
				arrowsOnStageInts.splice(0,1);
				trace("player 2 health: " + health2);
				calcScore();
								
					myTimer.delay -= 50; 
				
				if(!mute){
					sndPunchChannel = sndPunch.play();
					sndCheeringChannel = sndCheering.play();
					sndAhhChannel = sndAhh.play();
					sndOoosChannel = sndOoos.play();
				}
			}
			else
			{
				trace("missed arrow: "+arrowsOnStage[0]);
				increaseHealth2();
				
			}
		}

		function checkCollisionForEnergy()
		{
			if (boundingBox1.hitTestObject(arrowsOnStage[0]))
			{
				trace("collision with arrow: "+arrowsOnStage[0]);
				decreaseEnergy1();
				bg.removeChild(arrowsOnStage[0]);
				arrowsOnStage.splice(0,1);
				arrowsOnStageInts.splice(0,1);
				trace("player 2 health: " + health2);
			}
			else
			{
				trace("missed arrow: "+arrowsOnStage[0]);
			}
		}

		function keyPressedDown(event:KeyboardEvent)
		{
			trace(pickedArrow);
			if (event.shiftKey)
			{
				trace("shift pressed");
				if (event.keyCode == 38 && arrowsOnStageInts[0] == 0)
				{
					upArrowPressed = true;
					trace("upArrowPressed and shift");
					movePlayer(6);
					moveOpponent(2);
					checkCollisionForEnergy();
					
				}
				else if (event.keyCode==40 &&  arrowsOnStageInts[0] == 1 )
				{//down
					downArrowPressed = true;
					trace("downArrowPressed and shift");
					movePlayer(5);
					moveOpponent(3);
					checkCollisionForEnergy();
					

				}
				else if (event.keyCode==37 &&  arrowsOnStageInts[0] == 2)
				{//left
					leftArrowPressed = true;
					trace("leftArrowPressed and shift");
					movePlayer(2);
					moveOpponent(4);
					checkCollisionForEnergy();
					

				}
				else if (event.keyCode==39 &&  arrowsOnStageInts[0] == 3)
				{//right
					rightArrowPressed = true;
					trace("rightArrowPressed and shift");
					movePlayer(7);
					moveOpponent(5);
					checkCollisionForEnergy();
					
				}
			}
			else if (event.keyCode==38 &&  arrowsOnStageInts[0] == 0)
			{
				upArrowPressed = true;
				trace("upArrowPressed");
				movePlayer(8);
				moveOpponent(7);
				checkCollision();
				

			}
			else if (event.keyCode==40 &&  arrowsOnStageInts[0] == 1)
			{//down
				downArrowPressed = true;
				trace("downArrowPressed");
				movePlayer(5);
				moveOpponent(8);
				checkCollision();
				

			}
			else if (event.keyCode==37 &&  arrowsOnStageInts[0] == 2)
			{//left
				leftArrowPressed = true;
				trace("leftArrowPressed");
				movePlayer(2);
				moveOpponent(3);
				checkCollision();
				

			}
			else if (event.keyCode==39 &&  arrowsOnStageInts[0] == 3)
			{//right
				rightArrowPressed = true;
				trace("rightArrowPressed");
				movePlayer(3);
				moveOpponent(2);
				checkCollision();
				
			}
		}

		function keyPressedUp(event:KeyboardEvent)
		{
			if (event.keyCode == 38)
			{//up
				upArrowPressed = false;
			}
			else if (event.keyCode==40)
			{//down
				downArrowPressed = false;
			}
			else if (event.keyCode==37)
			{//left
				leftArrowPressed = false;
			}
			else if (event.keyCode==39)
			{//right
				rightArrowPressed = false;
			}
		}



		//Health Controlling Functions
		function decreaseHealth1():void
		{
			if (health1 > 0)
			{
				health1 -=  damage;
				healthArray1[0].scaleX -=  damage / 100;
			}
			else if (health1 == 0)
			{
				endGame();
			}
		}
		function decreaseHealth2():void
		{
			if (health2 > 0)
			{
				health2 -=  damage;
				healthArray2[0].scaleX -=  damage / 100;
			}
			if (health2 == 0)
			{
				endGame();
			}
		}
		function increaseHealth1():void
		{
			if (health1 < 100)
			{
				health1 +=  boost;
				trace("player 1 health: " + health1);
				healthArray1[0].scaleX +=  boost / 100;
			}
		}
		function increaseHealth2():void
		{
			if (health2 < 100)
			{
				health2 += boost;
				healthArray2[0].scaleX += boost / 100;
			}
		}

		//Energy controlling functions
		function decreaseEnergy1():void
		{
			if (energy1 > 0)
			{
				energy1--;
				energyArray1[0].scaleX -=  1 / 5;
			}
			if (energy1 == 0)
			{
				restoreEnergy1();
			}

		}
		function restoreEnergy1():void
		{
			energy1 = 5;
			energyArray1[0].scaleX +=  1;
			increaseHealth1();
		}

		function endGame()
		{
			bg.removeChild(boundingBox1);
			bg.removeChild(boundingBox2);
			bg.removeChild(player1);
			bg.removeChild(player2);
			bg.removeChild(sand);
			stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
			stageRef.removeEventListener(KeyboardEvent.KEY_UP, keyPressedUp);
			bg.removeEventListener(Event.ENTER_FRAME, moveArrow);
			myTimer.removeEventListener(TimerEvent.TIMER, generateArrow);
			//gotoAndPlay("gameOver");

			for (var i:int = 0; i < arrowsOnStage.length; i++)
			{
				bg.removeChild(arrowsOnStage[i]);
			}
			for (i = 0; i < healthArray1.length; i++)
			{
				bg.removeChild(healthArray1[i]);
			}//Draw Health Bar for player 2
			for (i = 0; i < healthArray2.length; i++)
			{
				bg.removeChild(healthArray2[i]);
			}//Draw Health Bar for player 2
			for (i = 0; i < energyArray1.length; i++)
			{
				bg.removeChild(energyArray1[i]);
			}//Draw energy bar for player 2
			for (i = 0; i < energyArray2.length; i++)
			{
				bg.removeChild(energyArray2[i]);
			}//Draw energy bar for player 2
			bg.removeChild(scoreText);
			bg.removeChild(scoreText2);
			myTimer.stop();
			//bg.removeChild(muteSound);
			//bg.removeChild(mutedSound);
			var gameOver:GameOver = new GameOver(health1,health2,stageRef,score,score1,bg);
		}
	}

}