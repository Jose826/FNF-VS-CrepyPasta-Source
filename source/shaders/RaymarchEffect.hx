package source.shaders;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;
import flixel.math.FlxPoint;

// https://www.shadertoy.com/view/WtGXDD

class RaymarchEffect {
    var rad = Math.PI/180;
    public var shader:RaymarchShader = new RaymarchShader();
    public function new(){
      shader.yaw.value = [0];
      shader.pitch.value = [0];
    }
    public function addYaw(yaw:Float){
      shader.yaw.value[0]+=yaw*rad;
    }
    public function setYaw(yaw:Float){
      shader.yaw.value[0]=yaw*rad;
    }
  
    public function addPitch(pitch:Float){
      shader.pitch.value[0]+=pitch*rad;
    }
    public function setPitch(pitch:Float){
      shader.pitch.value[0]=pitch*rad;
    }
  }
  
  class RaymarchShader extends FlxShader {
    @:glFragmentSource('
      #pragma header
  
      // "RayMarching starting point"
      // Modified by Nebula_Zorua
      // by Martijn Steinrucken aka The Art of Code/BigWings - 2020
      // The MIT License
      // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, moy, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
      // Email: countfrolic@gmail.com
      // Twitter: @The_ArtOfCode
      // YouTube: youtube.com/TheArtOfCodeIsCool
      // Facebook: https://www.facebook.com/groups/theartofcode/
      //
      // You can use this shader as a template for ray marching shaders
  
      #define MAX_STEPS 100
      #define MAX_DIST 100.
      #define SURF_DIST 0.01
  
      uniform float yaw;
      uniform float pitch;
  
      mat2 Rot(float a) {
          float s=sin(a), c=cos(a);
          return mat2(c, -s, s, c);
      }
  
      float sdBox(vec3 p, vec3 s) {
          p = abs(p)-s;
          return length(max(p, 0.))+min(max(p.x, max(p.y, p.z)), 0.);
      }
  
      float GetDist(vec3 p) {
          float d = sdBox(p, vec3(1.,1.,0));
  
          return d;
      }
  
  
  
      float RayMarch(vec3 ro, vec3 rd) {
          float dO=0.;
  
          for(int i=0; i<MAX_STEPS; i++) {
              vec3 p = ro + rd*dO;
              float dS = GetDist(p);
              dO += dS;
              if(dO>MAX_DIST || abs(dS)<SURF_DIST) break;
          }
  
          return dO;
      }
  
      vec3 GetNormal(vec3 p) {
          float d = GetDist(p);
          vec2 e = vec2(.001, 0);
  
          vec3 n = d - vec3(
              GetDist(p-e.xyy),
              GetDist(p-e.yxy),
              GetDist(p-e.yyx));
  
          return normalize(n);
      }
  
      vec3 GetRayDir(vec2 uv, vec3 p, vec3 l, float z) {
          vec3 f = normalize(l-p),
              r = normalize(cross(vec3(0,1,0), f)),
              u = cross(f,r),
              c = f*z,
              i = c + uv.x*r + uv.y*u,
              d = normalize(i);
          return d;
      }
  
      void main()
      {
          vec2 uv = openfl_TextureCoordv - vec2(0.5);
          vec3 ro = vec3(0, 0., -2);
  
          ro.xz *= Rot(yaw);
          ro.yz *= Rot(pitch);
  
          vec3 rd = GetRayDir(uv, ro, vec3(0,0.,0.), 1.);
          vec4 col = vec4(0);
  
          float d = RayMarch(ro, rd);
  
          if(d<MAX_DIST) {
              vec3 p = ro + rd * d;
              vec3 n = GetNormal(p);
              uv = vec2(p.x,p.y) * .5 + vec2(0.5);
              col = flixel_texture2D(bitmap,uv);
          }
          gl_FragColor = col;
      }
    ')
    public function new()
    {
      super();
    }
  }