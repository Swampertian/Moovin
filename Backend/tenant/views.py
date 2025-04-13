from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.viewsets import ModelViewSet
from .models import Tenant
from .serializers import TenantSerializer
from django.contrib.auth.models import User

class TenantViewSet(ModelViewSet):
    queryset = Tenant.objects.all()
    serializer_class = TenantSerializer
    
