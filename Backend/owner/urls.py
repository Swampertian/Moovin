from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    OwnerViewSet,
    OwnerStatisticsView,
    OwnerCalendarView,
    OwnerChartsView,
    OwnerManagementView,
    OwnerManagementImmobileDetailView,
    OwnerVisitScheduleView  
)

router = DefaultRouter()
router.register(r'owners', OwnerViewSet, basename='owner')

urlpatterns = [
    path('', include(router.urls)),

    # Relatórios
    path('reports/statistics/', OwnerStatisticsView.as_view(), name='owner_statistics'),
    path('reports/calendar/', OwnerCalendarView.as_view(), name='owner_calendar'),
    path('reports/charts/', OwnerChartsView.as_view(), name='owner_charts'),

    # Gestão de imóveis
    path('management/', OwnerManagementView.as_view(), name='owner-management'),
    path('management/<str:pk>/detail', OwnerManagementImmobileDetailView.as_view(), name='owner-management-property-detail'),

    # Agendamento de Visitas
    path('visit_schedule/', OwnerVisitScheduleView.as_view(), name='visit_schedule'),
]
