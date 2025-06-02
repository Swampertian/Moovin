from django.urls import path, include
from .views import TenantCreateView

urlpatterns = [
    path('tenant_create', TenantCreateView.as_view(), name='tenant-create'),
]