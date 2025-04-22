from django.urls import path
from . import views

urlpatterns = [
    path('register/part1/', views.ImmobileRegisterPart1View.as_view(), name='register_immobile_part1'),
    path('register/part2/<int:immobile_id>/', views.ImmobileRegisterPart2View.as_view(), name='register_immobile_part2'),
    path('immobile_detail/<int:pk>/', views.ImmobileDetailTemplateView.as_view(), name='immobile_detail'),
    path('immobile_edit/<int:pk>/', views.ImmobileEditViewPart1.as_view(), name='immobile_edit'),
    path('immobile/edit/part2/<int:pk>/', views.ImmobileEditViewPart2.as_view(), name='immobile_edit_part2'),
    path('immobile_delete/<int:pk>/', views.ImmobileDeleteView.as_view(), name='immobile_delete'),
    # Adicione outras URLs específicas do seu app 'immobile' aqui
]

