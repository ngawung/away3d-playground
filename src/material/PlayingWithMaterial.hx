package Material;
import away3d.cameras.Camera3D;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.controllers.HoverController;
import away3d.debug.AwayStats;
import away3d.entities.Mesh;
import away3d.lights.DirectionalLight;
import away3d.materials.TextureMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.primitives.CubeGeometry;
import away3d.primitives.PlaneGeometry;
import away3d.primitives.SphereGeometry;
import away3d.primitives.TorusGeometry;
import away3d.textures.BitmapTexture;
import away3d.utils.Cast;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Vector3D;

class PlayingWithMaterial extends View3D {		
	private var move:Bool;
	private var lastPanAngle:Float;
	private var lastTiltAngle:Float;
	private var lastMouseX:Float;
	private var lastMouseY:Float;

	private var _cameraController:HoverController;
	
	private var light1:DirectionalLight;
	private var light2:DirectionalLight;
	private var lightPicker:StaticLightPicker;
	
	private var planeMaterial:TextureMaterial;
	private var sphereMaterial:TextureMaterial;
	private var cubeMaterial:TextureMaterial;
	private var torusMaterial:TextureMaterial;
	
	private var plane:Mesh;
	private var sphere:Mesh;
	private var cube:Mesh;
	private var torus:Mesh;
	
	/**
	 * Constructor
	 */
	public function new () {
		super();
		
	}
	
	override private function onAddedToStage(e:Event):Void {
		super.onAddedToStage(e);
		
		initScene();
		initLight();
		initMaterial();
		initObject();
		
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(Event.RESIZE, onResize);
		
		trace("added");
	}
	
	private function initScene():Void {
		//setup the view
		_cameraController = new HoverController(camera);
		_cameraController.distance = 1000;
		_cameraController.minTiltAngle = 0;
		_cameraController.maxTiltAngle = 90;
		_cameraController.panAngle = 45;
		_cameraController.tiltAngle = 20;
	}
	
	private function initLight():Void {
		light1 = new DirectionalLight();
		light1.direction = new Vector3D(0, -1, 0);
		light1.ambient = 0.1;
		light1.diffuse = 0.7;
		 
		scene.addChild(light1);
		 
		light2 = new DirectionalLight();
		light2.direction = new Vector3D(0, -1, 0);
		light2.color = 0x00FFFF;
		light2.ambient = 0.1;
		light2.diffuse = 0.7;
		 
		scene.addChild(light2);
		
		lightPicker = new StaticLightPicker([light1, light2]);
	}
	
	private function initMaterial():Void {
		planeMaterial = new TextureMaterial(Cast.bitmapTexture("assets/material/floor_diffuse.jpg"));
		planeMaterial.specularMap = Cast.bitmapTexture("assets/material/floor_specular.jpg");
		planeMaterial.normalMap = Cast.bitmapTexture("assets/material/floor_normal.jpg");
		planeMaterial.lightPicker = lightPicker;
		planeMaterial.repeat = true;
		planeMaterial.mipmap = false;
		
		sphereMaterial = new TextureMaterial(Cast.bitmapTexture("assets/material/beachball_diffuse.jpg"));
		sphereMaterial.specularMap = Cast.bitmapTexture("assets/material/beachball_specular.jpg");
		sphereMaterial.lightPicker = lightPicker;
		
		cubeMaterial = new TextureMaterial(Cast.bitmapTexture("assets/material/trinket_diffuse.jpg"));
		cubeMaterial.specularMap = Cast.bitmapTexture("assets/material/trinket_specular.jpg");
		cubeMaterial.normalMap = Cast.bitmapTexture("assets/material/trinket_normal.jpg");
		cubeMaterial.lightPicker = lightPicker;
		cubeMaterial.mipmap = false;
		
		var weaveDiffuseTexture:BitmapTexture = Cast.bitmapTexture("assets/material/weave_diffuse.jpg");
		torusMaterial = new TextureMaterial(weaveDiffuseTexture);
		torusMaterial.specularMap = weaveDiffuseTexture;
		torusMaterial.normalMap = Cast.bitmapTexture("assets/material/weave_normal.jpg");
		torusMaterial.lightPicker = lightPicker;
		torusMaterial.repeat = true;


	}
	
	private function initObject():Void {
		plane = new Mesh(new PlaneGeometry(1000, 1000), planeMaterial);
		plane.geometry.scaleUV(2, 2);
		plane.y = -20;
		scene.addChild(plane);

		sphere = new Mesh(new SphereGeometry(150, 40, 20), sphereMaterial);
		sphere.x = 300;
		sphere.y = 160;
		sphere.z = 300;
		scene.addChild(sphere);

		cube = new Mesh(new CubeGeometry(200, 200, 200, 1, 1, 1, false), cubeMaterial);
		cube.x = 300;
		cube.y = 160;
		cube.z = -250;
		scene.addChild(cube);

		torus = new Mesh(new TorusGeometry(150, 60, 40, 20), torusMaterial);
		torus.geometry.scaleUV(10, 5);
		torus.x = -250;
		torus.y = 160;
		torus.z = -250;
		scene.addChild(torus);
	}
	
	private function onEnterFrame(e:Event):Void {
		if (move) {
			_cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
			_cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
		}
		
		light1.direction = new Vector3D(
			Math.sin(Lib.getTimer() / 10000 * 2) * 150000,
			1000, 
			Math.cos(Lib.getTimer() / 10000 * 2) * 150000
		);
		
		render();
	}
	
	private function onMouseDown(event:MouseEvent):Void {
		lastPanAngle = _cameraController.panAngle;
		lastTiltAngle = _cameraController.tiltAngle;
		lastMouseX = stage.mouseX;
		lastMouseY = stage.mouseY;
		move = true;
		stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}
	
	/**
	 * Mouse up listener for navigation
	 */
	private function onMouseUp(event:MouseEvent):Void {
		move = false;
		stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}
	
	/**
	 * Mouse stage leave listener for navigation
	 */
	private function onStageMouseLeave(event:Event):Void {
		move = false;
		stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
	}
	
	private function onResize(event:Event = null):Void {
		width = stage.stageWidth;
		height = stage.stageHeight;
	}
}