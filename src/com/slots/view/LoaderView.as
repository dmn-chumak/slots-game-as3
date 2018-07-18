package com.slots.view {
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;

    public class LoaderView extends View {
        private static const PROGRESS_BAR_WIDTH:Number = 400;
        private static const PROGRESS_BAR_HEIGHT:Number = 10;
        private static const PROGRESS_BAR_X:Number = (CONTENT_WIDTH - PROGRESS_BAR_WIDTH) / 2;
        private static const PROGRESS_BAR_Y:Number = (CONTENT_HEIGHT - PROGRESS_BAR_HEIGHT) / 2;

        private var _loader:URLLoader;

        override public function compose(params:Object = null):void {
            super.compose(params);

            _loader = URLLoader(params.loader);
            _loader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailedHandler);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);

            loadProgressHandler();
        }

        override public function dispose():void {
            _loader.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailedHandler);
            _loader.removeEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);
            _loader = null;

            super.dispose();
        }

        private function drawProgressBar(color:uint, progress:Number):void {
            graphics.clear();

            graphics.lineStyle(1, color);
            graphics.drawRect(PROGRESS_BAR_X, PROGRESS_BAR_Y, PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT);

            graphics.beginFill(color, .75);
            graphics.drawRect(PROGRESS_BAR_X, PROGRESS_BAR_Y, PROGRESS_BAR_WIDTH * progress, PROGRESS_BAR_HEIGHT);
            graphics.endFill();
        }

        private function loadProgressHandler(event:ProgressEvent = null):void {
            var progress:Number = 0;

            if (event != null && event.bytesTotal != 0) {
                progress = event.bytesLoaded / event.bytesTotal;
            }

            drawProgressBar(0x000000, progress);
        }

        private function loadFailedHandler(event:Event):void {
            drawProgressBar(0x990000, 1);
        }
    }
}
