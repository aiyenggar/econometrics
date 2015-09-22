# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 23:43:47 2015

@author: aiyenggar
"""
import random
import numpy
import statsmodels.api as sm
import matplotlib.pyplot as plt

XDIVERGENCE = 173
XMEANFACTOR = 239
MUDIVERGENCE = 17

SAMPLE_START = 100
SAMPLE_END = 1000
SAMPLE_STEP = 100
"""
Model is as follows
y = beta0 + beta1 * x + mu
"""
def modelCompute(xVal, b0, b1, u):
    return b0 + b1 * xVal + u

beta0 = 10.0
beta1 = 5.0
mu = -35

xMean = random.random() * XMEANFACTOR
xVariance = random.random() * XDIVERGENCE
muMean = 0.0
muVariance = random.random() * MUDIVERGENCE

sampleSize = []
samples = SAMPLE_START
while samples <= SAMPLE_END:
    sampleSize.append(samples)
    samples += SAMPLE_STEP

estBeta0 = []
estBeta1 = []
totalFigures = 2
nextFigure = 1
#plt.subplot(totalFigures, 1, nextFigure)
#nextFigure += 1
#plt.xlabel("x")
#plt.ylabel("y")

for size in sampleSize:
    xValues = numpy.random.normal(xMean, numpy.sqrt(xVariance), size)
    muValues = numpy.random.normal(muMean, numpy.sqrt(muVariance), size)
    yValues = []
    for index in range(0, size):
        yValues.append(modelCompute(xValues[index], beta0, beta1, muValues[index]))  

#    plt.plot(xValues, yValues)
    X = sm.add_constant(xValues)
    estimate = sm.OLS(yValues, X).fit()
    estBeta0.append(estimate.params[0])
    estBeta1.append(estimate.params[1])

plt.subplot(totalFigures, 1, nextFigure)
nextFigure += 1
plt.xlabel("Sample Size")
plt.ylabel("Beta 0")
plt.axhline(beta0, color='r')
plt.plot(sampleSize, estBeta0, 'g-')

plt.subplot(totalFigures, 1, nextFigure)
plt.xlabel("Sample Size")
plt.ylabel("Beta 1")
plt.axhline(beta1, color='r')
plt.plot(sampleSize, estBeta1, 'b-')