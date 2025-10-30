shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 5.0) = 1.8;
uniform float blur_size : hint_range(1.0, 8.0) = 3.0;
uniform float brightness_threshold : hint_range(0.0, 1.0) = 0.3;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 original_color = texture(screen_texture, SCREEN_UV);
	
	// Create bloom by sampling surrounding pixels
	vec3 bloom = vec3(0.0);
	float total_weight = 0.0;
	
	// Adjust blur based on your viewport size (640x360)
	vec2 pixel_size = vec2(1.0 / 640.0, 1.0 / 360.0);
	
	// Gaussian-like blur for smooth glow
	for(float x = -blur_size; x <= blur_size; x += 1.0) {
		for(float y = -blur_size; y <= blur_size; y += 1.0) {
			vec2 offset = vec2(x, y) * pixel_size;
			vec4 sample_color = texture(screen_texture, SCREEN_UV + offset);
			
			// Calculate brightness
			float brightness = dot(sample_color.rgb, vec3(0.299, 0.587, 0.114));
			
			// Only bloom bright pixels (above threshold)
			if(brightness > brightness_threshold) {
				// Distance-based weight for smoother glow
				float distance = length(vec2(x, y));
				float weight = 1.0 / (1.0 + distance);
				
				// Keep the original color of the sample
				bloom += sample_color.rgb * weight * brightness;
				total_weight += weight;
			}
		}
	}
	
	if(total_weight > 0.0) {
		bloom /= total_weight;
	}
	
	// Apply glow intensity
	bloom *= glow_intensity;
	
	// Combine original with bloom (preserving original colors)
	COLOR = vec4(original_color.rgb + bloom, original_color.a);
}