shader_type canvas_item;
uniform vec4 innerColor: source_color = vec4(0,0,0,1);
uniform vec4 outerColor: source_color = vec4(0,0,0,1);

uniform float scale = 5.0;
uniform float timeMod = 3.0;
uniform float pixelation = 10.0;
uniform float bold = 10.0;
uniform float sharp = 10.0;
uniform float moveSpeed = 1.0;

uniform vec2 focusPoint = vec2(0.5,0.5);

#define iTime (TIME*timeMod)

float rand(vec2 co) {
    // Dot product with large primes, sine, and fract to scramble bits
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec4 permute(vec4 x) {
    return mod(((x * 34.0) + 1.0) * x, 289.0);
}

vec2 fade(vec2 t) {
    // Fade curve for smooth interpolation
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float perlinNoise(vec2 P) {
    // Grid cell coordinates
    vec2 Pi = floor(P);
    vec2 Pf = P - Pi;
    Pi = mod(Pi, 289.0);

    // Permutation
    vec4 ix = vec4(Pi.x, Pi.x + 1.0, Pi.x, Pi.x + 1.0);
    vec4 iy = vec4(Pi.y, Pi.y, Pi.y + 1.0, Pi.y + 1.0);

    vec4 i = permute(permute(ix) + iy);

    // Gradients: 8 directions
    vec4 gx = fract(i / 41.0) * 2.0 - 1.0;
    vec4 gy = abs(gx) - 0.5;
    vec4 tx = floor(gx + 0.5);
    gx = gx - tx;

    vec2 g00 = vec2(gx.x, gy.x);
    vec2 g10 = vec2(gx.y, gy.y);
    vec2 g01 = vec2(gx.z, gy.z);
    vec2 g11 = vec2(gx.w, gy.w);

    // Compute noise contributions from each corner
    vec2 fade_xy = fade(Pf);
    float n00 = dot(g00, Pf);
    float n10 = dot(g10, Pf - vec2(1.0, 0.0));
    float n01 = dot(g01, Pf - vec2(0.0, 1.0));
    float n11 = dot(g11, Pf - vec2(1.0, 1.0));

    // Interpolate
    float nx0 = mix(n00, n10, fade_xy.x);
    float nx1 = mix(n01, n11, fade_xy.x);
    float nxy = mix(nx0, nx1, fade_xy.y);

    return bold * nxy; // Scale to roughly [-1, 1]
}

vec4 shade(float degree){
	return mix(innerColor,outerColor, floor(degree*sharp)/sharp);
}

float pattern(vec2 uv){
	return perlinNoise(uv + perlinNoise(uv+perlinNoise(uv-iTime)) + iTime*moveSpeed)/(1.0);
}

void fragment()
{
	//vec2 focusPoint = vec2(0.3*sin(TIME)+0.5,0.2*cos(TIME)+0.5);
	
	
	vec2 px=pixelation*SCREEN_PIXEL_SIZE;
	vec2 uv = (floor(UV/px)*px);
	
	float focusMod = clamp((1.0-(1.0/(distance(uv, focusPoint)*50.0))), 0, 1);
	uv = uv*focusMod;
	
	
	COLOR = shade(pattern(scale*uv + iTime*moveSpeed));
}