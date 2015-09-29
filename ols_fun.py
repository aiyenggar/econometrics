# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 23:43:47 2015

@author: aiyenggar
"""
import random
import numpy
import statsmodels.api as sm
import matplotlib.pyplot as plt
import datetime

NUM_SAMPLES = 100
HIST_BINS = 25
XDIVERGENCE = 173
XMEANFACTOR = 239
UDIVERGENCE = 25

SAMPLE_START = 100
SAMPLE_STEP = 100
SAMPLE_END = 100

"""
Model is as follows
y = beta0 + beta1 * x + u
"""
def modelCompute(xVal, b0, b1, u):
    return b0 + b1 * xVal + u

random.seed(datetime.datetime(1980, 11, 8, 6, 4, 0))

beta0 = 10.0
beta1 = 5.0

xMean = random.random() * XMEANFACTOR
xVariance = random.random() * XDIVERGENCE
uMean = 0.0
uVariance = random.random() * UDIVERGENCE

sampleSize = []
samples = SAMPLE_START
while samples <= SAMPLE_END:
    sampleSize.append(samples)
    samples += SAMPLE_STEP

estBeta0 = []
estBeta1 = []
totalFigures = 1
nextFigure = 1

for size in sampleSize:
    fixX = True
    xValues = []
    for iteration in range(0, NUM_SAMPLES):
        if ((fixX == True and len(xValues) == 0) or (fixX == False)):
            xValues = numpy.random.normal(xMean, numpy.sqrt(xVariance), size)    
        uValues = numpy.random.normal(uMean, numpy.sqrt(uVariance), size)
        yValues = []
        for index in range(0, size):
            yValues.append(modelCompute(xValues[index], beta0, beta1, uValues[index]))  
    
        X = sm.add_constant(xValues)
        estimate = sm.OLS(yValues, X).fit()
        estBeta0.append(estimate.params[0])
        estBeta1.append(estimate.params[1])

    plt.hist(uValues, HIST_BINS, color=numpy.random.rand(3,1))
    plt.title("NumSamples= "  + str(NUM_SAMPLES) + " SampleSize= " + str(size) + "\nError Term (u) Histogram")
    plt.xlabel("Value")
    plt.ylabel("Frequency")
    plt.show()
    
    plt.hist(estBeta1, HIST_BINS, color=numpy.random.rand(3,1))
    plt.title("NumSamples= "  + str(NUM_SAMPLES) + " SampleSize= "+ str(size) + " \nBeta1 Histogram")
    plt.xlabel("Value")
    plt.ylabel("Frequency")
    plt.show()
