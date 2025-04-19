from django.urls import path
from . import views

urlpatterns = [
    path('register/part1/', views.ImmobileRegisterPart1View.as_view(), name='register_immobile_part1'),
    path('register/part2/<int:immobile_id>/', views.ImmobileRegisterPart2View.as_view(), name='register_immobile_part2'),
    # Adicione outras URLs específicas do seu app 'immobile' aqui
]

