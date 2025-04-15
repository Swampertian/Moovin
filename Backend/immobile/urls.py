from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ImmobileViewSet  
from .views import RegisterView, RegisterStep2View, RegisterStep3View
router = DefaultRouter()
router.register(r'immobile', ImmobileViewSet)

urlpatterns = [
    path('', include(router.urls)),  # endpoint vai ser /immobile_api/immobile/
    path('register/', RegisterView.as_view(), name='register'),
    path('register/step2/', RegisterStep2View.as_view(), name='register_step2'),
    path('register/step3/', RegisterStep3View.as_view(), name='register_step3'),
]

