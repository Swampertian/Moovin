from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import OwnerViewSet, OwnerStatisticsView, OwnerCalendarView, OwnerChartsView, OwnerManagementView,OwnerManagementImmobileDetailView

router = DefaultRouter()
router.register(r'owners', OwnerViewSet, basename='owner')

urlpatterns = [
    path('', include(router.urls)),
    path('reports/statistics/', OwnerStatisticsView.as_view(), name='owner_statistics'),
    path('reports/calendar/', OwnerCalendarView.as_view(), name='owner_calendar'),
    path('reports/charts/', OwnerChartsView.as_view(), name='owner_charts'),
    path('management/', OwnerManagementView.as_view(), name='owner-management'),
    path('management/<str:pk>/detail', OwnerManagementImmobileDetailView.as_view(), name='owner-management-property-detail'),
]
