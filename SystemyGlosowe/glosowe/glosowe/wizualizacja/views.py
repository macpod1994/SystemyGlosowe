# # -*- coding: utf-8 -*-

import os
import sys
import re
import sounddevice as sd
import numpy as np
import scipy.io as sio
import time

# sys.path.insert(0,'D:\\studia\\IV_rok\\glosowe\\SystemyGlosowe\\glosowe\\glosowe\\python')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0,os.path.join(BASE_DIR, "python"))

from django.shortcuts import render
from cepstralne import Alg
from django.http import HttpResponse, JsonResponse

a = Alg()

duration = 3  # seconds
sd.default.samplerate = a.fpr
sd.default.channels = 1

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

    myrecording = sd.rec(duration * a.fpr, dtype='float64')
    sd.wait()
    sd.play(myrecording, a.fpr)
    time.sleep(4)

    syg = a.cisza(myrecording[:,0])
    Cx = a.cepstrum(syg)
    nr, glob = a.dtw(Cx[0], a.C, a.Nramek)
    for i in range(4):
        if np.isinf(glob[i]):
            glob[i] = 10000

    response = {}

    glob = [float(x) for x in glob]

    response['glob'] = glob
    response['nazwa'] = a.slowa[nr]

    return JsonResponse(response)

def fileModel(request):

    a.C = []
    a.Nramek = []

    for i in range(4):  # Tworzenie bazy danych
        y = sio.loadmat('../glosowe/SG/{}_Karolina_1'.format(a.slowa[i]))
        y = y['y']
        y = y[:, 0]
        syg = a.cisza(y)
        Cx = a.cepstrum(syg)

        a.C.append(Cx[0])
        a.Nramek.append(Cx[1])

    return HttpResponse("record dziala")

def fileMatch(request, file):
    plik = str(file)

    y = sio.loadmat('../glosowe/SG/' + plik)

    y = y['y']
    y = y[:, 0]
    syg = a.cisza(y)
    Cx = a.cepstrum(syg)
    nr, glob = a.dtw(Cx[0], a.C, a.Nramek)

    for i in range(4):
        if np.isinf(glob[i]):
            glob[i] = 10000

    glob = [float(x) for x in glob]
    response={}
    response['glob'] = glob
    response['nazwa'] = a.slowa[nr]

    return JsonResponse(response)