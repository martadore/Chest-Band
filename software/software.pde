import grafica.*;
import g4p_controls.*;
import processing.serial.*;
import java.util.*;


//Plots define:
GPlot plot1;
GPointsArray points1 = new GPointsArray(2000);
color[] pointColors1 = new color[2000];

GPlot plot2;
GPointsArray points = new GPointsArray(2000);
color[] pointColors = new color[2000];

int count1 = 0;
int xvar1 = -5;

int count = 0;
int xvar = -5;
int lastStepTime = 0;

Serial myPort;
String val;    
//Vector<Integer> val1 = new Vector<Integer>();
Vector<Integer> val2 = new Vector<Integer>();

/*
int ecg_old = 0;
int ecg = 0;
int ecg_new = 0;
int thresholdECG = 500; 
int time_oldECG = 0;
int timeECG = 0;
int deltaECG = 0;
int delta_timeECG = 100;
int max_relECG = 0;*/
int num_maxECG = 0;

int fsr_old = 0;
int fsr = 0;
int fsr_new = 0;

int low_thresholdFSR = 35;
int high_thresholdFSR = 120;
int time_minOld = 0;
int deltaMin = 0;
int time_min = 0;
int timeFSR = 0;
int time_max = 0;
int time_oldFSR = 0;
int deltaFSR = 0;
int delta_timeFSR = 300;
int exhal_time = 0;
int max_relFSR = 0;
int num_maxFSR = 0;
int inhal_time = 0;

int name_ok = 0;
int set_age = 0;
String name;
int age;
int maxHR;
int bio_inserted = 0;

int fitness_mode = 0;
int stress_mode = 0;
int meditation_mode = 0;
int stop = 1;
int get_baseline = 0;
int got_baseline = 0;
int init = 0;

int startTime = 0;
int baselineHR = 0;
int maxECG = 0;
int baselineRR = 0;
int maxFSR = 0;
String activity = "";
String phase = "";

int [] col = {0, 0, 128};
int [] answers = {0, 0, 0, 0};

int hr = 0;
int rr = 0;
int err = 0;

int insp_time = 0;
int esp_time = 0;
int inspiration = 0;
int espiration = 0;

int time_maximum = 0;
int time_hard = 0;
int time_moderate = 0;
int time_light = 0;
int time_verylight = 0;

int x_pos = 750;
int y_pos = 550;

public void setup(){
  size(1000, 950, JAVA2D);
  
  createGUI();
  customGUI();
  
  // Create the heartrate plot:
  plot1 = new GPlot(this);
  plot1.setPos(20, 300);
  plot1.setDim(600, 200);
  plot1.setXLim(0, 300);
  plot1.setYLim(0, 1400);
  plot1.getTitle().setText("ECG");
  plot1.getXAxis().getAxisLabel().setText("sample number");
  plot1.getYAxis().getAxisLabel().setText("ADC unit");
  plot1.activatePanning();
  
  // Create the respiration plot:
  plot2 = new GPlot(this);
  plot2.setPos(20, 510);
  plot2.setDim(600, 200);
  plot2.setXLim(0, 300);
  plot2.setYLim(0, 450);
  plot2.getTitle().setText("Respiration");
  plot2.getXAxis().getAxisLabel().setText("sample number");
  plot2.getYAxis().getAxisLabel().setText("ADC unit");
  plot2.activatePanning();
  
 String portName = Serial.list()[0];
 myPort = new Serial(this, portName, 115200);
}

public void draw(){
  background(230);
  
  if(name_ok == 1){
    set_age = 1;
  }
  
  if(bio_inserted == 1){
    background(255, 255, 255);
    PImage fitness = loadImage("fitness_mode.png");
    PImage stress = loadImage("stress_mode.png");
    PImage meditation = loadImage("meditation_mode.png");
    PImage pause = loadImage("stop.png");
    PImage maximum = loadImage("maximum.png");
    PImage bar = loadImage("color bar.png");
    PImage runner = loadImage("runner.png");
    PImage heart = loadImage("heart.png");
    PImage lung = loadImage("lung.png");
    PImage fire = loadImage("fire.png");
    PImage rest = loadImage("rest.png");
    
    fill(0); //text black
    textFont(createFont("calibri", 15));
    text("Fitness mode: ", 115, 35);
    image(fitness, 127, 43, 70, 70);
    text("Stress/relax mode: ", 210, 35);
    image(stress, 237, 43, 70, 70);
    text("Meditation mode: ", 335, 35);
    image(meditation, 343, 43, 70, 70);
    image(pause, 455, 43, 70, 70);
    textSize(25);
    text("Name: " + name, 670, 35);
    text("Age: "+ age, 670, 68);
    text("Maximum HR: " + maxHR, 670, 100);
    image(maximum, 626, 74, 35, 35);
    
    image(heart, 15, 155, 50, 50);  //xpos, ypos, width, height
    image(lung, 15, 200, 50, 50);
    fill(255,255,255);
    stroke(255);
    rect(290, 155, 50, 40);
    rect(361, 200, 50, 40);
    rect(650, 167, 345, 60);
    rect(830, 310, 120, 40);
    rect(780, 645, 30, 30);
    rect(845, 670, 30, 30);
    rect(850, 700, 30, 30);
    rect(800, 355, 70, 40);
    rect(800, 390, 70, 40);
    rect(800, 450, 70, 40);
    rect(800, 505, 70, 40);
    rect(800, 555, 70, 40);
    rect(x_pos, y_pos, 30, 30);
    fill(0);
    textSize(30);
    text("Resting heartrate: " + baselineHR, 70, 187);
    text("Resting respiratory rate: " + baselineRR, 70, 230);
    text("Status: " + phase, 565, 210);
    textSize(20);
    text("Cardiac zone: " + activity, 720, 335);
    image(bar, 720, 347);
    
    textSize(25);
    text("RR: " + rr, 745, 670);
    text("Inh. time: " + inspiration + "s", 745, 695);
    text("Exh. time: " + espiration + "s", 745, 720);
    
    textSize(20);
    text(time_maximum + "s", 805, 375);
    text(time_hard + "s", 805, 423);
    text(time_moderate + "s", 805, 475);
    text(time_light + "s", 805, 530);
    text(time_verylight + "s", 805, 580);
    
    image(runner, x_pos, y_pos, 50, 50);
    
    if (myPort.available() > 0) {
      val = myPort.readStringUntil('\n');
      if (millis() - lastStepTime > 200){
        if (val != null) {
          String[] arrOfStr = val.split(",");
         /*
          ecg_old = ecg;
          ecg = ecg_new;
          ecg_new = Integer.parseInt(arrOfStr[0]);
          
          points1.add(xvar1+10, ecg_new);
          xvar1 = xvar1+5;
          count1++;
          */
          fsr_old = fsr;
          fsr = fsr_new;
          fsr_new = Integer.parseInt(arrOfStr[0]);
          
          points.add(xvar+10, fsr_new);
          xvar = xvar+5;
          count++;
         
          if(fitness_mode == 1 || stress_mode == 1 || meditation_mode == 1){
            
            if(get_baseline == 0){
               startTime = millis();
               //println(startTime);
               get_baseline = 1;
            }
            if(get_baseline == 1 && got_baseline == 0){
              println("Measuring baseline ...");
              phase = "getting baseline";
              answers = calculateHR_RR( fsr_old, fsr, fsr_new);//(ecg_old, ecg, ecg_ne
             // maxECG, maxFSR, esp_time, insp_time = answers[0], answers[1], answers[2], answers[3]; 
              if(millis() - startTime >= 15000){
                println("Baseline measured");
                phase = "baseline measured";
                baselineHR  = answers[0]*4;
                baselineRR = answers[1]*4;
                println(baselineHR);
                println(baselineRR);
                //num_maxECG = 0;
                num_maxFSR = 0;
                got_baseline = 1;
                if(fitness_mode == 1){
                  println("Display baseline cardio zone");
                  phase = "baseline cardio zone";
                  if (baselineHR > .9*maxHR) {
                     activity = "maximum";
                     x_pos = 745;
                     y_pos = 350;
                     //image(runner, 745, 350, 50, 50);
                  } else if (baselineHR >= .8*maxHR && baselineHR < .9*maxHR) {
                     activity = "hard";
                     x_pos = 750;
                     y_pos = 400;
                     //image(runner, 750, 400, 50, 50);
                  } else if (baselineHR >= .7*maxHR && baselineHR  < .8*maxHR) {
                     activity = "moderate";
                     x_pos = 750;
                     y_pos = 450;
                     //image(runner, 750, 450, 50, 50);
                  } else if (baselineHR >= .6*maxHR && baselineHR  < .7*maxHR) {
                     activity = "light";
                     x_pos = 750;
                     y_pos = 500;
                    // image(runner, 750, 500, 50, 50);
                  } else {
                     activity = "very light";
                     x_pos = 750;
                     y_pos = 550;
                     //image(runner, 750, 550, 50, 50);
                  }
                 }
               }
            }
            
           if(fitness_mode == 1 && stop == 1 && got_baseline == 1 ){
              if (init == 0){
                 startTime = millis(); //Timer starts
                 init = 1;
              }
              if(init == 1){
                phase = "monitoring";
               // maxECG, maxFSR, esp_time, insp_time = answers[0], answers[1], answers[2], answers[3]; 
               answers = calculateHR_RR(fsr_old, fsr, fsr_new);//R(ecg_old, ecg, ecg_new,
               if(answers[2] != 0){
                espiration = answers[2];
               }
               if(answers[3] != 0){
                inspiration = answers[3];
               }
               //println(millis()-startTime);
               if(millis() - startTime >= 15000){
                hr  = answers[0]*4;
                rr = answers[1]*4;
                println("Respiratory rate: " + rr);
                println("Heart rate: " + hr);
               // num_maxECG = 0;
                num_maxFSR = 0;
                if (hr > .9*maxHR) {
                  activity = "maximum";
                  x_pos = 750;
                  y_pos = 350;
                 // image(runner, 750, 350, 50, 50);
                  time_maximum += 15;
                  plot1.setLineColor( color(255, 0, 0) );
                  pointColors1[count] = color(255, 0, 0);
                } else if (hr>= .8*maxHR  && hr < .9*maxHR) {
                  activity = "hard";
                  x_pos = 750;
                  y_pos = 400;
                  //image(runner, 750, 400, 50, 50);
                  time_hard += 15;
                  plot1.setLineColor( color(255, 255, 0));
                  pointColors1[count] = color(255, 255, 0);
                } else if (hr >= .7*maxHR && hr < .8*maxHR) {
                  activity = "moderate";
                  x_pos = 750;
                  y_pos = 450;
                  //image(runner, 750, 450, 50, 50);
                  time_moderate += 15;
                  plot1.setLineColor( color(0, 255, 0));
                  pointColors1[count] = color(0, 255, 0);
                } else if (hr >= .6*maxHR && hr< .7*maxHR) {
                  activity = "light";
                  x_pos = 750;
                  y_pos = 500;
                 // image(runner, 750, 500, 50, 50);
                  time_light += 15;
                  plot1.setLineColor( color(0, 255, 255));
                  pointColors1[count] = color(0, 255, 255);
                } else {
                  activity = "very light";
                  x_pos = 750;
                  y_pos = 550;
                  //image(runner, 750, 550, 50, 50);
                  time_verylight += 15;
                  plot1.setLineColor( color(0, 0, 128));
                  pointColors1[count] = color(0, 0, 128);
                }
                init = 0;
               }
              //println("Measuring HR and RR");
              }
             }
             
            if(stress_mode == 1 && stop == 1 && got_baseline == 1){
               if (init == 0){
                 startTime = millis();
                 init = 1;
              }
              //println("Measuring HR and RR");
              if(init == 1){
                phase = "monitoring";
                answers = calculateHR_RR(fsr_old, fsr, fsr_new);//ecg_old, ecg, ecg_new
               if(answers[2] != 0){
                 espiration = answers[2];
               }
               if(answers[3] != 0){
                 inspiration = answers[3];
               }
               if(millis() - startTime >= 15000){
                hr= answers[0]*4;
                rr= answers[1]*4;
                //num_maxECG = 0;
                num_maxFSR = 0;
                init = 0;
                if(hr > baselineHR || rr> baselineRR){
                  phase = "stressed!";
                  image(fire, 800, 169, 48, 48);
                  println("Stressed");
                 }else if(hr < baselineHR || rr < baselineRR){
                  phase = "relaxed!";
                  //image(rest, 800, 169, 48, 48);
                  println("Relaxed");
                 }
                 
   
               }
               if (phase == "stressed!") {
                   println("Stressed");
                   phase = "stressed!";
                   image(fire, 800, 169, 48, 48);
                 } else {
                   println("Relaxed");
                   phase = "relaxed!";
                   image(rest, 800, 169, 48, 48);
                 }
             }
            }
             
            if(meditation_mode == 1 && stop == 1 && got_baseline == 1){
              if (init == 0){
                 startTime = millis();
                 high_thresholdFSR = 40;
                 init = 1;
              }
              if(init == 1){
              //println("Measuring HR and RR");
              phase = "monitoring";
              // maxECG, maxFSR, esp_time, insp_time = answers[0], answers[1], answers[2], answers[3]; 
              answers = calculateHR_RR(fsr_old, fsr, fsr_new);//ecg_old, ecg, ecg_new
              if(answers[2] != 0){
                 espiration = answers[2];
                 println(inspiration/espiration);
                 if(((inspiration/espiration) > 0.40) || ((inspiration/espiration) < 0.25)){
                    err++;
                    if(err == 3){
                      phase = "threshold overcome 3 times!";
                      println("Errore");
                      err = 0;
                    }
                 }
               }
              if(answers[3] != 0){
                 inspiration = answers[3];
              }
              if(millis() - startTime >= 15000){
                hr= answers[0]*4;
                rr= answers[1]*4;
                //num_maxECG = 0;
                num_maxFSR = 0;
                init = 0;
             }
            }
           }
             
            if(stop == 0 && got_baseline == 1){
              println("stop");
              fitness_mode = 0;
              stress_mode = 0;
              meditation_mode = 0;
              get_baseline = 0;
              got_baseline = 0;
              high_thresholdFSR = 100;
              init = 0;
              time_maximum = 0;
              time_hard = 0;
              time_moderate = 0;
              time_light = 0;
              time_verylight = 0;
              stop = 1;
            }
          }
        }
         if(xvar1>300 || xvar > 300){
         points1.removeRange(0, count1);
         points.removeRange(0, count);
         xvar1 = -5;
         xvar = -5;
         count1 = 0;
         count = 0;
         }
         lastStepTime = millis();
      }
     }
      //Plot1: 
    plot1.setPoints(points1);
    plot1.setPointColors(pointColors1);
    plot1.beginDraw();
    plot1.drawBackground();
    plot1.drawBox();
    //plot.drawXAxis();
    plot1.drawYAxis();
    plot1.drawTitle();
    plot1.drawLines();
    plot1.getMainLayer().drawPoints();
    plot1.endDraw();
    
    //Plot2:
    plot2.setPoints(points);
    plot2.setPointColors(pointColors);
    plot2.beginDraw();
    plot2.drawBackground();
    plot2.drawBox();
    //plot.drawXAxis();
    plot2.drawYAxis();
    plot2.drawTitle();
    plot2.drawLines();
    plot2.getMainLayer().drawPoints();
    plot2.endDraw(); 
    } 
  }


int [] calculateHR_RR(int fsr1, int fsr2, int fsr3){//int ecg1, int ecg2, int ecg3,
   /*
   //Heart rate:
   if (ecg2 >= thresholdECG){  
       time_oldECG = timeECG;
       timeECG = millis()-200;          //I know that I'm taking a sample every 200ms 
       deltaECG = timeECG - time_oldECG;
      if( deltaECG >= delta_timeECG && ecg1 <= ecg2 && ecg2 >= ecg3)
      {
          max_relECG = ecg2;
          num_maxECG++;
      }
    }*/

    //Respiratory rate:
   if (fsr2 < low_thresholdFSR){
     time_minOld = time_min;       
     time_min = millis()-200;
     deltaMin = time_min - time_minOld;
     if(deltaMin >= delta_timeFSR && fsr1 >= fsr2 && fsr2 <= fsr3 ){
       if(time_max != 0){
         exhal_time =(time_min - time_max)/1000;
       }else{
         exhal_time = 0;
       }
     }
   }else{
     exhal_time = 0;
   }
   if (fsr2 >= high_thresholdFSR){
       time_oldFSR = timeFSR;
       timeFSR = millis()-200;  
       deltaFSR = timeFSR - time_oldFSR;
      if( deltaFSR >= delta_timeFSR && fsr1 <= fsr2 && fsr2 >= fsr3 )
      {
          max_relFSR = fsr2;
          num_maxFSR++;
          time_max = timeFSR;
          inhal_time =(time_max-time_min)/1000;
      }else{
        inhal_time = 0;
      }
    }else{  
      inhal_time = 0;
    }
    num_maxECG = 0;
    int [] array ={num_maxECG, num_maxFSR, exhal_time, inhal_time};
    return array;
}

GPoint calculatePoint(float i, float n) {
  return new GPoint(i, n);
}

void keyPressed()
{
  if(key == ENTER && name_ok == 0){
    name = ask_name.getText();
    println(name);
    name_ok = 1;
  }
  if(key == ENTER && name_ok == 1 && set_age == 1){
    age = int(ask_age.getText());
    maxHR = 220-age;
    println(age);   
    println(maxHR);
    label3.setVisible(false);
    label4.setVisible(false);
    ask_name.setVisible(false);
    ask_age.setVisible(false);
    imgButton1.setVisible(false);
    bio_inserted = 1;
  }
  if (key == 'x' || key == 'X')
  {
    exit();
  }
}

void mousePressed() {
  if( sqrt( sq(160 - mouseX) + sq(75 - mouseY)) < 70/2){
    println("Fitness mode");
    fitness_mode = 1;
    phase = "fitness mode";
  }
  if( sqrt( sq(270 - mouseX) + sq(75 - mouseY)) < 70/2){
    println("Stress mode");
    stress_mode = 1;
    phase = "stress mode";
  }
  if( sqrt( sq(360 - mouseX) + sq(75 - mouseY)) < 70/2){
    println("Meditation mode");
    meditation_mode = 1;
    phase = "meditation mode";
  }
  if( sqrt( sq(470 - mouseX) + sq(75- mouseY)) < 70/2){
    stop = 0;
  }  
}


public void customGUI(){

}
