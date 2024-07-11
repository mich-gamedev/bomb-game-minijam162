shader_type canvas_item;

uniform bool toggle;
uniform float tolerance : hint_range(0.0, 1.0, 0.01);

uniform vec4 OLDCOLOR1 : source_color;
uniform vec4 OLDCOLOR2 : source_color;
uniform vec4 OLDCOLOR3 : source_color;
uniform vec4 OLDCOLOR4 : source_color;
uniform vec4 OLDCOLOR5 : source_color;

uniform vec4 NEWCOLOR1 : source_color;
uniform vec4 NEWCOLOR2 : source_color;
uniform vec4 NEWCOLOR3 : source_color;
uniform vec4 NEWCOLOR4 : source_color;
uniform vec4 NEWCOLOR5 : source_color;

void fragment() {
    if (toggle)
	{
		vec4 curr_color = texture(TEXTURE,UV); 
	
	
    	if (distance(curr_color, OLDCOLOR1) < tolerance)
		{
        COLOR = NEWCOLOR1;
   	 }
		else if (distance(curr_color, OLDCOLOR2) < tolerance)
		{
   	     COLOR = NEWCOLOR2;
   	 }
		else if (distance(curr_color, OLDCOLOR3) < tolerance)
		{
   	     COLOR = NEWCOLOR3;
   	 }
		else if (distance(curr_color, OLDCOLOR4) < tolerance)
		{
   	     COLOR = OLDCOLOR4;
   	 }else if (distance(curr_color, OLDCOLOR5) < tolerance)
		{
			COLOR = NEWCOLOR5;
		}else
		{
			COLOR = curr_color;
		}
	}
}

