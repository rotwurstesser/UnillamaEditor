package
{
	// adobe
	import com.pascal.ui.simpleui.stepper.ValueStepper;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite
	import flash.display.InteractiveObject;
	import flash.display.DisplayObject
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	//
	// own
	import com.greensock.easing.Circ;
	import com.greensock.events.LoaderEvent;
	import com.pascal.display.Circle;
	import com.pascal.display.Rect;
	import com.pascal.ui.glowui.ContentList;
	import com.pascal.ui.glowui.Content;
	import com.pascal.ui.glowui.ContentBox;
	import com.pascal.ui.glowui.LoggerBox;
	import com.pascal.ui.glowui.TextContent;
	import com.pascal.ui.glowui.TextButton;
	import com.sorcerer.Board;
	import com.sorcerer.BoardManager;
	//
	public class Controller extends Sprite
	{
		// managers
		private var boardManager:BoardManager;
		// graphics
		private var logger:LoggerBox;
		private var board:Board;
		private var box1:ContentBox;
		private var stp1:ValueStepper;
		private var stp2:ValueStepper;
		//
		//
		public function Controller():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, toStage);
			
		}
		
		private function toStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, toStage);
			createLogger();
			createUi();
			createManager();
			createBoard();
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void 
		{
			var fb:Board = boardManager.getFocusedBoard()
			if (fb) {
				fb.width = stp1.value;
				fb.height = stp2.value;
			}
			
		}
		
		private function createCirc():void 
		{
			var circ:Circle = new Circle(50, Math.random() * 0xffffff);
			boardManager.getFocusedBoard().setChild(circ);
			circ.x = Math.random() * board.width;
			circ.y = Math.random() * board.height;
		}
		
		private function createManager() {
			boardManager = new BoardManager();
		}
		private function createBoard():void 
		{
			board = new Board(boardManager);
			board.focus = true;
			addChild(board);
			board.x = 0;
			board.y = 0;
			board.width = Math.random() * (600 - 300) + 300;
			board.height = Math.random() * (600 - 300) + 300;
			boardManager.add(board);
			boardManager.focusSingle(board);
			
		}
		
		private function createLogger():void 
		{
			logger = new LoggerBox( new TextContent("--- LoggerBox ---"));
			addChild(logger);
			logger.outerContentWidth = 130;
			logger.alignTo(stage, "topRight");
			
			logger.log("sw: " + stage.stageWidth);
			logger.log("sh: " + stage.stageHeight);
			
		}
		private function createUi():void {
			
			
			var list:ContentList = new ContentList(0);
			var btn:TextButton = new TextButton(150, 40, "CreateElement",0x333333);
			list.appendContent(btn);
			btn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { 
				createCirc();
			});
			
			var btn3:TextButton = new TextButton(150, 40, "Browse",0x333333);
			btn3.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				logger.log("browse...");
				var f:FileReference = new FileReference();
				var filter:FileFilter = new FileFilter("*.swf (LevelElement)", "*.swf");
				f.browse([filter]);
				
				f.addEventListener(Event.SELECT, function(e:Event) {
					logger.log("selected...");
					f.load();
					f.addEventListener(Event.COMPLETE, function(e:Event) {
						f.removeEventListener(Event.COMPLETE, function(e:Event) { } );
						logger.log("loaded...");
						var ref:FileReference = e.target as FileReference;
						var swf:Loader = new Loader();
						swf.loadBytes(ref.data);
						logger.log("load swf...");
						swf.contentLoaderInfo.addEventListener(Event.COMPLETE, function swfLoaded(e:Event) {
							logger.log("swf loaded.");
							var loaded_swf:DisplayObject = LoaderInfo(e.target).content;
							boardManager.getFocusedBoard().setChild(Sprite(loaded_swf));
							
						});
					});
				});
			});
			list.appendContent(btn3);
			
			var btn4:TextButton = new TextButton(150, 40, "CreateBoard", 0x333333);
			btn4.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) {
				createBoard();
			});
			list.appendContent(btn4);
			
			var btn5:TextButton = new TextButton(150, 40, "NumBoards", 0x333333);
			btn5.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) {
				logger.log(String( "numBoards: "+boardManager.length ));
			});
			list.appendContent(btn5);
			
			
			var btn7:TextButton = new TextButton(150, 40, "ClearAllBoards", 0x333333);
			btn7.addEventListener(MouseEvent.CLICK, function (e:MouseEvent) {
				boardManager.removeAll();
			});
			list.appendContent(btn7);
			
			stp1 = new ValueStepper("boardWidth: ", 105, 40, 0x333333, 400, 10, 1000);
			list.appendContent(stp1);
			stp2 = new ValueStepper("boardHeight: ", 105, 40, 0x333333, 400, 10, 1000);
			list.appendContent(stp2);
			
			
			
			
			box1 = new ContentBox( list );
			addChild(box1);
			box1.x = 600;
			
			
		}
		
		
		// overrides
		/**
		 * todo: auslagern in viewmanager
		 */
		override public function setChildIndex (child:DisplayObject, index:int) : void {
			super.setChildIndex(child, index);
			if(child != box1 && child != logger){
				super.setChildIndex(box1, numChildren - 1);
				super.setChildIndex(logger, numChildren - 1);
			}
		}
		
	}//end-class
}//end-pack