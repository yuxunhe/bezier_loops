ArrayList<Float> storage = new ArrayList<Float>();
boolean initStorage = true;
//@returns a, b, c in the equation ax + by = c
float[] findLine(float x1, float x2, float y1, float y2) {
  float a = y2 - y1;
  float b = x1 - x2;
  float c = a * x1 + b * y1;
  float[] temp = {a, b, c};
  return temp;
}


float lessRandom(float x, float y, int depth) {
  if (depth == 0) {
    return random(x, y);
  } else if (depth == 1){
    float mid = (x + y)/2;
    float x1 = random(x, mid);
    float y1 = random(mid, y);
    return (x1 + y1) /2;
  } else {
    float mid = (x + y)/2;
    float x1 = random(x, mid);
    float y1 = random(mid, y);
    return lessRandom(x1, y1, depth-1);
  }
}

float[] findRandomPointBetweenPoints(float x1, float x2, float y1, float y2) {
  float[] line = findLine(x1, x2, y1, y2);
  float a = line[0];
  float b = line[1];
  float c = line[2];
  float mid = (x1 + x2) /2;
  //float randx = lessRandom(x1, x2, 6);
  float randx = x1 + (x2-x1) * random(0.4, 0.65);
  float randy = (c - (a * randx)) / b;
  float[] temp = {randx, randy};
  return temp;
  
}

//@returns the determinant. 
float findDet(float x1, float x2, float y1, float y2) {
  return (x1 * y2) - (x2 * y1);
}

//@returns the intersection of the two lines a1x + b1y = c1, a2x + b2y = c2. 
float[] findIntersection(float a1, float a2, float b1, float b2, float c1, float c2) {
  float x = findDet(c1, c2, b1, b2) / findDet(a1, a2, b1, b2);
  float y = findDet(a1, a2, c1, c2) / findDet(a1, a2, b1, b2);
  float[] temp = {x, y};
  return temp;
}

//@returns the intersection {x,y} from the two lines respectively containing (x1, y1), (x2, y2) and (x3, y3), (x4, y4)

float[] findIntersectionFromPoints(float x1, float x2, float x3, float x4, float y1, float y2, float y3, float y4) {
  float[] line1 = findLine(x1, x2, y1, y2);
  float[] line2 = findLine(x3, x4, y3, y4);
  float a1 = line1[0];
  float b1 = line1[1];
  float c1 = line1[2];
  float a2 = line2[0];
  float b2 = line2[1];
  float c2 = line2[2];
  float[] dot = findIntersection(a1, a2, b1, b2, c1, c2);
  return dot;
}

//@returns the midpoint of (x1, y1) and (x2, y2)
float[] findMidpoint(float x1, float x2, float y1, float y2) {
  float x = (x2 + x1)/2;
  float y = (y2 + y1)/2;
  float[] temp = {x, y};
  return temp;
}


color pick_color_from_palette() {
  color[] palette1 = {color(178, 28, 88), color(255, 235, 40), color(255, 15, 111), color(32, 174, 204), color(1, 147, 178)};
  color[] palette2 = {color(60, 127, 111), color(196, 255, 241), color(119, 255, 222), color(200, 200, 169), color(131, 174, 155)};
  color[] palette3 = {color(246, 154, 154), color(239, 69, 102), color(249, 205, 174), color(200, 200, 169), color(131, 174, 155)};
  color[] palette4 = {color(233, 72, 88), color(243, 163, 42), color(130, 191, 110), color(60, 180, 203), color(22, 67, 75)};
  int rand_index = int(random(0, palette4.length));
  color temp = palette4[rand_index];
  return temp;
}

//r: radius of middle circle
//seg_num: number of segments
//centX, centY: center of the middle circle (and all the other circles) 

void drawLoop(float r, int seg_num, float centX, float centY) {
  ArrayList<float[]> pointList = new ArrayList<float[]>(); //list of points on the middle circle
  ArrayList<float[]> outerPointList = new ArrayList<float[]>(); //list of points on the outer circle
  ArrayList<float[]> innerPointList = new ArrayList<float[]>(); //list of calculated points enclosed by the middle circle
  //stroke(0);
  //strokeWeight(5);
  float r1 = r; //circle
  float r2 = r1 * 1.5; //outer circle 
  float rad_step = radians(360/seg_num); //radian difference for every segment 
  float rad = 0;  //initialization
  int step_count = 0;
  for (int i = 0; i < seg_num; i++) { //increment on pixel level
    //stroke(0);
    float x = centX + (r1 * cos(rad));  
    float y = centY + (r1 * sin(rad));
    //point(x, y);
    float[] temp = {x, y};
    pointList.add(temp); //(x, y) is on the middle circle
    if (step_count % 2 == 0) { //for every even step
      float nextrad = rad + rad_step; 
      float rand_rad = 0;
      if (initStorage) {
        float average = (rad + nextrad) /2;
        float lower = (average - rad) /2 + rad;
        float upper = nextrad - ((nextrad - average) / 2);
        rand_rad = random(lower, upper); //randomizes radian; needs to improve 
        storage.add(rand_rad);
      } else {
        rand_rad = storage.get(i/2) + random(-0.01, 0.01);
      }
      //float rand_rad = random(rad*1.05, nextrad*0.95); //randomizes radian; needs to improve 
      //float rand_rad = (rad + nextrad)/2; //radian midpoint of the segment 
      float x2 = centX + (r2 * cos(rand_rad));
      float y2 = centY + (r2 * sin(rand_rad));
      //stroke(255, 0, 0);
      //point(x2, y2);
      float[] temp2 = {x2, y2}; //(x2, y2) is on the outer circle
      outerPointList.add(temp2);
    }
    //print(storage);
    rad += rad_step;
    step_count ++;
  }
  initStorage = false;
  //PFont f = createFont("Arial",16,true); 
  //textFont(f,16);
  //fill(0);
  for (int i = 0; i < outerPointList.size(); i+=1) {
    float x1 = outerPointList.get(i)[0]; 
    float y1 = outerPointList.get(i)[1];
    //text("p1",x1,y1);
    float x2 = pointList.get(i * 2 +1)[0];
    float y2 = pointList.get(i * 2 +1)[1];
    //text("p2",x2,y2);
    float x3 = outerPointList.get((i+1) % outerPointList.size())[0];
    float y3 = outerPointList.get((i+1) % outerPointList.size())[1];
    //text("p3",x3,y3);
    float x4 = pointList.get((i * 2 +2) % pointList.size())[0];
    float y4 = pointList.get((i * 2 +2) % pointList.size())[1];
    //text("p4",x4,y4);

    //midpoint calculations for outer points
    float x5 = pointList.get(i * 2)[0];
    float y5 = pointList.get(i * 2)[1];
    
    float x6 = pointList.get(i * 2 +1)[0];
    float y6 = pointList.get(i * 2 +1)[1];
    
    //float[] mid1 = findMidpoint(x1, x5, y1, y5); //random point between (x1, y1) (x5, y5)
    //float[] mid2 = findMidpoint(x1, x6, y1, y6);
    
    float[] mid1 = findRandomPointBetweenPoints(x1, x5, y1, y5); //random point between (x1, y1) (x5, y5)
    float[] mid2 = findRandomPointBetweenPoints(x1, x6, y1, y6);
    //stroke(0, 255, 0);
    //point(mid1[0], mid1[1]);
    //point(mid2[0], mid2[1]);
    //noFill();
    //strokeWeight(1);
    //stroke(0);
    bezier(x5, y5, mid1[0], mid1[1], mid2[0], mid2[1], x6, y6);
    //intersection calculations
    float[] intersection1 = findIntersectionFromPoints(x1, x2, x3, x4, y1, y2, y3, y4);
    //float[] intersection2 = findIntersectionFromPoints(x1, x5, x3, x6, y1, y5, y3, y6);
    //strokeWeight(5);
    //stroke(0, 0, 255);
    //point(intersection1[0], intersection1[1]);
    float[] temp = {intersection1[0], intersection1[1]};
    innerPointList.add(temp);
    
  }
  for (int i = 0; i < innerPointList.size(); i+=1) {
    float x1 = innerPointList.get(i)[0]; 
    float y1 = innerPointList.get(i)[1];
    
    float x5 = pointList.get(i * 2+1)[0];
    float y5 = pointList.get(i * 2+1)[1];
    //x5 is something between x5 and x1?
    
    float x6 = pointList.get((i * 2 +2) % pointList.size())[0];
    float y6 = pointList.get((i * 2 +2) % pointList.size())[1];
    
    float[] mid1 = findRandomPointBetweenPoints(x1, x5, y1, y5);
    float[] mid2 = findRandomPointBetweenPoints(x1, x6, y1, y6);
    //stroke(0, 255, 0);
    //point(mid1[0], mid1[1]);
    //point(mid2[0], mid2[1]);
    noFill();
    //strokeWeight(1);
    //stroke(0);
    bezier(x5, y5, mid1[0], mid1[1], mid2[0], mid2[1], x6, y6);
  }
}
void draw_with_shading(int seg_num, int depth, float dr) {
  float centX = width/2;
  float centY = height/2;
  noFill();
  strokeWeight(2);
  float r = 1;
  float red = 255;
  float green = 255;
  float blue = 255;
  stroke(red, green, blue);
  for (int i = 0; i < depth * dr; i++) {
    if (i % dr == 0) {
      stroke(red, green, blue); //color-switching
    }
    drawLoop(r, seg_num, centX, centY);
    r += 1;
    red -= 0.5;
    green -= 0.5;
    blue -= 0.5;
  } 
}

void draw_with_shading_random_color(int seg_num, int depth, float dr) {
  color temp = pick_color_from_palette();
  background(temp);
  float centX = width/2;
  float centY = height/2;
  noFill();
  strokeWeight(2);
  float r = 1;
  float red = 255;
  float green = 255;
  float blue = 255;
  stroke(red, green, blue);
  for (int i = 0; i < depth * dr; i++) {
    if (i % dr == 0) {
      temp = pick_color_from_palette();
      stroke(temp); //color-switching
    }
    drawLoop(r, seg_num, centX, centY);
    r += 1;
  } 
}
void setup() {
  size(1000, 1000);
  float centX = width/2;
  float centY = height/2;
  background(255);
  noFill();
  strokeWeight(1);
  int seg_num = 16;
  int depth = 200;
  float dr = 20; //gap between each loop
  draw_with_shading_random_color(seg_num, depth, dr);
  float r = 10;
  //float red = 0;
  //float green = 0;
  //float blue = 0;
  //stroke(red, green, blue);
  //for (int i = 0; i < depth * dr; i++) {
  //  drawLoop(r, seg_num, centX, centY);
  //  strokeWeight(random(0,4));
  //  r += dr;

  //}
  saveFrame();
}