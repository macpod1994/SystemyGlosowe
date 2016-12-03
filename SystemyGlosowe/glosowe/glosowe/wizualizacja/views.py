# # -*- coding: utf-8 -*-

import os
import sys

# sys.path.insert(0,'D:\\studia\\IV_rok\\glosowe\\SystemyGlosowe\\glosowe\\glosowe\\python')

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0,os.path.join(BASE_DIR, "python"))


import re
from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from cepstralne_fun import create_DB

  




def index(request):
    return render(request,'index.html', {})

def record(request):
    
    
    return HttpResponse("record dziala")

 
def fileMatch(request, file):
    plik = str(file)
    w = re.compile(r'(\D*)(\d*)')
    parts = w.search(file).groups()
    wsp, glob = create_DB(file)
    
    print wsp
    print glob
    print type(wsp[0])
    
    wsp =  [float(x) for x in wsp]
    glob = [float(x) for x in glob]
    print type(wsp[0])
    response={}
    response['file'] = plik
    response['wsp'] = wsp
    response['glob'] = glob
    return JsonResponse(response)
# Create your views here.


       