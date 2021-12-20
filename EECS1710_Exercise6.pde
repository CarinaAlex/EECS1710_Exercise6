import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import camera3D.*;
import camera3D.generators.*;

import shapes3d.*;

int windowWidth;
int windowHeight;


float xRot = 0;
float yRot = 0;
float zRot = 0;

float logscale = 0;
int shapeStrokeWeight = 5;
float divergence = 3;
float xRotSpeed = 0f;
float yRotSpeed = 0;
float zRotSpeed = 0f;
int xTrans = 0;
int yTrans = 0;
int zTrans = 0;
boolean rgbFlag = true;
int background_v1 = 64;
int background_v2 = 64;
int background_v3 = 64;
int fill_v1 = 255;
int fill_v2 = 255;
int fill_v3 = 255;
int fill_v4 = 255;
int stroke_v1 = 32;
int stroke_v2 = 32;
int stroke_v3 = 32;
int stroke_v4 = 255;

Camera3D camera3D;
DropdownList objectList;
ShapeGroup earthSpaceStationGroup;

Map<Integer, String> rendererMenuItems;
String rendererChoices = "Regular P3D Renderer, Default Anaglyph,"
    + "BitMask Filter Red-Cyan, BitMask Filter Magenta-Green,"
    + "True Anaglyph, Gray Anaglyph, Half Color Anaglyph,"
    + "Dubois Red-Cyan, Dubois Magenta-Green, Dubois Amber-Blue,"
    + "Barrel Distortion, Split Depth Illusion, Interlaced,"
    + "Side by Side, Side by Side Half Width,"
    + "Over Under, Over Under Half Height";
Map<Integer, String> objectMenuItems;
String objectChoices = "Box, Sphere, Ring of Spheres, Earth";

void setup() {
  size(800, 600, P3D);

  windowWidth = width;
  windowHeight = height;

  xTrans = width / 2;
  yTrans = height / 2;
  zTrans = -200;

  rendererMenuItems = createDropdownMap(rendererChoices);
  objectMenuItems = createDropdownMap(objectChoices);

  createControls();
  camera3D = new Camera3D(this);
  camera3D.renderDefaultAnaglyph();
  camera3D.reportStats();

  Ellipsoid earth = new Ellipsoid(150, 20, 20);
  earth.texture(this, "land_ocean_ice_2048.png");
  earth.drawMode(Shape3D.TEXTURE);

  Box spaceStation = new Box(20, 10, 10);
  spaceStation.fill(128);
  spaceStation.strokeWeight(2);
  spaceStation.stroke(0);
  spaceStation.moveTo(0, 0, 250);

  earthSpaceStationGroup = new ShapeGroup();
  earthSpaceStationGroup.addChild(earth);
  earthSpaceStationGroup.addChild(spaceStation);
}

void createControls() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.getFont().setSize(12);

  float yOffset = 0.1;
  int controlSpace = 23;

  


}


Slider addSlider(String variable, String caption, float y, int min,
    int max) {
  Slider slider = cp5.addSlider(variable);
  slider.setPosition(10, y);
  slider.setRange(min, max);
  slider.setSize(80, 18);
  slider.setCaptionLabel(caption);

  return slider;
}


void draw() {
  if (rgbFlag) {
    colorMode(RGB, 255, 255, 255);
  } else {
    colorMode(HSB, 255, 100, 100);
  }

  String objectChoice = objectMenuItems.get((int) objectList.getValue());

  strokeWeight(shapeStrokeWeight);

  if (stroke_v4 == 0) {
    noStroke();
  } else {
    stroke(color(stroke_v1, stroke_v2, stroke_v3, stroke_v4));
  }

  if (fill_v4 == 0) {
    noFill();
  } else {
    fill(color(fill_v1, fill_v2, fill_v3, fill_v4));
  }

  pushMatrix();
  translate(xTrans, yTrans, zTrans);
  if (!objectChoice.equals("Earth")) {
    rotateX(radians(xRot));
    rotateY(radians(yRot));
    rotateZ(radians(zRot));
  }

  shapeMode(CENTER);
  scale(pow(10, logscale));

  switch ((int) objectList.getValue()) {
  case 0:
    box(100);
    break;
  case 1:
    sphereDetail(8, 6);
    sphere(100);
    break;
  case 2:
    sphereDetail(10);
    int sphereCount = 6;
    for (int ii = 0; ii < sphereCount; ++ii) {
      pushMatrix();
      rotateY(TWO_PI * ii / sphereCount);
      translate(0, 0, 200);
      sphere(50);
      popMatrix();
    }
    break;
  case 3:
    earthSpaceStationGroup.draw(getGraphics());
    break;
  default:
    println("unknown object " + objectChoice + ". please report bug.");
  }

  popMatrix();
}


void mouseWheel(MouseEvent event) {
  logscale += -event.getCount() / 10.;

}

//Resources: https://github.com/hx2A/Camera3D/blob/main/examples/III_Utilities/Camera3D_Experiments/Camera3D_Experiments.pde
