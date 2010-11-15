package bloxley.controller.pen {

    import bloxley.controller.game.BXPlayController;
    import bloxley.model.data.BXDirection;
    
    import bloxley.view.animation.BXBlend;
    
    public class BXPlayPen extends BXPen {
    
        public function BXPlayPen(controller:BXPlayController) {
            super(controller);
        }
        
        override public function down(mouse:BXMouseEvent) {
            var act = actor();
            
            if (act && act.canBePlayer()) {
                if (! isHeld())
                    controller.respondTo("selectPlayer", [ act ]);
            }
        }

        override public function arrow(direction:BXDirection, shift:Boolean, alt:Boolean, ctrl:Boolean) {
            if (! isHeld())
                controller.respondTo("moveCharacter", [ direction ]);
        }
        
        override public function press_space(shift:Boolean, alt:Boolean, ctrl:Boolean) {
            if (! isHeld())
                controller.respondTo("selectNextPlayer");
        }
    }
}
