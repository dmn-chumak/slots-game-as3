package com.slots.config {
    public class SlotBaseConfig implements ISlotConfig {
        private var _isParsed:Boolean;

        public function SlotBaseConfig() {
            _isParsed = false;
        }

        protected function parseIntValue(data:Object, name:String):int {
            checkIfExists(data, name);
            return parseInt(data[name]);
        }

        protected function parseStringValue(data:Object, name:String):String {
            checkIfExists(data, name);
            return String(data[name]);
        }

        protected function checkIfExists(data:Object, name:String):void {
            if (data[name] == null) {
                throw new Error('Game config is empty or invalid.');
            }
        }

        protected function checkIfParsed():void {
            if (!_isParsed) {
                throw new Error('Game config is not parsed yet.');
            }
        }

        protected function markAsParsed():void {
            _isParsed = true;
        }

        public function parse(data:Object):void {
            if (_isParsed) {
                throw new Error('Game config is already parsed.');
            }

            if (data == null) {
                throw new Error('Game config is empty or invalid.');
            }
        }
    }
}
