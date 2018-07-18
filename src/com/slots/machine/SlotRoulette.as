package com.slots.machine {
    import com.slots.config.SlotConfig;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;

    public class SlotRoulette extends Sprite {
        private var _slotsList:Vector.<SlotItem>;

        private var _maskContainer:Sprite;
        private var _slotsContainer:Sprite;
        private var _maskShape:Shape;

        private var _isStarted:Boolean;
        private var _blurFilter:BlurFilter;
        private var _filtersCache:Array;
        private var _spinTimer:int;
        private var _currentSpeed:Number;
        private var _state:int;
        private var _itemsTypesOrder:Vector.<SlotType>;
        private var _lastItemsTypes:Vector.<SlotType>;

        public function SlotRoulette() {
            const itemsCount:int = SlotConfig.roulette.itemsCount;
            const itemSize:int = SlotConfig.item.size;

            _maskShape = new Shape();
            _maskShape.graphics.beginFill(0xFF0000, 1);
            _maskShape.graphics.drawRect(0, 0, itemSize, itemSize * itemsCount);
            _maskShape.graphics.endFill();
            addChild(_maskShape);

            _maskContainer = new Sprite();
            _maskContainer.mask = _maskShape;
            addChild(_maskContainer);

            _slotsContainer = new Sprite();
            _maskContainer.addChild(_slotsContainer);

            _slotsList = new <SlotItem>[];

            for (var i:int = 0; i < itemsCount + 1; i++) {
                var slot:SlotItem = new SlotItem();
                slot.type = getRandomItemType();
                slot.y = itemSize * i;
                _slotsContainer.addChild(slot);
                _slotsList[i] = slot;
            }

            _itemsTypesOrder = new <SlotType>[];
            _state = SlotRouletteState.INACTIVE;
            _blurFilter = new BlurFilter(0, 0, BitmapFilterQuality.HIGH);
            _filtersCache = [ _blurFilter ];
        }

        public function start(itemTypes:Vector.<SlotType>):void {
            if (_isStarted) {
                return;
            }

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);

            _spinTimer = 0;
            _currentSpeed = 0;
            _state = SlotRouletteState.ACCELERATION;
            _lastItemsTypes = itemTypes;

            _isStarted = true;
        }

        private function getRandomItemType():SlotType {
            return SlotConfig.item.types[
                int(SlotConfig.item.types.length * Math.random())
            ];
        }

        private function updateCurrentSpeed():void {
            const accelerationTime:int = SlotConfig.roulette.accelerationTime;
            const spinTime:int = SlotConfig.roulette.spinTime;
            const decelerationTime:int = SlotConfig.roulette.decelerationTime;
            const spinSpeed:int = SlotConfig.roulette.spinSpeed;

            switch (_state) {
                case SlotRouletteState.ACCELERATION:
                {
                    if (++_spinTimer < accelerationTime) {
                        _currentSpeed = _spinTimer / accelerationTime * spinSpeed;
                    } else {
                        const itemsCount:int = SlotConfig.roulette.itemsCount;
                        const itemSize:int = SlotConfig.item.size;
                        const spinItemsCount:int = spinTime * spinSpeed / itemSize;
                        const randomItemsCount:int = spinItemsCount - itemsCount;

                        for (var i:int = 0; i < randomItemsCount; i++) {
                            _itemsTypesOrder[i] = getRandomItemType();
                        }

                        for (i = 0; i < itemsCount; i++) {
                            _itemsTypesOrder[i + randomItemsCount] = _lastItemsTypes[itemsCount - i - 1];
                        }

                        _currentSpeed = spinSpeed;
                        _state = SlotRouletteState.SPIN;
                        _spinTimer = 0;
                    }

                    break;
                }

                case SlotRouletteState.SPIN:
                {
                    if (++_spinTimer == spinTime) {
                        _state = SlotRouletteState.DECELERATION;
                        _spinTimer = 0;
                    }

                    break;
                }

                case SlotRouletteState.DECELERATION:
                {
                    if (++_spinTimer < decelerationTime) {
                        _currentSpeed = (-_slotsList[0].y - _currentSpeed) / (decelerationTime - _spinTimer);
                    } else {
                        removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                        dispatchEvent(new SlotEvent(SlotEvent.SPIN_COMPLETE));

                        _currentSpeed = -_slotsList[0].y;
                        _state = SlotRouletteState.INACTIVE;
                        _spinTimer = 0;

                        _isStarted = false;
                    }

                    break;
                }
            }
        }

        private function updateSlotsPosition():void {
            const itemsCount:int = SlotConfig.roulette.itemsCount;
            const itemSize:int = SlotConfig.item.size;

            for (var i:int = 0; i < itemsCount + 1; i++) {
                _slotsList[i].y += _currentSpeed;
            }

            if (_state == SlotRouletteState.DECELERATION
            ||  _state == SlotRouletteState.INACTIVE) {
                return;
            }

            while (_slotsList[0].y >= 0) {
                var slot:SlotItem = _slotsList[itemsCount];
                slot.y = _slotsList[0].y - itemSize;

                if (_itemsTypesOrder.length != 0) {
                    slot.type = _itemsTypesOrder.shift();
                } else {
                    slot.type = getRandomItemType();
                }

                for (var j:int = itemsCount; j > 0; j--) {
                    _slotsList[j] = _slotsList[j - 1];
                }

                _slotsList[0] = slot;
            }
        }

        private function updateSlotsFilters():void {
            _blurFilter.blurY = (_state != SlotRouletteState.INACTIVE) ? _currentSpeed : 0;
            _slotsContainer.filters = _filtersCache;
        }

        private function enterFrameHandler(event:Event):void {
            updateCurrentSpeed();
            updateSlotsPosition();
            updateSlotsFilters();
        }

        public function get isStarted():Boolean {
            return _isStarted;
        }
    }
}
