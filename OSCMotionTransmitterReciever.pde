import processing.net.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
PVector eular = new PVector(0, 0, 0);

final int IncommingPort = 8000;

void settings() {
  size(500, 500, P3D);
}

void setup() {
  oscP5 = new OscP5(this, IncommingPort);
  background(0);
}

void draw() {
  background(0);
  
  text(Server.ip(), 20, 20);
  
  translate(width/2, height/2, -200);

  lights();

  rotateZ(-eular.z * PI / 180f);
  rotateY(-eular.y * PI / 180f);
  rotateX(eular.x * PI / 180f);

  fill(100, 100, 100);
  box(100);
}

void oscEvent(OscMessage m) {
  println("NetAddress: " + m.netAddress() + " Port: " + m.port());

  println("Address: " + m.addrPattern());
  int args = m.arguments().length;
  String tt = m.typetag();
  println("TypeTag: " + tt);
  char[] ch = tt.toCharArray();
  FloatList fl = new FloatList();
  for (int n = 0; n < args; n++) {
    println("type: " + ch[n]);
    switch (ch[n]) {
    case 'i': 
      {
        int i = m.get(n).intValue();
        println("value: " + i);
        fl.append(i);
      } 
      break;
    case 'f': 
      {
        float f = m.get(n).floatValue();
        println("value: " + f);
        fl.append(f);
      } 
      break;
    case 's': 
      {
        String s = m.get(n).stringValue();
        println("value: " + s);
      } 
      break;
    }
  }

  if (m.addrPattern().equals("/gyro/eular") && fl.size() >= 3) {
    eular.x = fl.get(0);
    eular.y = fl.get(1);
    eular.z = fl.get(2);

    println("Eular: " + eular);
  }
}
