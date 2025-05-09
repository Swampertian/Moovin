
from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.viewsets import ModelViewSet
from .models import Tenant
from .serializers import TenantSerializer
from django.contrib.auth.models import User

class TenantViewSet(ModelViewSet):
    queryset = Tenant.objects.all()
    serializer_class = TenantSerializer
    permission_classes=[IsAuthenticated] # Apenas usuários autenticados podem acessar essa view. A autenticação deve ser feita com JWT

    @action(detail=True, methods=['patch'], url_path='update-profile')
    def update_profile(self, request, pk=None):
        tenant = self.get_object()
        serializer = self.get_serializer(tenant, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    

    # Método para retornar os dados do perfil do usuário logado. Endpoit: '/tenants/profile/me'
    # O JWT está incluído na requisição. Assim o o django consegue acessar o id do usuário autenticado com 'request.user.id'
    @action(detail=False, methods=['get'], url_path='me')
    def me(self,request):
        try:
            profile = Tenant.objects.get(user=request.user)
        except Tenant.DoesNotExist:
            return Response({"detail": "Perfil não encontrado."}, status=status.HTTP_404_NOT_FOUND)

        serializer = self.get_serializer(profile)
        return Response(serializer.data)


