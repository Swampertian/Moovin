
from users.views import ProtectedView
from django.contrib import admin
from django.urls import path, include
from visits.views import visit_create_view
urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/immobile/', include('immobile.urls')),
    path('api/tenants/', include('tenant.urls')),
    path('api/users/',include('users.urls')),
    path('api/owners/',include('owner.urls')),
    path('api/reviews/',include ('review.urls')),
    path('api/visits/', include('visits.urls')),
    path('api/subscriptions/',include('subscriptions.urls')),
    path('api/notifications/', include('notification.urls')),
]

