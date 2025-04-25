from django.contrib import admin
from django.urls import path, include
from users.views import ProtectedView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('imoveis.urls')),
    path('api/tenants/', include('tenant.urls')),
    path('api/users/',include('users.urls')),
]
