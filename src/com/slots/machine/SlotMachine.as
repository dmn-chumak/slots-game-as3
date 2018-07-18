package com.slots.machine {
    import com.slots.config.SlotConfig;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;

    public class SlotMachine extends Sprite {
        private var _roulettesList:Vector.<SlotRoulette>;
        private var _border:Shape;

        private var _spinRoulettesCount:int;
        private var _waitRoulettesCount:int;
        private var _delayTimer:int;
        private var _isStarted:Boolean;
        private var _lastItemsTypes:Vector.<Vector.<SlotType>>;

        public function SlotMachine() {
            const roulettesCount:int = SlotConfig.machine.roulettesCount;
            const itemSize:int = SlotConfig.item.size;
            const itemsCount:int = SlotConfig.roulette.itemsCount;

            _roulettesList = new <SlotRoulette>[];

            for (var i:int = 0; i < roulettesCount; i++) {
                var roulette:SlotRoulette = new SlotRoulette();
                roulette.x = itemSize * i;
                addChild(roulette);
                _roulettesList[i] = roulette;
            }

            _border = new Shape();
            _border.graphics.lineStyle(2, 0x000000);
            _border.graphics.drawRect(0, 0, roulettesCount * itemSize, itemsCount * itemSize);
            addChild(_border);
        }

        public function start(lastItemsTypes:Vector.<Vector.<SlotType>>):void {
            if (_isStarted) {
                return;
            }

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);

            _spinRoulettesCount = SlotConfig.machine.roulettesCount;
            _waitRoulettesCount = SlotConfig.machine.roulettesCount;
            _delayTimer = SlotConfig.machine.roulettesSpinDelay;
            _lastItemsTypes = lastItemsTypes;

            _isStarted = true;
        }

        private function enterFrameHandler(event:Event):void {
            if (++_delayTimer < SlotConfig.machine.roulettesSpinDelay) {
                return;
            }

            const rouletteIndex:int = SlotConfig.machine.roulettesCount - _waitRoulettesCount;

            _roulettesList[rouletteIndex].addEventListener(SlotEvent.SPIN_COMPLETE, spinCompleteHandler);
            _roulettesList[rouletteIndex].start(_lastItemsTypes[rouletteIndex]);
            _delayTimer = 0;

            if (--_waitRoulettesCount == 0) {
                removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            }
        }

        private function spinCompleteHandler(event:SlotEvent):void {
            SlotRoulette(event.currentTarget).removeEventListener(SlotEvent.SPIN_COMPLETE, spinCompleteHandler);
            event.stopImmediatePropagation();

            if (--_spinRoulettesCount == 0) {
                dispatchEvent(new SlotEvent(SlotEvent.SPIN_COMPLETE));
                _isStarted = false;
            }
        }
    }
}
