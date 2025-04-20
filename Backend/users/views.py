from django.shortcuts import render, redirect
from django.contrib.auth import authenticate,login,logout
from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAdminUser
from .models import *
from .serializers import UserSerializer
from rest_framework.views import APIView
from rest_framework.response import Response


class UserRegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]


# View para testar o uso do JWT,
# deverá ser excluída juntamente com sua respectiva rota 
class ProtectedView(APIView): 
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({'message': f'Olá {request.user.username}, você está autenticado com JWT!'})

def UserLogout(request):

    logout(request)
    return redirect('get-token')

class UserUpdateView(generics.UpdateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

class UserListView(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser]

class UserRetriverView(generics.RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

class UserDeleteView(generics.DestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser]
