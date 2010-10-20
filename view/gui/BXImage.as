package bloxley.view.gui {
    
    import bloxley.controller.game.*;
    import bloxley.view.gui.*;

    public class BXImage extends BXGuiElement {

        var clipName:String;

        function BXImage(controller:BXInterface, clipName:String, options = null) {
            super(controller, options);

            this.clipName = clipName;
            
            addSpriteLayer( clipName );
        }

        /***************************
        *                          *
        * Loading & Saving Methods *
        *                          *
        ***************************/

        // function toXml(bank:String) {
        //     return "<image source='" + clipName + "' bank='" + bank + "' left='" + left + "' top='" + top + "' scale='" + fraction + "' />\n";
        // }
        // 
        // static function loadFromXml(controller:BXController, xml:XML) {
        //     return new BXImage(controller, xml.attributes.source);
        // }


    }
}