# Windows Terminal Shaders

A collection of HLSL shaders for Windows Terminal. These shaders create beautiful visual effects to enhance your terminal experience.

## Fractal Shader

The featured shader creates a Mandelbrot fractal visualization with smooth coloring and animation. This shader demonstrates how to:

- Convert GLSL shader code to HLSL for Windows Terminal
- Implement HSV to RGB color space conversion 
- Create dynamic zooming and movement
- Apply proper color correction with sRGB conversion

## Credits

This project was written by Claude and Scott. Mark Russinovich was also there. (100% THE IDEA MAN)

## Citations

The code in this project contains components from the following sources:

- GLSL to HLSL adapters from [patriksvensson/machine](https://github.com/patriksvensson/machine/blob/35e7bc630a745366ef6dee0d7b4fb1497847ce58/windows/Terminal/Shaders/happy.hlsl)
- HSV to RGB conversion from [blueset/project-lyricova](https://github.com/blueset/project-lyricova/blob/396996b322cf78c32422c7af7f644c0bb8b4e51f/packages/jukebox/src/components/public/BackgroundCanvas/blur-album.ts)
- sRGB color correction from [nmz (@stormoid)](https://www.shadertoy.com/view/NdfyRM) via multiple sources:
  - [jseaton/glow](https://github.com/jseaton/glow/blob/eed52cab775e890029d15098a87dbfd0fa002f5a/shaders/spiralsurprise.glsl)
  - [colin3dmax/CocosCreator](https://github.com/colin3dmax/CocosCreator/blob/11dab639ecb69c57bf461da492e699589f335dab/Shader/assets/resources/Effect32.fs.glsl)
  - [blueset/project-lyricova](https://github.com/blueset/project-lyricova/blob/396996b322cf78c32422c7af7f644c0bb8b4e51f/packages/jukebox/src/components/public/BackgroundCanvas/monterey-wannabe.ts)
- Additional shader structure from [Hammster/windows-terminal-shaders](https://github.com/Hammster/windows-terminal-shaders/blob/066d6c5a04929466377b5c19882b0c1fd11f3f87/damask.hlsl)


## License

This project is licensed under the WTFPL (Do What The F*ck You Want To Public License)


## Usage

1. Save the shader file (.hlsl) to a location on your computer
2. Open Windows Terminal settings.json
3. Add the shader to your profile:

```json
{
    "profiles": {
        "defaults": {},
        "list": [
            {
                "name": "Windows PowerShell",
                "experimental.pixelShaderPath": "path/to/fractal.hlsl"
            }
        ]
    }
}
