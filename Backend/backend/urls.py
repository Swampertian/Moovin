
from users.views import ProtectedView
from django.contrib import admin
from django.urls import path, include
from tenant.views import TenantCreateView
from owner.views import OwnerCreateView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/immobile/', include('immobile.urls')),
    path('api/tenants/', include('tenant.urls')),
    path('api/users/',include('users.urls')),
    path('api/owners/',include('owner.urls')),
    path('api/reviews/',include ('review.urls')),
    path('api/visits/', include('visits.urls')),
    path('api/tenant/tenant_create', TenantCreateView.as_view(), name='tenant-create'),
    path('api/owner/owner_create', OwnerCreateView.as_view(), name='owner-create'),
    
]

