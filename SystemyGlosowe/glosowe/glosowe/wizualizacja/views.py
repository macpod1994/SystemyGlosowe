# # -*- coding: utf-8 -*-

import os
import sys
import re

import time

# sys.path.insert(0,'D:\\studia\\IV_rok\\glosowe\\SystemyGlosowe\\glosowe\\glosowe\\python')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0,os.path.join(BASE_DIR, "python"))

from django.shortcuts import render
from cepstralne_fun import create_DB, Alg
from django.http import HttpResponse, JsonResponse
import sounddevice as sd
import numpy as np

a = Alg()

duration = 3  # seconds
sd.default.samplerate = a.fpr
sd.default.channels = 1
sd.rec(200, dtype='float64')

def index(request):
    return render(request,'index.html', {})

def recordModel(request, name):
    if name == "lewo":
        a.C = []
        a.Nramek = []

    myrecording = sd.rec(duration * a.fpr, dtype='float64')
    sd.wait()
    sd.play(myrecording, a.fpr)
    time.sleep(4)

    syg = a.cisza(myrecording[:, 0])
    Cx = a.cepstrum(syg)

    a.C.append(Cx[0])
    a.Nramek.append(Cx[1])

    return HttpResponse("record dziala")

def record(request):

    print("begin")
    myrecording = sd.rec(duration * a.fpr, dtype='float64')
    print("start")
    sd.wait()
    print("play")
    sd.play(myrecording, a.fpr)
    time.sleep(4)

    print(np.shape(myrecording[:,0]))
    syg = a.cisza(myrecording[:,0])
    Cx = a.cepstrum(syg)
    nr, glob = a.dtw(Cx[0], a.C, a.Nramek)
    print(glob)
    for i in range(4):
        if np.isinf(glob[i]):
            glob[i] = 10000

    response = {}

    glob = [float(x) for x in glob]

    response['glob'] = glob
    response['nazwa'] = a.slowa[nr]

    print(response)

    return JsonResponse(response)

def fileMatch(request, file):
    plik = str(file)
    w = re.compile(r'(\D*)(\d*)')
    parts = w.search(file).groups()
    wsp, glob = create_DB(file)
    
    #print wsp
    #print glob
    #print type(wsp[0])
    
    wsp =  [float(x) for x in wsp]
    glob = [float(x) for x in glob]
    #print type(wsp[0])
    response={}
    response['file'] = plik
    response['wsp'] = wsp
    response['glob'] = glob
    return JsonResponse(response)
# Create your views here.