from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ImmobileViewSet  

router = DefaultRouter()
router.register(r'immobile', ImmobileViewSet)

urlpatterns = [
    path('', include(router.urls)),  # Sem o /api/
]

