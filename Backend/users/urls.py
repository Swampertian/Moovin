from django.contrib import admin
from django.urls import path, include
from .views import *
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('register', UserRegisterView.as_view(), name= 'user-register' ),
    path('token',TokenObtainPairView.as_view(),name='get-token'),
    path('token/refresh',TokenRefreshView.as_view(),name='refresh'),
    path('logout',UserLogout,name='logout'),
    path('edit/<str:pk>',UserUpdateView.as_view(),name='edit-user'),
    path('all',UserListView.as_view(),name='user-list'),
    path('user',UserRetriverView.as_view(),name='get-user'),
    path('destroy/<str:pk>',UserDeleteView.as_view(),name='delete-user'),
    path('request-email-verification/',RequestEmailVerification.as_view(),name='request-verify-email'),
    path('verify-email-code/', VerifyEmailCode.as_view(), name='verify-email-code'),
]
