
from django.urls import reverse
from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.viewsets import ModelViewSet
from .models import *
from .serializers import TenantSerializer
from django.contrib.auth.models import User
from rest_framework.permissions import AllowAny
from rest_framework import generics
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from django.http import HttpResponse
from rest_framework.parsers import MultiPartParser, FormParser

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
    
    @action(detail=False, methods=['get'], url_path='profile/me')
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
class ServeImageBlobAPIView(APIView):
    """
    Retorna o conteúdo binário da foto.
    """
    def get(self, request, photo_id, format=None):
        try:
            photo = TenantPhoto.objects.get(id=photo_id)
            return HttpResponse(photo.image_blob, content_type=photo.content_type)
        except TenantPhoto.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)


    def serve_image_blob(request, photo_id):
        photo = get_object_or_404(TenantPhoto, id=photo_id)
        print("SERVE IMAGE BLOB:")
        print("  Photo ID:", photo.id)
        print("  Content Type:", photo.content_type)
        print("  First 20 bytes of blob:", photo.image_blob[:20] if photo.image_blob else None)
        return HttpResponse(photo.image_blob, content_type=photo.content_type)
class TenantPhotoListAPIView(APIView):
    def get(self, request, owner_id):
        try:
            tenant = Tenant.objects.get(id=owner_id)
        except Tenant.DoesNotExist:
            return Response({'error': 'Owner not found'}, status=status.HTTP_404_NOT_FOUND)

        photos = TenantPhoto.objects.filter(tenant=tenant)
        data = []

        for photo in photos:
            photo_url = request.build_absolute_uri(
                reverse('serve-owner-photo', args=[photo.id])
            )
            data.append({
                'photo_id': photo.id,
                'uploaded_at': photo.uploaded_at,
                'url': photo_url,
            })

        return Response(data, status=status.HTTP_200_OK)
class TenantPhotoUploadAPIView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, format=None):
        uploaded_file = request.FILES.get('photo')
        tenant_id = request.data.get('tenant_id')

        if not uploaded_file or not tenant_id:
            return Response({'error': 'Missing photo or tenant_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            owner = Tenant.objects.get(id=tenant_id)
        except Tenant.DoesNotExist:
            return Response({'error': 'Owner not found'}, status=status.HTTP_404_NOT_FOUND)

        photo = TenantPhoto.objects.create(
            owner=owner,
            image_blob=uploaded_file.read(),
            content_type=uploaded_file.content_type
        )

        return Response({'message': 'Photo uploaded successfully', 'photo_id': photo.id}, status=status.HTTP_201_CREATED)