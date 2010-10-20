package bloxley.controller.pen {

    import bloxley.controller.game.BXPlayController;
    import bloxley.model.data.BXDirection;
    
    public class BXPlayPen extends BXPen {
    
        public function BXPlayPen(controller:BXPlayController) {
            super(controller);
        }
        
        override public function down(mouse:BXMouseEvent) {
            var act = actor();
            
            if (act && act.canBePlayer()) {
                controller.respondTo("selectPlayer", [ act ]);
            }
        }

        override public function arrow(direction:BXDirection, shift:Boolean, alt:Boolean, ctrl:Boolean) {
            controller.respondTo("moveCharacter", [ direction ]);
        }
        
        override public function press_space(shift:Boolean, alt:Boolean, ctrl:Boolean) {
            controller.respondTo("selectNextPlayer");
        }
    }
}
