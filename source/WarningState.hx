package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class WarningState extends MusicBeatState
{
    var textOption1:FlxText;
    var textOption2:FlxText;
    var warningText:FlxText;
    var curSelectedCube:FlxSprite;

    override public function create()
    {
        super.create();

        var blackBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        blackBG.scrollFactor.set();
        blackBG.screenCenter();
        add(blackBG);

        warningText = new FlxText(FlxG.width, FlxG.height, 0, "hey dude"
        + "\ndid you know that this is a horror mod?"
        + "\nand theres some gore things but not that strong"
        + "\nyou wanna still playing this?", 35);
        warningText.setFormat(Paths.font('vcr.ttf'), 50, FlxColor.WHITE, LEFT);
        warningText.scrollFactor.set();
        warningText.screenCenter();
        add(warningText);
    }
}