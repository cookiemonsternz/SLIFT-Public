shader_type canvas_item;
render_mode world_vertex_coords;

uniform sampler2D polygon;
uniform float texture_scale = 1.0;
uniform vec2 texture_size;
uniform vec2 offset;

void vertex() {
	if (texture(polygon, (VERTEX * texture_scale - offset + (texture_size) / 2.0) / texture_size).r < 0.5){
		COLOR = vec4(0.0);
	} else {
		COLOR = COLOR;
	}
}

void fragment() {
	//COLOR = COLOR;
	//COLOR = texture(polygon, UV * texture_size);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
