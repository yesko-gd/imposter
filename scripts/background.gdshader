shader_type canvas_item;

uniform vec3 top_color;
uniform vec3 bottom_color;

void fragment() {
	COLOR.rgb = top_color + UV.y * bottom_color - UV.y * top_color;
}
