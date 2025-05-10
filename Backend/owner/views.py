
from .models import Owner
from .serializers import OwnerSerializer
from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import AllowAny
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import action
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework import authentication
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404

class OwnerViewSet(ModelViewSet):
    queryset = Owner.objects.all()
    serializer_class = OwnerSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Owner.objects.filter(user=self.request.user)

    @action(detail=False, methods=['get'], url_path='me')
    def me(self, request):
        owner = get_object_or_404(Owner, user=request.user)
        serializer = self.get_serializer(owner)
        return Response(serializer.data)