# Windows Terminal Shaders

A collection of HLSL shaders for Windows Terminal. These shaders create beautiful visual effects to enhance your terminal experience.

## Fractal Shader

The featured shader creates a Mandelbrot fractal visualization with smooth coloring and animation. This shader demonstrates how to:

- Convert GLSL shader code to HLSL for Windows Terminal
- Implement HSV to RGB color space conversion 
- Create dynamic zooming and movement
- Apply proper color correction with sRGB conversion

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
