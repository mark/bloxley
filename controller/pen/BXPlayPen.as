package bloxley.controller.pen {

    import bloxley.controller.game.BXPlayController;
    import bloxley.model.data.BXDirection;
    
    public class BXPlayPen extends BXPen {
    
        public function BXPlayPen(controller:BXPlayController) {
            super(controller);
        }
        
        override public function onSet() {
            // var firstActor = controller.board().allActors().thatCanBePlayer().theFirst();
            // controller.select( firstActor );
        }
        
        override public function down(mouse:BXMouseEvent) {
            var act = actor();
            
            if (act && act.canBePlayer()) {
                // trace("Clicked on " + act);
                controller.select(act);
            }
        }

        override public function arrow(direction:BXDirection) {
            if (controller.selection()) {
                // trace("Arrow: (" + direction.dx() + ", " + direction.dy() + ")");
                
                (controller as BXPlayController).moveCharacter(direction);
            }
        }
    }
}
