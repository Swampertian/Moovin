from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/imoveis/', include('imoveis.urls')),
    path('api/tenants/', include('tenant.urls')),
]