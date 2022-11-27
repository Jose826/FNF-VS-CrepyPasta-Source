package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;
import source.shaders.*;
import openfl.filters.ShaderFilter;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	var vcrStuff:VCRDistortionEffect = new VCRDistortionEffect();

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		vcrStuff.setScanlines(false);
		vcrStuff.setPerspective(false);
		vcrStuff.setGlitchModifier(0);
		vcrStuff.setDistortion(true);
		vcrStuff.setNoise(true);
		vcrStuff.setVignette(true);
		vcrStuff.setVignetteMoving(true);

		FlxG.camera.setFilters([new ShaderFilter(vcrStuff.shader)]);

		#if MODS_ALLOWED
		//trace("finding mod shit");
		for (folder in Paths.getModDirectories())
		{
			var creditsFile:String = Paths.mods(folder + '/data/credits.txt');
			if (FileSystem.exists(creditsFile))
			{
				var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
				for(i in firstarray)
				{
					var arr:Array<String> = i.replace('\\n', '\n').split("::");
					if(arr.length >= 5) arr.push(folder);
					creditsStuff.push(arr);
				}
				creditsStuff.push(['']);
			}
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name(nah) - Description - Link - BG Color(nah)
			['The Dumb Crew'],
			['Mushi', 'mushi', 'Original Idea/Main Coder', 'https://twitter.com/mushi_alt', null],
			['Deadwin151', 'deadwin151', 'Main Artist', 'https://twitter.com/DeadwinO', null],
			['CharlesTheRandom', 'charles', 'Artist/Sketcher', 'https://www.youtube.com/channel/UCwuXrfAtXcwkY5fgMfnK7Qg', null],
			['Slingminart', 'sling', 'Charter', 'https://twitter.com/slingminart', null],
			['Shteque', 'lol', 'Main Musician', 'https://twitter.com/lolmanmusicman', null],
			['Arne', 'arne', 'Artist', 'https://www.youtube.com/channel/UC0CsB40Bqdn3J50kUissIGw', null],
			['Jonnytest', 'jonny', 'Artist', 'https://twitter.com/suprmach199', null],
			['Ratfrik', 'rat', 'Artist', 'https://twitter.com/suprmach199', null],
			['Grimbo Yea', 'grimbo', 'Voice Actor', 'https://twitter.com/YeaGrimbo', null],
			['Salted Pearls', 'salted', 'Voice Actor', 'https://twitter.com/salted_pearls', null],
			['MaskyDude207', 'masky', 'Artist/Animator', 'https://twitter.com/Cr4zy_Akuma', null],
			['Trizztan', 'trizztan', 'Artist', 'https://twitter.com/TRIZZTAN_XL', null],
			['Seberster', 'seberster', 'Musician', 'https://twitter.com/Seberster', null],
			['Monero', 'monero', 'Musician', 'https://c.tenor.com/xZ8lVLYJ050AAAAd/monke-monkey.gif', null],
			['Epm34', 'epm', 'Artist', 'https://twitter.com/EPM341', null],
			['Offi99', 'offi', 'Icon Artist', 'https://twitter.com/Offi6969', null],
			['PolesCC', 'poles', 'Coder', 'https://twitter.com/PolesCCX', null],
			['Banana', 'platano', 'Musician', 'https://twitter.com/banana_musician', null],
			['TheBoredArtist', 'bored', 'Artist', 'https://twitter.com/TheBoredArtist1', null],
			['Elemenopee', 'ele', 'Artist', 'https://instagram.com/elemenopee_two?utm_medium=copy_link', null],
			['judg3', 'jud', 'Sketcher', 'https://twitter.com/le_jug3', null],
			['magbross', 'mag', 'Musician', 'https://twitter.com/MagBros78', null],
			['Psych Engine Team'],
			['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',						'https://twitter.com/Shadow_Mario_',	'FFDD33'],
			['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',					'https://twitter.com/river_oaken',		'C30085'],
			['bb-panzu',			'bb-panzu',			'Additional Programmer of Psych Engine',				'https://twitter.com/bbsub3',			'389A58'],
			[''],
			['Engine Contributors'],
			['shubs',				'shubs',			'New Input System Programmer',							'https://twitter.com/yoshubs',			'4494E6'],
			['SqirraRNG',			'gedehari',			'Chart Editor\'s Sound Waveform base',					'https://twitter.com/gedehari',			'FF9300'],
			['iFlicky',				'iflicky',			'Delay/Combo Menu Song Composer\nand Dialogue Sounds',	'https://twitter.com/flicky_i',			'C549DB'],
			['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',							'https://twitter.com/polybiusproxy',	'FFEAA6'],
			['Keoiki',				'keoiki',			'Note Splash Animations',								'https://twitter.com/Keoiki_',			'FFFFFF'],
			[''],
			["Funkin' Crew"],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",					'https://twitter.com/ninja_muffin99',	'F73838'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",						'https://twitter.com/PhantomArcade3K',	'FFBB1B'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",						'https://twitter.com/evilsk8r',			'53E52C'],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",						'https://twitter.com/kawaisprite',		'6475F3']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			/*
			if(isSelectable) {
				optionText.x -= 70;
			}
			*/
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				// iconArray.push(icon);
				// add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		// bg.color = getCurrentBGColor();
		// intendedColor = bg.color;

		var vhs:FlxSprite = new FlxSprite();
		vhs.frames = Paths.getSparrowAtlas('vhs_effect', 'creepy');
		vhs.animation.addByPrefix('vhs', 'VHS');
		vhs.scrollFactor.set();
		vhs.alpha = 0.5;
		vhs.setGraphicSize(Std.int(vhs.width * 3.5));
		vhs.screenCenter();
		vhs.animation.play('vhs');
		// add(vhs);

		changeSelection();
		
		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		vcrStuff.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
