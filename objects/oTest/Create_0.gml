width  = 314; //room_width - x;
height = 43; //room_height - y;

testString = 2*"Sphinx of black quartz, hear my vow! ";

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertexFormat = vertex_format_end();

vertexBuffer = vertex_create_buffer();
vertex_begin(vertexBuffer, vertexFormat);

var _i = 0;
repeat(string_length(testString))
{
    vertex_position_3d(vertexBuffer, x +  0, y +  0, 0); vertex_texcoord(vertexBuffer, 0, 0);
    vertex_position_3d(vertexBuffer, x + 32, y +  0, 0); vertex_texcoord(vertexBuffer, 1, 0);
    vertex_position_3d(vertexBuffer, x +  0, y + 32, 0); vertex_texcoord(vertexBuffer, 0, 1);
    
    vertex_position_3d(vertexBuffer, x + 32, y +  0, 0); vertex_texcoord(vertexBuffer, 1, 0);
    vertex_position_3d(vertexBuffer, x + 32, y + 32, 0); vertex_texcoord(vertexBuffer, 1, 1);
    vertex_position_3d(vertexBuffer, x +  0, y + 32, 0); vertex_texcoord(vertexBuffer, 0, 1);
    
    ++_i;
}

vertex_end(vertexBuffer);
vertex_freeze(vertexBuffer);

stressCount = 1000;
startTime = current_time;
mode = 4;

global.compile = false;