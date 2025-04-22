from rest_framework.viewsets import ModelViewSet
from .models import Owner
from .serializers import OwnerSerializer

class OwnerViewSet(ModelViewSet):
    queryset = Owner.objects.all()
    serializer_class = OwnerSerializer

