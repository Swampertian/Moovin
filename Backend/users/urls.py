from django.contrib import admin
from django.urls import path, include
from .views import *
urlpatterns = [
    path('register/', UserRegisterView.as_view(), name= 'user-register' ),
]
