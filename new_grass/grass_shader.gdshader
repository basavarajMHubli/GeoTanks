shader_type spatial;
render_mode unshaded, cull_back;

// Size and density
uniform float blade_height = 0.5;
uniform float blade_width = 0.005;
uniform float density = 0.1; // range 0 to 1

// Colors
uniform vec3 base_color : source_color = vec3(0.0, 0.0, 0.0);
uniform vec3 tip_color : source_color = vec3(0.0, 0.0, 0.0);

varying float height_ratio; // scales the color of blade on height

uniform float wind_strength = 0.2;
uniform float rnd_multiplier = 0.2; // acts as random value to generate grass

float rand(vec2 coordinates) {
	return fract(sin(dot(coordinates.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void vertex() {
	float rnd = rand(VERTEX.xz * rnd_multiplier);
	
	if (rnd > 1.0 - density) {
		// create blade
		float h = blade_height * (0.5 + rand(vec2(VERTEX.z, VERTEX.x)) * 0.5);
		float sway = sin(TIME + VERTEX.x * 2.0 + rnd * 10.0) * wind_strength;
		
		VERTEX.y += h;
		VERTEX.x += sin(rnd * rnd_multiplier) * blade_width + sway;
		VERTEX.z += cos(rnd * rnd_multiplier) * blade_width;
		
		height_ratio = clamp(VERTEX.y / (blade_height * 2.0), 0.2, 1);
	} else {
		// no blade created
		height_ratio = 0.0;
	}
}

void fragment() {
	ALBEDO = mix(base_color, tip_color, height_ratio);
}

