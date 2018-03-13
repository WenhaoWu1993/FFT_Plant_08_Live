class Group {
  ArrayList<Step> steps;
  int index;
  float mainRotation;
  
  Group(int index_) {
    index = index_;
    steps = new ArrayList<Step>();
    mainRotation = index * TWO_PI / divisions;
  }
  
  void addStep() {
    PVector newBase;
    if(floorCount == 0) {
      newBase = new PVector(0, Radius, 0);
    }
    else {
      Step previous = steps.get(floorCount - 1);
      newBase = previous.grow;
    }
    steps.add(new Step(index, floorCount, newBase, frequencyBandsAverage[index]));
    //println(steps.get(floorCount).base);
  }
  
  void display() {

    for(int i = 0; i < steps.size(); i++) {
      Step current = steps.get(i);
      if(i > 0) {
        Step previous = steps.get(i - 1);
        current.base = previous.grow;
      }
      if(i > 0) {
        pushMatrix();
        rotateZ(-mainRotation);
        current.update();
        popMatrix();
      }
      else {
        current.update();
      }
    }
  }
}