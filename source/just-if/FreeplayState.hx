package;

import openfl.filters.ShaderFilter;
import flixel.FlxG;
import flixel.addons.display.FlxSpriteAniRot;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import WeekData.WeekFile;
import source.shaders.VCRDistortionEffect;

using StringTools;

class FreeplayState extends MusicBeatState
{
	static var curSelected:Int = 0;
	var grpSongs:FlxTypedGroup<Alphabet>;
	var characterUI:CharacterInfoUi;
	var vcrStuff:VCRDistortionEffect = new VCRDistortionEffect();

	override public function create()
	{
		super.create();
		
		vcrStuff.setScanlines(false);
		vcrStuff.setPerspective(false);
		vcrStuff.setGlitchModifier(0);
		vcrStuff.setDistortion(true);
		vcrStuff.setNoise(true);
		vcrStuff.setVignette(true);
		vcrStuff.setVignetteMoving(true);

		FlxG.camera.setFilters([new ShaderFilter(vcrStuff.shader)]);

		var blueBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
	}
}

class CharacterInfoUi extends FlxSpriteGroup
{
	public var char:Character;
	public var icon:HealthIcon;
	var charName:FlxText;
	var bg:FlxSprite;
	var bgBorder:FlxSprite;

	public function new(classX:Float = 0, classY:Float = 0, songCharacter:String = 'dad', songIcon:String = 'face')
	{
		super();
		this.x = classX;
		this.y = classY;
		updateUI(songCharacter, songIcon);
	}
	
	public function updateUI(newChar:String = 'dad', newIcon:String = 'face')
	{
		remove(bgBorder);
		remove(bg);
		remove(char);
		remove(charName);
		remove(icon);
		// all is goddamn MESSY
		char = new Character(this.x, this.y, newChar, false);
		bg = new FlxSprite(char.x, char.y).makeGraphic(10, 10, /**it would update later chill**/ FlxColor.GRAY);

		bgBorder = new FlxSprite(bg.x, bg.y).makeGraphic(0, 0, FlxColor.YELLOW);

		bg.setGraphicSize(Std.int(char.width * 1.8)); // like i said
		bgBorder.setGraphicSize(Std.int(bg.width * 1.5));
		bg.alpha = 0.8;

		charName = new FlxText(bgBorder.width * 0.7, bgBorder.height + 5, 0, StringTools.replace(char.curCharacter, '-', ' '), 32);
		charName.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, LEFT);
		add(charName);

		icon = new HealthIcon(char.healthIcon);
		icon.animation.curAnim.curFrame = 0;

		add(bgBorder);
		add(bg);
		add(char);
		add(charName);
		add(icon);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var defIconMult:Float = FlxMath.lerp(1, icon.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		icon.scale.set(defIconMult, defIconMult);
		icon.updateHitbox();
	}

	public function doTheBeat(iconBopSize:Float = 1.2)
	{
		char.playAnim('idle');
		icon.scale.set(iconBopSize, iconBopSize);
		icon.updateHitbox();
	}
}