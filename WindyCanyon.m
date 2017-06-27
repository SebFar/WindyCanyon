#Windy Canyon Environment

#Initialize the map
map = [0,0,0,1,1,1,2,2,1,0];
global mapHeight = 7;
global mapWidth = 10;
global numberOfActions = 8;
global episodeMax = 300;
global greedParam = 0.1;
global learningRate = 0.5;
global decayRate = 1;

#Create the stepper function
function [xAfter, yAfter, reward, terminate] = step(xBefore, yBefore, action)
  global map; global mapWidth; global mapHeight;
  #For debugging
  #printf("Current position: (%d,%d). Step to take: %d \n",xBefore, yBefore, action);
  xAfter = xBefore; yAfter = yBefore;
  #Apply the step
  if (action == 1) #up
    yAfter++;
  elseif (action == 2) #down
    yAfter--;
  elseif (action == 3) #left
    xAfter--;
  elseif (action == 4) #right
    xAfter++;
  elseif (action == 5) #lu
    xAfter--;
    yAfter++;
  elseif (action == 6) #ur
    xAfter++;
    yAfter++;
  elseif (action == 7) #dr
    xAfter++;
    yAfter--;
  elseif (action == 8) #dl
    xAfter--;
    yAfter--;
  elseif (action == 9) #in position
  endif
  
  if xAfter > mapWidth
    xAfter = mapWidth;
  elseif xAfter < 1
    xAfter = 1;
  endif
  
  if yAfter > mapHeight
    yAfter = mapHeight;
  elseif yAfter < 1
    yAfter = 1;
  endif
  
  #printf("y: %d , x: %d before wind", yAfter, xAfter)
  #Apply the wind
  #Now Stochastic
  yAfter += map(xAfter);
  windiness = rand(1);
  if windiness < (1/3)
    yAfter++;
  elseif windiness <(2/3)
    yAfter--;
  endif
  if yAfter > mapHeight
    yAfter = mapHeight;
  elseif yAfter <1
    yAfter = 1;
  endif
  
  #Set the reward
  reward = -1;
  terminate = false;
  if ((xAfter == 8) && (yAfter == 4))
    reward = 0;
    terminate = true;
  endif
endfunction


#This function takes a state and picks action which is either a randomly selected maximal action or an exploring action with epsilon probability
function action = chooseAction(xPos, yPos, q)
  global numberOfActions;
  global greedParam;
  qOfActions = q(yPos, xPos, :);
  epsilon = rand(1);
  if epsilon > greedParam
    #right now it's always picking the first of tied values... need to fix eventually.
    [qVal, action] = max(qOfActions);
  else
    action = unidrnd(numberOfActions);
  endif
endfunction

#Main body for SARSA

printf("Beginning run with %d episodes, e=%d, lr=%d, decay=%d \n", episodeMax, greedParam, learningRate, decayRate)

# Initialize Q states is stored as a 3D array
q = zeros(mapHeight, mapWidth, numberOfActions);
qTerminal = 0;

#Initialize the list for storing the number of steps each episode takes to terminate
scores = zeros(episodeMax,1);

#Iterate over episodeMax episodes
for i = 1:episodeMax
  #Initialize state S
  x = 1; y = 4; r = 0; terminate = false;
  #Pick an action e-greedy from S
  action = chooseAction(x, y, q);
  
  #iterate until we reach the end state
  while terminate == false
    [xPrime, yPrime, reward, terminate] = step(x, y, action);
    actionPrime = chooseAction(xPrime, yPrime, q);
    q(y, x, action) = q(y, x, action) + learningRate * (reward + (decayRate * q(yPrime, xPrime, actionPrime) - q(y, x, action)));
    x = xPrime; y = yPrime; action = actionPrime;
    scores(i)++;
  endwhile
  if mod(i,50) == 49
    printf("Finished run: %d steps \n", scores(i))
  endif
  terminate  = false;
endfor

#This bit is still pretty hacky
stochscores = scores;
save("-append", "SARSAscores","stochscores","q");
printf("Completed run. Final approach took %d steps \n",scores(episodeMax))

scoreRange = 1:episodeMax;
plot(scoreRange, scores(scoreRange));
xlabel("Episode");
ylabel("Steps used");
title("Learning of 4-step SARSA agent in Windy Canyon");
  