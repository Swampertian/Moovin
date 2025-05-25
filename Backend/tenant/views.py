
from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.viewsets import ModelViewSet
from .models import Tenant
from .serializers import TenantSerializer
from django.contrib.auth.models import User
from rest_framework.permissions import AllowAny
from rest_framework import generics


class TenantViewSet(ModelViewSet):
    queryset = Tenant.objects.all()
    serializer_class = TenantSerializer
    permission_classes=[IsAuthenticated]

    @action(detail=True, methods=['patch'], url_path='update-profile')
    def update_profile(self, request, pk=None):
        tenant = self.get_object()
        serializer = self.get_serializer(tenant, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    @action(detail=False, methods=['get'], url_path='me')
    def me(self,request):
        try:
            profile = Tenant.objects.get(user=request.user)
        except Tenant.DoesNotExist:
            return Response({"detail": "Perfil não encontrado."}, status=status.HTTP_404_NOT_FOUND)

        serializer = self.get_serializer(profile)
        return Response(serializer.data)
    
    @action(detail=False, methods=['patch'], url_path='me/update-profile')
    def update_me_profile(self, request):
        try:
            tenant = Tenant.objects.get(user=request.user)
        except Tenant.DoesNotExist:
            return Response({"detail": "Perfil não encontrado."}, status=status.HTTP_404_NOT_FOUND)
        
        serializer = self.get_serializer(tenant, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class TenantCreateView(generics.CreateAPIView):
    queryset = Tenant.objects.all()
    serializer_class = TenantSerializer
    permission_classes = [AllowAny]

    def create(self, request, *args, **kwargs):
        print("REQUISIÇÃO RECEBIDA:", request.data)
        return super().create(request, *args, **kwargs)
