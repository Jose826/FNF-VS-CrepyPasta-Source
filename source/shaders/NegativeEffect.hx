package source.shaders;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;
import flixel.math.FlxPoint;
import openfl.display.Shader;

class NegativeEffect
{
    public var shader:NegativeEffectShader = new NegativeEffectShader();

    public function new()
    {
        shader.iResolution.value = [Lib.current.stage.stageWidth, Lib.current.stage.stageHeight];
    }
}

class NegativeEffectShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header
    uniform vec3 iResolution;
    uniform bool invertActivated;

    void main()
    {
        vec2 uv = ${Shader.vTexCoord}.xy / iResolution.xy;
        vec4 color = texture2D(${Shader.uSampler}, uv);
            
        color.xyz = vec3(1, 1, 1) - color.xyz;

        gl_FragColor = currentColor;
    }
    ')

    public function new(){ super(); }
}