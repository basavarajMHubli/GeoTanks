shader_type spatial;

uniform vec3 base_color : source_color = vec3(0.0, 0.0, 0.0);
uniform vec3 glow_color : source_color = vec3(1.0, 1.0, 0.0);
uniform float glow_strength = 10.0;
uniform float fresnel_power = 5.0;

void fragment() {
    ALBEDO = base_color;

    float fresnel = pow(1.0 - dot(NORMAL, VIEW), fresnel_power);
    EMISSION = glow_color * fresnel * glow_strength;
}
