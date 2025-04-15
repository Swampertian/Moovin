from rest_framework import viewsets
from .models import Immobile
from .serializers import ImmobileSerializer
from django.http import HttpResponse
from django.views.generic import TemplateView
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import status


class RegisterView(TemplateView):
    template_name = 'immobile/register_step1.html'

class RegisterStep2View(TemplateView):
    template_name = 'immobile/register_step2.html'

class RegisterStep3View(TemplateView):
    template_name = 'immobile/register_step3.html'

def home(request):
    return HttpResponse("<h1>Bem-vindo à API de Imóveis</h1><p>Acesse <code>/immobile_api/immobile/</code> para ver os endpoints disponíveis.</p>")

class ImmobileViewSet(viewsets.ModelViewSet): #IZ CRUD
    queryset = Immobile.objects.all()
    serializer_class = ImmobileSerializer

    @action(detail=False, methods=['post'], url_path='complete-registration')
    def complete_registration(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            # Salva o imóvel e o proprietário
            immobile = serializer.save()
            
            # Processa as fotos
            photos = request.FILES.getlist('photos')
            for photo in photos:
                immobile.photos.create(image=photo)
            
            return Response({
                'status': 'success',
                'id': immobile.id,
                'message': 'Imóvel cadastrado com sucesso!'
            }, status=status.HTTP_201_CREATED)
            
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)
