# -*- coding: utf-8 -*-
"""
Created on Fri Feb 24 23:47:52 2017

@author: JoseMaria
"""

import numpy as np
import os
import pandas as pd

def sigmoid(x):
    return 1/(1+np.exp(-x))

def grad(x):
    return x*(1-x)

home = os.path.expanduser("~/Code/R/optimisation-projects/neural-networks")    
os.chdir(os.path.join(home,"data"))

a = pd.read_csv("titanic_train.csv")
b = a[["Sex","Pclass","Age","SibSp","Parch","Survived"]].dropna()

ages = ["child","adult","old"]

b[ages[0]] = b["Age"].apply(lambda x: 1 if 0<x<15 else 0.) 
b[ages[1]] = b["Age"].apply(lambda x: 1 if 16<x<50 else 0.)
b[ages[2]] = b["Age"].apply(lambda x: 1 if 51<x<200 else 0.)
b["male"] = b["Sex"].apply(lambda x: 1 if x=="male" else 0.)
b["female"] = b["Sex"].apply(lambda x: 0 if x=="male" else 1.)
b["1r"] = b["Pclass"].apply(lambda x: 1 if x==1 else 0.)
b["2n"] = b["Pclass"].apply(lambda x: 1 if x==2 else 0.)
b["3d"] = b["Pclass"].apply(lambda x: 1 if x==3 else 0.)
b["No survived"] = b["Survived"].apply(lambda x: 1 if x==0 else 0.)

X = np.asarray([b[ages[0]],b[ages[1]],b[ages[2]],b["female"],b["male"],b["1r"],b["2n"],b["3d"]]).T
y = np.asarray([b["Survived"],b["No survived"]]).T

np.random.seed(1)## to replicate the algorithm

syn0 = 2*np.random.random((8,20))-1
syn1 = 2*np.random.random((20,20))-1
syn2 = 2*np.random.random((20,2))-1
biaix1=2*np.random.random(20) -1
biaix2=2*np.random.random(20) -1
biaix3=2*np.random.random(2) -1
learning=0.5
biaix1=0
biaix2=0
biaix3=0

for j in range(100000):
    ## FF
    l0 = X
    z1=np.dot(l0,syn0)+biaix1
    l1 = sigmoid(z1)
    z2=np.dot(l1,syn1)+biaix2
    l2 = sigmoid(z2)
    z3=np.dot(l2,syn2)+biaix3
    l3 = sigmoid(z3)
    
    ## C function
    l3err = 1/2*(((y[:,0] - l3[:,0])**2+(y[:,1] - l3[:,1])**2))
 
    if j%10000 == 0:
        print(np.mean(np.abs(l3err))*100)

    ## BP
    l3_d=(l3-y)*grad(l3)
    l2err = np.dot(l3_d,np.transpose(syn2))
    l2_d = l2err*grad(l2)
    l1err = np.dot(l2_d,np.transpose(syn1))
    l1_d = l1err*grad(l1)
    
    ## Grads
    syn2 -=1/len(y[:,0])*learning*np.dot(np.transpose(l2),l3_d)
    syn1 -=1/len(y[:,0])*learning*np.dot(np.transpose(l1),l2_d)
    syn0 -=1/len(y[:,0])*learning*np.dot(np.transpose(l0),l1_d)    
    #biaix1 -=1/len(y[:,0])*learning*np.sum(l1_d, axis=0)
    #biaix2 -=1/len(y[:,0])*learning*np.sum(l2_d, axis=0)
    #biaix3 -=1/len(y[:,0])*learning*np.sum(l3_d, axis=0)

print("Output is: "+str(l3))


results=[]
for x in l3:
    if(x[0]>x[1]):
        results.append(1)
    else:
        results.append(0)
b["results"] = results
accuracy = 1-np.sum(abs(b["results"]-b["Survived"]))/714
print("The accuracy is:",accuracy)    

def predict(x,biaix1,biaix2,biaix3,syn0,syn1,syn2):
    l1 = sigmoid(np.dot(x,syn0)+biaix1)
    l2 = sigmoid(np.dot(l1,syn1)+biaix2)
    l3 = sigmoid(np.dot(l2,syn2)+biaix3)
    return l3

predict([0,0,1,0,1,0,0,1],biaix1,biaix2,biaix3,syn0,syn1,syn2)
