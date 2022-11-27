package source.shaders;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;
import flixel.math.FlxPoint;

class WaveHeatEffect
{
    public var shader:WaveHeatSource = new WaveHeatSource();

    public function new()
    {
        shader.iTime.value = [0];
    }

    public function update(elapsed:Float){
        shader.iTime.value[0] += elapsed;
    }
}

class WaveHeatSource extends FlxShader
{
    @:glFragmentSource('
    uniform float iTime;

    void main(){
        vec2 uv = openfl_TextureCoordv;
       
        for(float i = 1.0; i < 8.0; i++){
        uv.y += i * 0.1 / i * 
          sin(uv.x * i * i + iTime * 0.5) * sin(uv.y * i * i + iTime * 0.5);
      }
        
       vec3 col;
       col.r  = uv.y - 0.1;
       col.g = uv.y + 0.3;
       col.b = uv.y + 0.95;
        
       gl_FragColor = vec4(col,1.0);
    }
    ')

    public function new()
    {
        super();
    }
}