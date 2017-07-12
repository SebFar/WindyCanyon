# WindyCanyon
Code sets up the 'Windy Canyon' environment from Sutton and Barto Chapter 6
and implements a SARSA, Q-learning, and ESARSA algorithm to learn the optimal
path for both the stochastic and deterministic variants of the 4-step and 8-step games.

Important variables:
    q is a 7x10xn matrix of mapHeight, mapWidth, actions
    canyonMap is 7x10 matrix of the windspeeds
    actions are integers 1-n where first game uses 1-4, second 1-8, last 1-9
functions:
    takeStep moves the agent by one action and applies the wind:
        x, y, action, stochastic, canyonMap -> x, y, reward, terminate
    chooseAction picks an epsilon-greedy action:
        x, y, q, epsilon, numberOfActions -> action
    SARSAEV finds the expectation of the next step for ESARSA:
        x, y, q, epsilon, numberOfActions -> expectation
    doARun performs a complete learning loop depending on which learner is asked for:
        episodeMax, discountFactor, q, numberOfActions, stochastic, typeOfAlgorithm -> scores
    findPathName helps the data savers and display functions get the right filenames
        numberOfActions, stochastic -> file
    dataSaver appends the most recent run to file for later analysis
        scores, numberOfActions, stochastic, typeOfAlgorithm -> True
    dataAggregator Returns a score array averaged over the different runs recorded for this configuration
        numberOfActions, stochastic -> averagedScores
    graphDisplay helps show each subplot
        stochastic, numberOfActions, position, startGraphs, title -> True
    dataDisplay displays graphs
    
    Main body cycles through configurations and then displays and saves the graphs
