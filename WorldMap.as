package 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	import TheGame;
	import flash.display.Sprite;


	public class WorldMap extends MovieClip
	{
		private var stageRef:Stage;
		private var bg:Sprite;
		public var player1:Player1= new Player1();
		public var player2:Player2 = new Player2();

		var _speed:int = 20;


		var upArrowPressed:Boolean = false;
		var downArrowPressed:Boolean = false;
		var leftArrowPressed:Boolean = false;
		var rightArrowPressed:Boolean = false;
		public var stopMovement:Boolean = false;
		
		public var textBlocks:Array = new Array();
		private var conversationBegun:Boolean = false;
		var quadratisFont:Font = new Quadratis();

		
		var instructions:InstructionText = new InstructionText();
		

		public function WorldMap(stageRef:Stage, bg:Sprite)
		{
			// constructor code
			this.stageRef = stageRef;
			this.bg = bg;
			player1.x = 95;
			player1.y = bg.height - 95;
			player2.x = bg.width - 100;
			player2.y = bg.height - 95;
			player1.gotoAndStop(1)
			bg.addChild(player1);
			bg.addChild(player2);
			
			bg.addChild(instructions)
			instructions.x = player2.x - 100;
			instructions.y = player2.y - 100;
			instructions.visible = false;

			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
			stageRef.addEventListener(KeyboardEvent.KEY_UP, keyPressedUp);
		}

		//not in use
		/*public function addedToStageHandler(e:Event)
		{
			this.stageRef = stage;
			player1.x = 95;
			player1.y = stageRef.stageHeight - 95;
			player2.x = stageRef.stageWidth - 100;
			player2.y = stageRef.stageHeight - 95;
			stageRef.addChild(player1);
			stageRef.addChild(player2);

			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
			stageRef.addEventListener(KeyboardEvent.KEY_UP, keyPressedUp);
		}*/

		public function keyPressedDown(event:KeyboardEvent)
		{			
			if (! stopMovement)
			{				
				if (event.keyCode == 38)
				{
					upArrowPressed = true;
					//trace("upArrowPressed");
					movePlayer(event.keyCode);
				}
				else if (event.keyCode==40)
				{//down
					downArrowPressed = true;
					//trace("downArrowPressed");
					movePlayer(event.keyCode);
				}
				else if (event.keyCode==37)
				{//left
					leftArrowPressed = true;
					//trace("leftArrowPressed");
					movePlayer(event.keyCode);
				}
				else if (event.keyCode==39)
				{//right
					rightArrowPressed = true;
					//trace("rightArrowPressed");
					movePlayer(event.keyCode);
				}
			}
			checkConversation(event);
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

		function movePlayer(keyCode:int):void
		{
		player1.gotoAndPlay(2);
		if (keyCode == 38 && player1.y > 90) //up
			{
				player1.y -= _speed;
			}
		else if (keyCode == 40 && player1.y < (bg.height - 90)) //down
			{
				player1.y += _speed;
			}
		else if (keyCode == 37 && player1.x > 90) //left
			{
				player1.x -= _speed;
			}
		else if (keyCode == 39 && player1.x < bg.width)  //right
			{
				player1.x += _speed;
			}
		}

		function checkConversation(event:KeyboardEvent):void
		{
			if (player1.hitTestObject(player2))
			{			
				player1.gotoAndStop(1);
				instructions.visible = true;				
				if(event.keyCode == Keyboard.ENTER && !conversationBegun)
				{
					instructions.visible = false;
					bg.removeChild(instructions);
					beginConversation();
				}
			}
			else
			{
				instructions.visible = false;
			}
		}
		
		function beginConversation():void
		{
			conversationBegun = true;
			textBlocks.push("You've come for training?");
			textBlocks.push("Very well.");
			textBlocks.push("Time to see what you're made of!");
			textBlocks.push("");
			var conversationText:TextField = new TextField();
			conversationText.width = 400;
			conversationText.mouseEnabled = false;
			var formatText:TextFormat = new TextFormat();
			formatText.color = 0x660000;
			//formatText.font = quadratisFont.fontName;
			formatText.size=20;
			formatText.bold=true;
			//conversationText.setTextFormat(formatText);
			//conversationText.embedFonts = true;
			
			
			
			var rpgText:RPGText = new RPGText(conversationText, formatText, stageRef, this, bg);
			rpgText.x = stageRef.stageWidth * 1/25;
			rpgText.y = stageRef.stageHeight - 110;
			conversationText.x = rpgText.x + 10;
			conversationText.y = rpgText.y + rpgText.height/3;
			bg.addChild(rpgText);
			bg.addChild(conversationText);
			
			rpgText.textBlocks = textBlocks;
			rpgText.startText();
			
		}
		
		function startTheGame():void
		{
			stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
			stageRef.removeEventListener(KeyboardEvent.KEY_UP, keyPressedUp);
			bg.removeChild(player1);
			bg.removeChild(player2);
			var playTheGame:TheGame = new TheGame(stageRef, bg);
			bg.addChild(playTheGame);
		}
	}

}