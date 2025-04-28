
from .models import Owner
from .serializers import OwnerSerializer
from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import AllowAny
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import action
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework import authentication
class CsrfExemptSessionAuthentication(SessionAuthentication):
    def enforce_csrf(self, request):
        # não faz nada — vai pular a checagem de CSRF
        return
class OwnerViewSet(ModelViewSet):
    queryset = Owner.objects.all()
    serializer_class = OwnerSerializer

authentication_classes = (CsrfExemptSessionAuthentication, BasicAuthentication)
permission_classes = (AllowAny,)