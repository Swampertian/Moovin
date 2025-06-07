from django.urls import path, include
from .views import TenantCreateView
from .views import *
from . import views
urlpatterns = [
    path('tenant_create', TenantCreateView.as_view(), name='tenant-create'),
    # Imagens
    path('owner-photo-upload/', TenantPhotoUploadAPIView.as_view(), name='tenant-photo-upload'),
    path('tenants/<int:owner_id>/photos/', TenantPhotoListAPIView.as_view(), name='tenant-photo-list'),
    path('tenant_photo/blob/<int:photo_id>/', views.ServeImageBlobAPIView.as_view(), name='serve_image_blob_api'),    
]