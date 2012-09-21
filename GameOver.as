package 
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	import Init;
	import flash.display.Sprite;
	
	 
	public class GameOver extends Init
	{
		var outcome_txt:TextField = new TextField();
		var score_txt:TextField = new TextField();
		var playAgain:PlayAgain= new PlayAgain();		
		var _stageRef:Stage;
		private var _bg:Sprite;
		var formatText:TextFormat = new TextFormat();
		var thePrize:Prize= new Prize();
		
		public function GameOver(health1:Number, health2:Number,stageRef:Stage,score1:Number,score2:Number,bg:Sprite)
		{
			_stageRef = stageRef;
			_bg = bg;
			declareWinner(health1, health2,stageRef,score1,score2);
		}

		function declareWinner(health1:Number, health2:Number,stageRef:Stage,score1:Number,score2:Number){
			trace(" you ");
			outcome_txt.x=stageRef.stageWidth/2-250;
			outcome_txt.y=stageRef.stageHeight/2-100;
			score_txt.x=stageRef.stageWidth/2-250;
			score_txt.y=stageRef.stageHeight/2;
			
			if (health1 >= health2)
			{
				outcome_txt.text = "You are the winner! ";
				score_txt.text = "Your score was "+score1;
				formatText.size=54;
				thePrize.x=850;
				thePrize.y=550;
				_bg.addChild(thePrize);
			}
			else
			{
				outcome_txt.text = "You lose!\n Try again, you might have better luck! ";
				score_txt.text = "Your score was "+score2;
				formatText.size=34;
			}
			//outcome_txt.textColor = 0xDB571D;
			outcome_txt.width = 600;  
			score_txt.width=580;
			formatText.color = 0xDB571D;
			
			formatText.bold=true;
			outcome_txt.setTextFormat(formatText);
			score_txt.setTextFormat(formatText);
			_bg.addChild(outcome_txt);
			_bg.addChild(score_txt);
			
			playAgain.x=100;
			playAgain.y=stageRef.stageHeight - 100;
			playAgain.buttonMode = true;
			_bg.addChild(playAgain);
			playAgain.addEventListener(MouseEvent.CLICK, restart);
		}
		
		function restart(e:Event):void
		{
			_bg.removeChild(outcome_txt);
			_bg.removeChild(score_txt);
			_bg.removeChild(thePrize);
			var startTheGam = new Init();
			_bg.removeChild(playAgain);
			_bg.addChild(startTheGam);/***************************************/

		}

		function saveGame(e:MouseEvent):void
		{
			/*
			var myLocalData:SharedObject = SharedObject.getLocal("mygamedata");
			myLocalData.data.score= "store this.";
			trace("found data: "+myLocalData.data.gameinfo);
			trace("you have saved the game");
			*/
		}
	}

}