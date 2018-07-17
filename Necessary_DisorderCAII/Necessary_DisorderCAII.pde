CA ca;

// int margin = 50;
// int numFrames = 20;


void setup()
{
    size(400, 400);
    
    int[] ruleset = {0,1,0,1,1,0,1,0};    // An initial rule system
    ca = new CA(ruleset); // Initialize CA
    
    background(0);
}

/*
float pixel_colour(float x, float y, float t)
{
  float result = map( sin( TWO_PI * t), -1, 1, 0, 1 );
  return (255 * result);
}

float pixel_colour_stripes(float x, float y, float t)
{
  float result = map( sin( TWO_PI * (t+0.05*y)), -1, 1, 0, 1 );
  return (255 * result);
}


float pixel_colour_noisevert(float x, float y, float t)
{
  float result = map( sin( TWO_PI * ( t+scalar_field_offset_noisevert( x, y) ) ), -1, 1, 0, 1 );
  return (255 * result);
}


float scalar_field_offset_noisevert(float x, float y)
{
  float perlin_noise_intensity = pow( constrain( map(y, 0.1 * height, height, 0, 1), 0, 1), 2 );
  
  float scale = 0.006;
  float result = -0.05 * y + 20 * ( noise( scale * x, scale * y) - 0.5) * perlin_noise_intensity;
  
  return (result);
}
*/


void draw()
{ 
  
  // float t = 1.0 * (frameCount - 1) % numFrames / numFrames;
  
  ca.render();
  ca.generate();
   
  if (ca.finished()) 
  {   // If we're done, clear the screen, pick a new ruleset and restart
    background(0);
    ca.randomize();
    ca.restart();
  }
  
  // Saves the frame to disk (file out)
  // println(frameCount, "/" , numFrames);
  
}

/*
void draw()
{
  background(0);
  
  float t = 1.0 * (frameCount - 1) % numFrames / numFrames;
  
  // Draws eery pixel
  for(int i = margin; i < width - margin; i++)
  {
    for(int j = margin; j < height - margin; j++)
    {
      // stroke( pixel_colour(i, j, t) );
      // stroke( pixel_colour_stripes(i, j, t) );
      stroke( pixel_colour_noisevert(i, j, t) );
      point(i, j);
    }
  }
  
  // Draw a white rectangle
  stroke(255);
  noFill();
  rect(margin, margin, width - 2 * margin, height -2 * margin);
  
  // Saves the frame to disk (file out)
  println(frameCount, "/" , numFrames);
  saveFrame("frame2###.png");
  
  // Stops when all frames rendered
  if(frameCount == numFrames)
  {
    println("finished");
    stop();
  }
}

*/


void mousePressed() {
  background(0);
  ca.randomize();
  ca.restart();
}
