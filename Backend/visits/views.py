from rest_framework import viewsets, permissions
from .models import Visit
from .serializers import VisitSerializer
##from .permissions import IsPremiumOwner
from rest_framework.exceptions import ValidationError
from datetime import datetime
from rest_framework.parsers import MultiPartParser, FormParser

class VisitViewSet(viewsets.ModelViewSet):
    queryset = Visit.objects.all()
    serializer_class = VisitSerializer
    ##permission_classes = [permissions.IsAuthenticated, IsPremiumOwner]
    parser_classes = [MultiPartParser, FormParser]

    def get_queryset(self):
        return Visit.objects.filter(owner=self.request.user)

    def perform_create(self, serializer):
        date = serializer.validated_data['date']
        time = serializer.validated_data['time']
        immobile = serializer.validated_data['immobile']

        if Visit.objects.filter(immobile=immobile, date=date, time=time).exists():
            raise ValidationError("Já existe uma visita agendada para este imóvel neste horário.")

        if date < datetime.now().date():
            raise ValidationError("Não é possível agendar visitas para datas passadas.")

        serializer.save(owner=self.request.user)
