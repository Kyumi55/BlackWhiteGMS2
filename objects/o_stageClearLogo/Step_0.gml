/// @description Insert description here
if alpha < 1 // Check if the alpha value is less than 1 (fully opaque)
{
    alpha += fadeSpeed; // Increase the alpha value by the fade speed
    if alpha > 1 // Ensure the alpha value doesn't exceed 1
    {
        alpha = 1;
    }
}