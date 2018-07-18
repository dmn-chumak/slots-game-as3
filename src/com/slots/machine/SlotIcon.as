package com.slots.machine {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;

    public class SlotIcon {
        public static const DUMMY:BitmapData = createDummyBitmap(256);

        private var _targetsList:Vector.<Bitmap>;

        private var _iconPath:String;
        private var _bitmapData:BitmapData;
        private var _loader:Loader;
        private var _loading:Boolean;

        public function SlotIcon(iconPath:String) {
            _targetsList = new <Bitmap>[];

            _iconPath = iconPath;
            _bitmapData = DUMMY;
            _loading = false;

            updateIcon();
        }

        private static function createDummyBitmap(size:int, pieces:int = 5):BitmapData {
            var bitmap:BitmapData = new BitmapData(size, size, false);
            var rectangle:Rectangle = new Rectangle(0, 0, size / pieces, size / pieces);
            var color:uint = 0;

            for (var col:int = 0; col < pieces; col++) {
                for (var row:int = 0; row < pieces; row++) {
                    color = ((col + row) % 2 == 0) ? 0xCCCCCC : 0xFFFFFF;

                    rectangle.x = col * (size / pieces);
                    rectangle.y = row * (size / pieces);

                    bitmap.fillRect(rectangle, color);
                }
            }

            return bitmap;
        }

        private function updateIcon():void {
            if (_loader != null) {
                _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
                _loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailedHandler);
                _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);
                _loader.unload();
            }

            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
            _loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadFailedHandler);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);
            _loader.load(new URLRequest(_iconPath));

            _loading = true;
        }

        private function loadFailedHandler(event:Event):void {
            trace('Failed to load "' + _iconPath + '" resource.');
        }

        private function loadCompleteHandler(event:Event):void {
            _bitmapData = Bitmap(_loader.content).bitmapData;
            _loading = false;

            for each (var target:Bitmap in _targetsList) {
                target.bitmapData = _bitmapData;
            }
        }

        public function attachTarget(target:Bitmap):void {
            if (_targetsList.indexOf(target) == -1) {
                _targetsList.push(target);
                target.bitmapData = _bitmapData;
            }
        }

        public function detachTarget(target:Bitmap):void {
            var index:int = _targetsList.indexOf(target);
            if (index != -1) {
                _targetsList.removeAt(index);
                target.bitmapData = DUMMY;
            }
        }

        public function set iconPath(value:String):void {
            if (_iconPath != value) {
                _iconPath = value;
                updateIcon();
            }
        }

        public function get iconPath():String {
            return _iconPath;
        }
    }
}
