from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/immobile/', include('immobile.urls')),
    path('api/tenants/', include('tenant.urls')),
    path('api/owners/',include('owner.urls')),
]