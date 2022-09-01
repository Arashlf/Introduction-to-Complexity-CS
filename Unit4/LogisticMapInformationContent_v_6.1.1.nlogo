globals [x-current x-new x-current' x-new' num-turtles-created turtlex0-who turtlex0'-who
         current-symbol num-zeros num-ones zero-prob one-prob total-num-symbols info-content]

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  clear-output
  set num-turtles-created -1; first turtle created will be number 0
  draw-axes
  draw-parabola

  set x-current x0
  set x-new (R * x-current * (1 - x-current))  ; logistic map

  ; Set up variables for measuring information content
  set num-zeros 0
  set num-ones 0
  set total-num-symbols 0
  update-info-content


  create-turtles 1; this turtle will plot x_{t+1} vs x_t using initial condition x0
  [
    set color blue
    set xcor (x-current * max-pxcor)
    set ycor (x-new * max-pycor)
    set shape "dot"
    set size 3
  ]
  set num-turtles-created num-turtles-created + 1
  set turtlex0-who num-turtles-created   ; "id number" for this turtle

  setup-plot-info-content
  update-plot-info-content
  setup-plot-logistic
  update-plot-logistic

end

to go
  iterate  ; do one iteration of logistic map
  tick  ; increase tick number by 1
end

to iterate
  set x-current x-new
  set x-new (R * x-current * (1 - x-current))  ; one iteration of logistic map
  ask turtle turtlex0-who
  [
      set xcor (x-current * max-pxcor)  ; update coordinates for turtle representing first initial condition
      set ycor (x-new * max-pycor)
  ]
  update-plot-logistic
  update-info-content
  update-plot-info-content
end

to update-info-content
 ; Update variables for measuring information content
  ifelse (x-new < 0.5)
    [
    set current-symbol 0
    set num-zeros (num-zeros + 1)
    ]
    [
    set current-symbol 1
    set num-ones (num-ones + 1)
    ]
    output-write current-symbol
  set total-num-symbols (total-num-symbols + 1)
  set zero-prob (num-zeros / total-num-symbols)
  set one-prob (num-ones / total-num-symbols)
  ifelse zero-prob = 0 or one-prob = 0
    [set info-content 0]
    [set info-content (0 - ((zero-prob * (log zero-prob 2)) + (one-prob * (log one-prob 2))))]
end

to draw-axes   ; draws x and y axes
  ask patches
    [set pcolor white]
  create-turtles 1
  set num-turtles-created num-turtles-created + 1
  ask turtles
  [
    set color black
    set xcor min-pxcor
    set ycor min-pycor
    set heading 0
    pen-down
    fd max-pycor   ; draw y axis
    pen-up
    set xcor min-pxcor
    set ycor min-pycor
    set heading 90
    pen-down
    fd max-pxcor  ; draw x axis
    die
  ]
end

to draw-parabola  ; draws parabola representing logistic map for given value of R
 let x 0
 let y 0
 create-turtles 1
 set num-turtles-created num-turtles-created + 1
  ask turtles
  [
    set color black
    set xcor x * min-pxcor
    set ycor y * min-pycor
    pen-down
  ]
  repeat 10000
  [
    set x (x + .0001)
    ask turtles
    [
      set xcor (x * max-pxcor)
      set ycor (R * x * (1 - x)) * max-pycor
    ]
  ]
  ask turtles [die]
end




;;plotting procedures -------------------

to setup-plot-logistic
  set-current-plot "logistic map"
  set-plot-x-range  0 1
  set-plot-y-range  0 1
end

to setup-plot-info-content
  set-current-plot "information content"
  set-plot-x-range  0 10
  set-plot-y-range  0 1
end

to update-plot-logistic
  set-current-plot "logistic map"
  plot x-current
end

to update-plot-info-content
  set-current-plot "information content"
  plot info-content
end
@#$#@#$#@
GRAPHICS-WINDOW
393
10
793
411
-1
-1
11.9
1
10
1
1
1
0
1
1
1
0
32
0
32
0
0
1
ticks
30.0

BUTTON
91
63
154
96
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
29
63
92
96
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
16
99
188
132
R
R
0
4
3.64
0.01
1
NIL
HORIZONTAL

SLIDER
16
131
188
164
x0
x0
0
1
0.2
0.00000001
1
NIL
HORIZONTAL

PLOT
10
254
379
383
logistic map
time t (* 10)
x_t
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"initial condition x0" 0.1 0 -13345367 true "" ""

MONITOR
26
168
101
213
x_t
x-current
8
1
11

MONITOR
99
168
172
213
x_{t+1}
x-new
8
1
11

PLOT
10
383
378
521
information content
time (* 10)
H (estimated)
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

MONITOR
194
151
381
196
number of symbols seen so far
total-num-symbols
0
1
11

MONITOR
263
62
359
107
probability of 0
zero-prob
2
1
11

MONITOR
262
106
358
151
probability of 1
one-prob
2
1
11

MONITOR
194
195
381
240
Information content H (estimated)
info-content
2
1
11

MONITOR
193
62
264
107
NIL
num-zeros
0
1
11

MONITOR
194
106
264
151
NIL
num-ones
0
1
11

OUTPUT
395
438
797
499
10

TEXTBOX
25
10
346
53
Logistic Map:  Shannon Information Content of Symbolic Dynamics
18
95.0
1

@#$#@#$#@
## WHAT IS IT?

This model calculates the Shannon information content of the "symbolic dynamics" of the logistic map, x_{t+1} = R x_t (1 - x_t), where x_t is the value of x at time step t, and x_{t+1} is the value of x at the next time step. x is always between 0 and 1.   R is a control parameter that ranges from 0 to 4.  The symbolic dynamics is calculated as follows:  At each time step in the logistic map, whenever xt is less than 0.5, a "0" is output; otherwise a "1" is output.   The Shannon information content H of the cumulative symbolic dynamics is estmated at each time step as
	H = - [(probability_0 * log_2 probability_0)
		+ (probability_1 * log_2 probability_1)]


## HOW TO USE IT

Use the sliders to set R and x_0.
    Click on "setup" to draw the axes and the parabola representing the function y = R x (1 - x).  Click on "go" to do successive iterations of the logistic map.

## CREDITS AND REFERENCES

This model is part of the Information Theory series of the Complexity Explorer project.
Main Author: Melanie Mitchell

Netlogo:  Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.


## HOW TO CITE

If you use this model, please cite it as: "Logistic Map Information Content" model, Complexity Explorer project, http://complexityexplorer.org

## COPYRIGHT AND LICENSE

Copyright 2016 Santa Fe Institute.

This model is licensed by the Creative Commons Attribution-NonCommercial-ShareAlike  International  ( http://creativecommons.org/licenses/ ). This states that you may copy, distribute, and transmit the work under the condition that you give attribution to ComplexityExplorer.org, and your use is for non-commercial purposes.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@