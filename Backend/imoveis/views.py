from rest_framework import viewsets
from .models import Imovel
from .serializers import ImovelSerializer

class ImovelViewSet(viewsets.ModelViewSet):
    queryset = Imovel.objects.all()
    serializer_class = ImovelSerializer

