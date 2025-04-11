from rest_framework import viewsets
from .models import Immobile
from .serializers import ImmobileSerializer
from django.http import HttpResponse

def home(request):
    return HttpResponse("<h1>Bem-vindo à API de Imóveis</h1><p>Acesse <code>/immobile_api/immobile/</code> para ver os endpoints disponíveis.</p>")

class ImmobileViewSet(viewsets.ModelViewSet): #IZ CRUD
    queryset = Immobile.objects.all()
    serializer_class = ImmobileSerializer
