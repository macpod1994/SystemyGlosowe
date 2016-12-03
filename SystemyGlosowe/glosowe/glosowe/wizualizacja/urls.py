from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'record/', views.record, name='record'),
    url(r'record_model/(?P<name>\w+)', views.recordModel, name='recordModel'),
    url(r'fileMatch/(?P<file>\w+)', views.fileMatch, name='fileMatch'),
]