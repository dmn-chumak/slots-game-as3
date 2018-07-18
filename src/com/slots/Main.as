package com.slots {
    import com.slots.config.SlotConfig;
    import com.slots.view.GameView;
    import com.slots.view.LoaderView;
    import com.slots.view.View;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    [SWF(width="800", height="600", frameRate="60", backgroundColor="#D4D4D4")]
    public class Main extends Sprite {
        private var _view:View = null;

        public function Main() {
            if (stage != null) {
                stageAddedHandler();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, stageAddedHandler);
            }
        }

        private function setupStage():void {
            stage.addEventListener(Event.RESIZE, stageResizeHandler);
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.quality = StageQuality.HIGH;
        }

        private function loadConfig():void {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailedHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);
            loader.load(new URLRequest('../res/config.json'));

            trace('Trying to load game config.');

            switchView(new LoaderView(), { loader: loader });
        }

        private function switchView(view:View, params:Object = null):void {
            if (_view == view) {
                return;
            }

            if (_view != null) {
                _view.dispose();
                removeChild(_view);
            }

            _view = view;

            if (_view != null) {
                stageResizeHandler();
                addChild(_view);
                _view.compose(params);
            }
        }

        private function stageAddedHandler(event:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, stageAddedHandler);
            setupStage();
            loadConfig();
        }

        private function stageResizeHandler(event:Event = null):void {
            if (_view != null) {
                _view.x = (stage.stageWidth - View.CONTENT_WIDTH) / 2;
                _view.y = (stage.stageHeight - View.CONTENT_HEIGHT) / 2;
            }
        }

        private function loadCompleteHandler(event:Event):void {
            var loader:URLLoader = event.currentTarget as URLLoader;
            loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailedHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);

            trace('Game config successfully loaded.');

            try {
                SlotConfig.parse(JSON.parse(loader.data));
            } catch (error:Error) {
                trace('Game config parse error: ' + error.message);
                return;
            }

            switchView(new GameView());
        }

        private function loadFailedHandler(event:Event):void {
            var loader:URLLoader = event.currentTarget as URLLoader;
            loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailedHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);

            trace('Failed to load game config.');
        }
    }
}
