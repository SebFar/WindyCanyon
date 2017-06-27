#Display the outputs

load("SARSAscores");
scorerange = 1:250;
plot(scorerange,scores(51:300),scorerange,eightscores(51:300),scorerange,ninescores(51:300),scorerange,stochscores(51:300));
xlabel("Episode");
ylabel("Steps used");
title("Learning of SARSA agents in Windy Canyon, without first 50 episodes");