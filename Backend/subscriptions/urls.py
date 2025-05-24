
from .views import ProtectedView
from django.urls import path, include
urlpatterns = [
    path('',ProtectedView.as_view())
]

