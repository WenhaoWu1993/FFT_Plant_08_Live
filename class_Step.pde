class Step {
  int groupIndex, stepIndex;
  
  float mainRotation;  
  float swingRotation;
  float swingSpeed;
  
  PVector base, grow;
  float amp;
  //float opacity;
  float heigh;
  
  Step(int groupIndex_, int stepIndex_, PVector base_, float amp_) {
    groupIndex = groupIndex_;
    stepIndex = stepIndex_;
    
    base = base_;
    
    mainRotation = groupIndex * TWO_PI / divisions;
    swingRotation = random(PI / 4, HALF_PI);
    swingSpeed = random(0.005, 0.01);
    
    amp = amp_;
  }
  
  void update() {
    if(swingRotation < PI / 4 || swingRotation > HALF_PI) {
      swingSpeed *= -1;
    }
    swingRotation += swingSpeed;
    
    pushMatrix();
    
    translate(base.x, base.y, base.z);
    
    if(stepIndex > 0) {
      //rotateX(-mainRotation);
      rotateZ(mainRotation);
    }
    
    rotateX(swingRotation);
    
    float x = modelX(0, _height, 0);
    float y = modelY(0, _height, 0);
    float z = modelZ(0, _height, 0);
        
    noStroke();
    
    float h = map(groupIndex, 0, divisions, 150, 0);
    float ra = amp / frequencyBandsMax[groupIndex];
    float s = map(ra, 0, 0.5, 0, 255);    
    if(groupIndex == 7) h = 0;
    
    heigh += 0.5;
    if(heigh > _height) heigh = _height;
    
    fill(h, s, 255);
    rect(-Length / 2, 0, Length, heigh);
    
    popMatrix();
    
    grow = new PVector(x, y, z);
  }
  
}