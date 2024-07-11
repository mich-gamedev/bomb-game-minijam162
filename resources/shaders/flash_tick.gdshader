shader_type canvas_item;

uniform bool enabled = true;
uniform float tick_rate: hint_range(0.0, 10.0, 0.01);
uniform vec4 flash_color: source_color;

void fragment() {
	float time_wrapped = mod(TIME, tick_rate * 2.0);
	vec4 result = mix(COLOR, flash_color, float(time_wrapped > tick_rate) * float(enabled));
	COLOR = vec4(result.r, result.g, result.b, COLOR.a);
}
