class CA {
  
  int frameCount = 0; 

  int[] cells;     // An array of 0s and 1s 
  int generation;  // How many generations?
  int scl;         // How many pixels wide/high is each cell?

  int[] rules;     // An array to store the ruleset, for example {0,1,1,0,1,1,0,1}

  CA(int[] r) {
    rules = r;
    scl = 1;
    cells = new int[width/scl];
    restart();
  }
  
  // Set the rules of the CA
  void setRules(int[] r) {
    rules = r;
  }
  
  // Make a random ruleset
  void randomize() {
    for (int i = 0; i < 8; i++) {
      rules[i] = int(random(2));
    }
  }
  
  // Reset to generation 0
  void restart() {
    for (int i = 0; i < cells.length; i++) {
      cells[i] = 0;
    }
    cells[cells.length/2] = 1;    // We arbitrarily start with just the middle cell having a state of "1"
    generation = 0;
    frameCount = 0;
  }

  // The process of creating the new generation
  void generate() {
    // First we create an empty array for the new values
    int[] nextgen = new int[cells.length];
    // For every spot, determine new state by examing current state, and neighbor states
    // Ignore edges that only have one neighor
    for (int i = 1; i < cells.length-1; i++) {
      int left = cells[i-1];   // Left neighbor state
      int me = cells[i];       // Current state
      int right = cells[i+1];  // Right neighbor state
      nextgen[i] = executeRules(left,me,right); // Compute next generation state based on ruleset
    }
    // Copy the array into current value
    for (int i = 1; i < cells.length-1; i++) {
      cells[i] = nextgen[i];
    }
    //cells = (int[]) nextgen.clone();
    generation++;
  }
  
  
  // Render type adjunct helper functs
  float ease(float p, float g) 
  {
    if (p < 0.5)
      return 0.5 * pow(2*p, g);
    else
      return 1 - 0.5 * pow(2*(1 - p), g);
  }
  
  
  // Render type
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
  
  float scalar_field_perlin_center_offset(float x,float y)
  {
    float distance = dist(x,y,width/2,height/2);
    float perlin_noise_intensity = ease(constrain(map(distance,0,0.3*height,1,0),0,1),2);
   
    float scale = 0.002;
    float result = -0.05*y -0.05*x + 60*(noise(scale*x,scale*y)-0.5)*perlin_noise_intensity;
    return result;
  }
  
  float scalar_field_offset(float x,float y)
  {
    float scale = 0.003;
    float result = 40*noise(scale*x,scale*y);
    return result;
  }
  
  
  // This is the easy part, just draw the cells, fill 255 for '1', fill 0 for '0'
  // void render()
  void render()
  {
    int margin = 50;
    int numFrames = 200;
    float t = 1.0 * (frameCount - 1) % numFrames / numFrames;
    
    //for(int i = margin; i < width - margin; i++)
    //{
      for(int j = margin; j < width - margin; j++)
      {
 
        for (int x = 0; x < cells.length; x++) 
        {
          if (cells[x] == 1) 
          {
            // fill(255);
            // stroke(255);
            // stroke( pixel_colour(x, j, t) );
            stroke( pixel_colour_noisevert(x, j, t) );
            // point(x, j); // causes horizontal noise image to be set - not wanted
            // println(i, j, cells[x]);
           } else 
            { 
            // fill(0);
            
            // stroke( pixel_colour_noisevert(x, j, t) );
            // point(x, j);
            // println(j, cells[x]);
           }
      
           //noStroke();
           rect(x*scl,generation*scl, scl,scl);
           // noStroke();
           // println(x);
        }
        
      }
    //}
    
    //stroke(255);
    //noFill();
    // rect(margin, margin, width - 2 * margin, height -2 * margin);
  
    // Saves the frame to disk (file out)
    println(frameCount, "/" , numFrames);
    saveFrame("frame2###.png");
    
  
    // Stops when all frames rendered
    if(frameCount == numFrames)
    {
      println("finished");
      stop();
      // frameCount = 0;
    }
    
    frameCount++;
    
    // println(frameCount, "/" , numFrames);
    // frameCount = 0;
  }
  
  // Implementing the Wolfram rules
  // Could be improved and made more concise, but here we can explicitly see what is going on for each case
  int executeRules (int a, int b, int c) {
    if (a == 1 && b == 1 && c == 1) { return rules[0]; }
    if (a == 1 && b == 1 && c == 0) { return rules[1]; }
    if (a == 1 && b == 0 && c == 1) { return rules[2]; }
    if (a == 1 && b == 0 && c == 0) { return rules[3]; }
    if (a == 0 && b == 1 && c == 1) { return rules[4]; }
    if (a == 0 && b == 1 && c == 0) { return rules[5]; }
    if (a == 0 && b == 0 && c == 1) { return rules[6]; }
    if (a == 0 && b == 0 && c == 0) { return rules[7]; }
    return 0;
  }
  
  // The CA is done if it reaches the bottom of the screen
  boolean finished() {
    if (generation > height/scl) {
       return true;
    } else {
       return false;
    }
  }
}