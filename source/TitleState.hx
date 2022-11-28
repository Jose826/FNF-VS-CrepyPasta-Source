package;

import openfl.filters.ShaderFilter;
import flixel.addons.effects.FlxTrail;
import WiggleEffect.WiggleEffectType;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import source.shaders.*;

using StringTools;
typedef TitleData =
{
	
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	public static var alreadyGotHere:Bool = false;

	var vcrStuff:VCRDistortionEffect = new VCRDistortionEffect();

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var titleShouldFly:Bool = false;

	var logoSpook:FlxSprite;

	var curWacky:Array<String> = [];

	var soncFace:FlxSprite;

	var viggnete:FlxSprite;

	var wackyImage:FlxSprite;

	var easterEggEnabled:Bool = true; //Disable this to hide the easter egg
	var easterEggKeyCombination:Array<FlxKey> = [FlxKey.B, FlxKey.B]; //bb stands for bbpanzu cuz he wanted this lmao
	var lastKeysPressed:Array<FlxKey> = [];

	var mustUpdate:Bool = false;
	
	var titleJSON:TitleData;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	public static var updateVersion:String = '';

	override public function create():Void
	{	
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end
		
		//trace(path, FileSystem.exists(path));
		titleJSON = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));

		/*#if (polymod && !html5)
		if (sys.FileSystem.exists('mods/')) {
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/')) {
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.FileSystem.isDirectory(path)) {
					folders.push(file);
				}
			}
			if(folders.length > 0) {
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}
		#end*/

		Conductor.changeBPM(102);
		
		#if CHECK_FOR_UPDATES
		if(!closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");
			
			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}
			
			http.onError = function (error) {
				trace('error: $error');
			}
			
			http.request();
		}
		#end

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();
		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		if(!initialized && FlxG.save.data != null && FlxG.save.data.fullscreen)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
			//trace('LOADED FULLSCREEN SETTING!!');
		}
		
		ClientPrefs.loadPrefs();
		
		Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;

		if(FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music('menuTheme', 'creepy'));
		}

		#if desktop
		DiscordClient.initialize();
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		});
		#end

		if(alreadyGotHere == false)
		{
			MusicBeatState.switchState(new FlashingState());
		}
	else
		{
			startIntro();
		}
	}
	
	var floatshit:Float = 0;

	function startIntro()
	{
		vcrStuff.setScanlines(false);
		vcrStuff.setPerspective(false);
		vcrStuff.setGlitchModifier(0);
		vcrStuff.setDistortion(true);
		vcrStuff.setNoise(true);
		vcrStuff.setVignette(true);
		vcrStuff.setVignetteMoving(true);

		FlxG.camera.setFilters([new ShaderFilter(vcrStuff.shader)]);

		var blackTHIC:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackTHIC.scrollFactor.set();
		blackTHIC.screenCenter();
		add(blackTHIC);

		logoSpook = new FlxSprite().loadGraphic(Paths.image('logo-title', 'creepy'));
		logoSpook.screenCenter();
		logoSpook.scrollFactor.set();
		add(logoSpook);

		soncFace = new FlxSprite(0, 1000);
		soncFace.frames = Paths.getSparrowAtlas('sonic/sonic_expresions', 'creepy');
		soncFace.animation.addByIndices('hi', 'Xlaugh', [2], '');
		soncFace.animation.addByPrefix('damn', 'Xlaugh');
		soncFace.scrollFactor.set();
		soncFace.animation.play('hi', true);
		soncFace.visible = false;
		add(soncFace);
		soncFace.screenCenter();

		viggnete = new FlxSprite().loadGraphic(Paths.image('black_vignette', 'creepy'));
		viggnete.scrollFactor.set();
		viggnete.screenCenter();
		viggnete.color = FlxColor.RED;
		viggnete.visible = false;
		add(viggnete);

		var vhs:FlxSprite = new FlxSprite();
		vhs.frames = Paths.getSparrowAtlas('vhs_effect', 'creepy');
		vhs.animation.addByPrefix('vhs', 'VHS');
		vhs.scrollFactor.set();
		vhs.alpha = 0.5;
		vhs.setGraphicSize(Std.int(vhs.width * 5));
		vhs.screenCenter();
		vhs.animation.play('vhs');
		// add(vhs);
		
		#if android
addVirtualPad(NONE, A_B);
#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		vcrStuff.update(elapsed);
		floatshit += 0.1;
		if(titleShouldFly == true)
		{
			logoSpook.y += Math.sin(floatshit);
		}

		if(controls.BACK)
		{
			#if desktop
			Application.current.window.close();
			trace('bye!');
			#end
		}

		if(controls.ACCEPT)
		{
			if(Main.iFoundYou_LEAKER == true)
			{
				MusicBeatState.switchState(new NewBuildJoke());
			}
		else
			{
				MusicBeatState.switchState(new MainMenuState());
			}
			trace('go there');
		}
	}

	override function beatHit()
	{
		switch(curBeat)
		{
			case 15:
			{
				soncFace.visible = true;
			}

			case 16:
			{
				FlxG.camera.flash(FlxColor.RED, 0.8);
				soncFace.visible = false;
				FlxG.camera.shake(0.04, 100000000);
				viggnete.visible = true;
				titleShouldFly = true;
				var daTrail:FlxTrail = new FlxTrail(logoSpook, null, 4, 24, 0.3, 0.069);
				add(daTrail);
			}
		}
	}
}
