from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'record/', views.record, name='record'),
    url(r'fileMatch/(?P<file>\w+)', views.fileMatch, name='fileMatch'),


]