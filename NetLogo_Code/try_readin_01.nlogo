;;;

;;; loading extensions (here: network)
extensions [ nw ]


;;; defining variables
; global variables (containing probabilites for each turtle)
globals [ prob_data ]

; turtle variables
turtles-own
[
  view_ip_twt ; indicator, if there is an information pollution tweet in the neighborhood (in one of the linked nodes)
  post_ip_twt ; indicator if turtle posts / posted an information pollution tweet
  twt_time ; time (= tick) when tweet was posted
  twt_type ; type of tweet posted (supporting, opposing, neutral)
  p_ip_SUP ; probability of a posting supporting tweet (in percent)
  p_ip_OPP ; probability of a posting opposing tweet (in percent)
  p_ip_NTR ; probability of a posting neutral tweet (in percent)
]


;;; setting-up the stage
; global setup
to setup
   set-current-directory "D:\\Studium\\MT_MasterThesis\\MT_Code\\NetLogo_Code"
   clear-all
   setup-network
   setup-tweets
   readin-prob
   setup-prob
   reset-ticks
end

; network setup
to setup-network
  set-default-shape turtles "circle"
  nw:load-matrix "Data\\mt00.txt" turtles links ; loading 10x10 adjacency matrix
  repeat 30 [ layout-spring turtles links 0.3 ((world-width / sqrt count turtles) / 2) 2 ]
  ask turtles [ set color grey ] ; setting turtle color
  ask turtles [ set twt_type "NA"] ; setting turtles to "Not Applicable" (no tweet posted)
  ask turtles [ set twt_time -10000 ] ; setting time of tweet to -10000 [YYY - search for better solution]
  ask turtles [ set size 1 ] ; setting turtle size
  ask turtles [ set post_ip_twt 0 ] ; setting indicator for information pollution tweets "0" (= no ip tweet)
end

; information pollution setup. assigning (randomly) "no_ip_twt" of tweets neutral tweets ("NTR" and blue)
to setup-tweets
   ask n-of no_ip_twt turtles
    [
    set post_ip_twt 1
    set twt_type "NTR"
    set color blue
    set twt_time 0
    ]
end

; reading-in probabilities for each turtle from file "prob_input_01.txt"
to readin-prob
 ifelse ( file-exists? "Data\\prob_input_01.txt" ) ; check, if file "prob_input_01.txt" exists in specified folder
  [
   set prob_data [] ; preparing a list for the data

   file-open "Data\\prob_input_01.txt" ; opening the data

     while [ not file-at-end? ] ; reading the file to the end
       [
       set prob_data sentence prob_data (list (list file-read file-read file-read)) ; setting "prob_data" with (3 items per list entry "file-read" reads them individually)
       ]

    user-message "Input file prob_input_01.txt sucessfully loaded!" ; message when sucessfully loaded
    file-close ; closing file
  ]

  [
  user-message "There is no file called prob_input_01.txt in current directory!" ; message, when no file "prob_input_01.txt" present ("else"-condition of first "ifelse")
  ]
end

; assigning read-in probabilites to turtles
to setup-prob
  ask turtles [
    set p_ip_SUP item 0 prob_data
    set p_ip_OPP item 1 prob_data
    set p_ip_NTR item 2 prob_data
  ]
end



;;;; defining actions
;; global instructions
to go
   tweet_action
   tweet_aging
   tick
end

;; tweet action: this consists of three steps...
; 1st: Tweet-Check: to check if any linked neighbor tweeted ip tweets
; 2nd: Basic Tweet-Decison: to decide whether to tweet at all. (probability of p_ip_twt from interface)
; 3rd: Tweet-Type Decision: to decide what type of tweet ("NTR", "SUP", "OPP") to tweet (probabilities "p_ip_XXX" from chunk "setup-prob")
; NOTE: command "random 101" leads to a random number betweet "0" and "100"
to tweet_action
  ask turtles [

    let friends link-neighbors ; defining linked neighbors as "friends"
    let ip_cnt count friends with [ post_ip_twt = 1 and twt_time <= (ticks - twt_delay) ] ; defining ip_cnt as number of "friends" with tweeets ( post_ip_twt = "1") whose tweet is older than "twt_delay"

    if ip_cnt > 0 and random 101 <= p_ip_twt ; if there are any "friends" with tweets, in "p_ip_twt" percent of all cases, the following applies:
    [
      set post_ip_twt 1 ; setting indicator this twitterer tweets
      set twt_time ticks ; setting time of tweet (twt_time) to time (= number of ticks)
      let rdm_no random 101
      if rdm_no <= p_ip_NTR [set twt_type "NTR"] ; in p_ip_NTR of all tweets, it will be of the neutral type ("NTR")
      if rdm_no > p_ip_NTR and rdm_no <= (p_ip_NTR + p_ip_OPP) [set twt_type "OPP"] ; in p_ip_OPP of all tweets, it will be of the opposing type ("OPP")
      if rdm_no > (p_ip_NTR + p_ip_OPP) [set twt_type "SUP"] ; in p_ip_SUP of all tweets, it will be of the supporting type ("SUP")
     ]

  ]
end


;; tweet aging (and cleanup): here, ip tweets that reached tweet lifespan "ls_twt" (from interface) are set-back to "NA" (= no ip-tweet)
to tweet_aging
ask turtles
  [
    if post_ip_twt = 1 and ticks >= (twt_time + ls_twt) ; checking if lifespan "ls_twt" has been reached
    [
      set twt_time -10000 ; if yes, setting time of tweet to "NA"
      set post_ip_twt 0 ; if yes, setting back tweet indicator to "zero"
      set twt_type "NA" ; if yes; lable twitterer as "NA"

     ]

    if twt_type = "NTR" [ set color blue ] ; change colors acc. to tweet type
    if twt_type = "SUP" [ set color red ] ; change colors acc. to tweet type
    if twt_type = "OPP" [ set color green ] ; change colors acc. to tweet type
    if twt_type = "NA"  [ set color grey ] ; change colors acc. to tweet type

    set label p_ip_SUP  ; labelling with turtle-id

  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
832
26
1579
774
-1
-1
18.0244
1
10
1
1
1
0
0
0
1
-20
20
-20
20
1
1
1
ticks
30.0

BUTTON
145
156
272
189
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
0

PLOT
19
200
578
475
"Information Pollution" Supporting, Opposing and Neutral Tweets
Time [days]
Number of IP-Tweets [--]
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Neutral Tweets" 1.0 0 -11221820 true "" "plot count turtles with [ color = blue ]"
"Supporting Tweets" 1.0 0 -5298144 true "" "plot count turtles with [ color = red ]"
"Opposing Tweets" 1.0 0 -14439633 true "" "plot count turtles with [ color = green ]"

MONITOR
20
488
224
533
Supporting Tweets (red)
count turtles with [ twt_type = \"SUP\" ]
17
1
11

BUTTON
26
155
134
188
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

INPUTBOX
26
87
255
147
no_ip_twt
2.0
1
0
Number

INPUTBOX
260
87
497
147
p_ip_twt
5.0
1
0
Number

MONITOR
21
543
223
588
Opposing Tweets (green)
count turtles with [ twt_type = \"OPP\" ]
17
1
11

MONITOR
22
599
222
644
Neutral Tweets (blue)
count turtles with [ twt_type = \"NTR\" ]
17
1
11

MONITOR
22
655
220
700
No Tweets (grey)
count turtles with [ color = grey ]
17
1
11

INPUTBOX
545
90
700
150
ls_twt
14.0
1
0
Number

INPUTBOX
301
489
516
549
twt_delay
7.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

This model demonstrates the spread of a virus through a network.  Although the model is somewhat abstract, one interpretation is that each node represents a computer, and we are modeling the progress of a computer virus (or worm) through this network.  Each node may be in one of three states:  susceptible, infected, or resistant.  In the academic literature such a model is sometimes referred to as an SIR model for epidemics.

## HOW IT WORKS

Each time step (tick), each infected node (colored red) attempts to infect all of its neighbors.  Susceptible neighbors (colored green) will be infected with a probability given by the VIRUS-SPREAD-CHANCE slider.  This might correspond to the probability that someone on the susceptible system actually executes the infected email attachment.
Resistant nodes (colored gray) cannot be infected.  This might correspond to up-to-date antivirus software and security patches that make a computer immune to this particular virus.

Infected nodes are not immediately aware that they are infected.  Only every so often (determined by the VIRUS-CHECK-FREQUENCY slider) do the nodes check whether they are infected by a virus.  This might correspond to a regularly scheduled virus-scan procedure, or simply a human noticing something fishy about how the computer is behaving.  When the virus has been detected, there is a probability that the virus will be removed (determined by the RECOVERY-CHANCE slider).

If a node does recover, there is some probability that it will become resistant to this virus in the future (given by the GAIN-RESISTANCE-CHANCE slider).

When a node becomes resistant, the links between it and its neighbors are darkened, since they are no longer possible vectors for spreading the virus.

## HOW TO USE IT

Using the sliders, choose the NUMBER-OF-NODES and the AVERAGE-NODE-DEGREE (average number of links coming out of each node).

The network that is created is based on proximity (Euclidean distance) between nodes.  A node is randomly chosen and connected to the nearest node that it is not already connected to.  This process is repeated until the network has the correct number of links to give the specified average node degree.

The INITIAL-OUTBREAK-SIZE slider determines how many of the nodes will start the simulation infected with the virus.

Then press SETUP to create the network.  Press GO to run the model.  The model will stop running once the virus has completely died out.

The VIRUS-SPREAD-CHANCE, VIRUS-CHECK-FREQUENCY, RECOVERY-CHANCE, and GAIN-RESISTANCE-CHANCE sliders (discussed in "How it Works" above) can be adjusted before pressing GO, or while the model is running.

The NETWORK STATUS plot shows the number of nodes in each state (S, I, R) over time.

## THINGS TO NOTICE

At the end of the run, after the virus has died out, some nodes are still susceptible, while others have become immune.  What is the ratio of the number of immune nodes to the number of susceptible nodes?  How is this affected by changing the AVERAGE-NODE-DEGREE of the network?

## THINGS TO TRY

Set GAIN-RESISTANCE-CHANCE to 0%.  Under what conditions will the virus still die out?   How long does it take?  What conditions are required for the virus to live?  If the RECOVERY-CHANCE is bigger than 0, even if the VIRUS-SPREAD-CHANCE is high, do you think that if you could run the model forever, the virus could stay alive?

## EXTENDING THE MODEL

The real computer networks on which viruses spread are generally not based on spatial proximity, like the networks found in this model.  Real computer networks are more often found to exhibit a "scale-free" link-degree distribution, somewhat similar to networks created using the Preferential Attachment model.  Try experimenting with various alternative network structures, and see how the behavior of the virus differs.

Suppose the virus is spreading by emailing itself out to everyone in the computer's address book.  Since being in someone's address book is not a symmetric relationship, change this model to use directed links instead of undirected links.

Can you model multiple viruses at the same time?  How would they interact?  Sometimes if a computer has a piece of malware installed, it is more vulnerable to being infected by more malware.

Try making a model similar to this one, but where the virus has the ability to mutate itself.  Such self-modifying viruses are a considerable threat to computer security, since traditional methods of virus signature identification may not work against them.  In your model, nodes that become immune may be reinfected if the virus has mutated to become significantly different than the variant that originally infected the node.

## RELATED MODELS

Virus, Disease, Preferential Attachment, Diffusion on a Directed Network

## NETLOGO FEATURES

Links are used for modeling the network.  The `layout-spring` primitive is used to position the nodes and links such that the structure of the network is visually clear.

Though it is not used in this model, there exists a network extension for NetLogo that you can download at: https://github.com/NetLogo/NW-Extension.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Stonedahl, F. and Wilensky, U. (2008).  NetLogo Virus on a Network model.  http://ccl.northwestern.edu/netlogo/models/VirusonaNetwork.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2008 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

<!-- 2008 Cite: Stonedahl, F. -->
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
