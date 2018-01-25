#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 01:32:26 2018

@author: josem
"""
import numpy as np
import os
import pandas as pd

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
y = np.asarray([b["Survived"]]).T

data = np.append(X,y,axis=1)

import torch
import torch.nn as nn
from torch.autograd import Variable
import torch.utils.data

# Hyper Parameters
input_size = 8
hidden_size = 20
num_classes = 1
num_epochs = 50
batch_size = 100
learning_rate = 0.001

## arreglar aixo
train_dataset = torch.FloatTensor(data)

train_loader = torch.utils.data.DataLoader(dataset=train_dataset,
                                           batch_size=batch_size,
                                           shuffle=True)

class Net(nn.Module):
    def __init__(self, input_size, hidden_size, num_classes):
        super(Net, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.relu = nn.Sigmoid()
        self.fc2 = nn.Linear(hidden_size, num_classes)

    def forward(self, x):
        out = self.fc1(x)
        out = self.relu(out)
        out = self.fc2(out)
        return out

net = Net(input_size, hidden_size, num_classes)

# Loss and Optimizer
criterion = nn.MSELoss()
optimizer = torch.optim.Adam(net.parameters(), lr=learning_rate)

# Train the Model
for epoch in range(num_epochs):
    for i, d in enumerate(train_loader):
        # Convert torch tensor to Variable
        images = Variable(d[:,:8])
        labels = Variable(d[:,8:])

        # Forward + Backward + Optimize
        optimizer.zero_grad()  # zero the gradient buffer
        outputs = net(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        if (i+1) % 5 == 0:
            print ('Epoch [%d/%d], Step [%d/%d], Loss: %.4f'
                   %(epoch+1, num_epochs, i+1, len(train_dataset)//batch_size, loss.data[0]))

ex = torch.FloatTensor([0,0,1,0,1,0,0,1]).view(-1,8)
ex = Variable(ex)
print(net(ex))
