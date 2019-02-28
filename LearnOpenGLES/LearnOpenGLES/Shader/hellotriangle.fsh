#version 300 core
precision lowp float;
out vec4 FragColor;
uniform vec4 ourColor; //set color in code with cpu
void main()
{
    FragColor = ourColor;
}
