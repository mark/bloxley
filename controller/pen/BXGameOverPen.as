package bloxley.controller.pen {

    import bloxley.controller.game.BXPlayController;
    import bloxley.model.data.BXDirection;
    
    public class BXGameOverPen extends BXPen {

        public function BXGameOverPen(controller:BXPlayController) {
            super("GameOver", controller);
        }
        
        public function press_Rr(key, shift:Boolean, alt:Boolean, ctrl:Boolean) {
            controller.respondTo("reset");
        }

        override public function press_space(shift:Boolean, alt:Boolean, ctrl:Boolean) {
            // controller.respondTo( "nextLevel" );
        }
    }
    
}