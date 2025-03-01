shader_type canvas_item;
uniform int lvl=0;
void fragment(){
    vec4 col=texture(TEXTURE,UV);
    if(lvl==0){
        float avg=(col.r+col.g+col.b)/3.0;
        COLOR=vec4(avg,avg,avg,col.a);
    }else if(lvl==1){
        COLOR=vec4(col.r,0.0,0.0,col.a);
    }else if(lvl==2){
        COLOR=vec4(col.rg,0.0,col.a);
    }else{
        COLOR=col;
    }
}
