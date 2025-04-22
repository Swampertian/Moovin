from rest_framework.viewsets import ModelViewSet
from .models import Owner
from .serializers import OwnerSerializer

class OwnerViewSet(ModelViewSet):
    queryset = Owner.objects.all()
    serializer_class = OwnerSerializer

    def perform_create(self, serializer):
        serializer.save(user_id=self.request.user.id)