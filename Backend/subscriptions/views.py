from django.shortcuts import render
from rest_framework.views import APIView
from .permissions import HasActiveSubscription
from rest_framework.response import Response

class ProtectedView(APIView): 
    permission_classes = [HasActiveSubscription]

    def get(self, request):
        return Response({'message': f'Olá {request.user.name}, você possui assinatura ativa!'})