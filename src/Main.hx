package ;
import Material.PlayingWithMaterial;
import away3d.containers.View3D;
import away3d.debug.AwayStats;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;

/**
 * ...
 * @author Ferdian
 */
class Main extends Sprite {

	public function new() {
		super();
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		var view:View3D = new Material.PlayingWithMaterial();
		view.antiAlias = 4;
		addChild(view);
		
		addChild(new AwayStats(view));
	}
	
}