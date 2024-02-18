/// @param materialAlias

function __scribble_class_vertex_buffer(_material) constructor
{
    static __scribble_state = __scribble_get_state();
    static __gc_vbuff_refs  = __scribble_get_cache_state().__gc_vbuff_refs;
    static __gc_vbuff_ids   = __scribble_get_cache_state().__gc_vbuff_ids;
    
    static __vertex_format = undefined;
    if (__vertex_format == undefined)
    {
        vertex_format_begin();
        vertex_format_add_position_3d();                                  //12 bytes
        vertex_format_add_normal();                                       //12 bytes
        vertex_format_add_colour();                                       // 4 bytes
        vertex_format_add_texcoord();                                     // 8 bytes
        vertex_format_add_custom(vertex_type_float3, vertex_usage_color); //12 bytes
        __vertex_format = vertex_format_end();                             //48 bytes per vertex, 144 bytes per tri, 288 bytes per glyph
    }
    
    //Try to use the material as a font name
    if (is_struct(_material))
    {
        __material = _material;
    }
    else
    {
        //If we can't find a font using this material alias then presume the alias is a texture pointer
        if (!is_ptr(_material))
        {
            __scribble_error("Fallback material name must be a pointer (typeof=", typeof(_material), ")");
        }
        
        //Create a new placeholder material for this particular texture
        __material = new __scribble_class_material(_material);
        __material.__set_texture(_material);
    }
    
    __vertex_buffer = vertex_create_buffer(); //TODO - Can we preallocate this? i.e. copy "for text" system we had in the old version
    vertex_begin(__vertex_buffer, __vertex_format);
    
    if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Adding vertex buffer ", __vertex_buffer, " to tracking");
    array_push(__gc_vbuff_refs, weak_ref_create(self));
    array_push(__gc_vbuff_ids,  __vertex_buffer);
    
    
    
    static __submit = function(_double_draw)
    {
        static _u_fRenderFlags = shader_get_uniform(__shd_scribble, "u_fRenderFlags");
        static _u_vTexel       = shader_get_uniform(__shd_scribble, "u_vTexel"      );
        static _u_fSDFData     = shader_get_uniform(__shd_scribble, "u_fSDFData"    );
        
        var _render_flag_value = __scribble_state.__render_flag_value;
        
        with(__material)
        {
            gpu_set_tex_filter(__bilinear);
            
            //Reset relevant render flags (baked effects, SDF, and double draw)
            _render_flag_value = (_render_flag_value & (~(0x1C)));
            
            if (__sdf)
            {
                //Set the "SDF" render flag
                _render_flag_value |= 0x08;
            
                //Set shader uniforms unique to the SDF shader
                shader_set_uniform_f(_u_vTexel, __texel_width, __texel_height);
                shader_set_uniform_f(_u_fSDFData, __sdf_spread, __sdf_softness, __sdf_thickness_offset);
            }
            else
            {
                //Set the "baked effects" render flag
                _render_flag_value |= (__baked_effects << 2); // (sets bit 0x04)
            }
            
            shader_set_uniform_f(_u_fRenderFlags, _render_flag_value);
            vertex_submit(other.__vertex_buffer, pr_trianglelist, __texture);
            
            if (_double_draw && (__sdf || __baked_effects))
            {
                //Set the "double draw" render flag
                shader_set_uniform_f(_u_fRenderFlags, _render_flag_value | 0x10);
                vertex_submit(other.__vertex_buffer, pr_trianglelist, __texture);
            }
        }
    }
    
    static __flush = function()
    {
        vertex_delete_buffer(__vertex_buffer);
        
        var _index = __scribble_array_find_index(__gc_vbuff_ids, __vertex_buffer);
        if (_index >= 0)
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Manually removing vertex buffer ", __vertex_buffer, " from tracking");
            array_delete(__gc_vbuff_refs, _index, 1);
            array_delete(__gc_vbuff_ids,  _index, 1);
        }
    }
}