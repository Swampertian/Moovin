from django.shortcuts import render,redirect, get_object_or_404
from django.views.generic import TemplateView
from django.views.generic.edit import CreateView, UpdateView, FormView
from django.urls import reverse,reverse_lazy
from .forms import ImmobileRegisterPart1Form, ImmobileRegisterPart2Form, ImmobileForm, ImmobilePhotoForm
from .models import Immobile, ImmobilePhoto
from django.http import HttpResponse
from django.views.generic import DetailView
from django.views import View
# views.py (na sua app 'immobile')
from rest_framework.views import APIView
from rest_framework import status
from django.shortcuts import get_object_or_404
from .models import Immobile, ImmobilePhoto
from .serializers import ImmobileSerializer, ImmobilePhotoSerializer
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from django.shortcuts import get_object_or_404

class ImmobileViewSet(viewsets.ModelViewSet):
    queryset = Immobile.objects.all()
    serializer_class = ImmobileSerializer
    def get_queryset(self):
        # Apenas imóveis criados pelo usuário logado
        return Immobile.objects.filter(user=self.request.user)
    @action(detail=False, methods=['get'], url_path='me')
    def me(self, request):
        immobiles = self.get_queryset()
        serializer = self.get_serializer(immobiles, many=True)
        return Response(serializer.data)
class ImmobileListAPIView(APIView):
    """
    Lista todos os imóveis.
    """
    def get(self, request, format=None):
        immobiles = Immobile.objects.all()
        serializer = ImmobileSerializer(immobiles, many=True, context={'request': request})
        return Response(serializer.data)

class ImmobileDetailAPIView(APIView):
    """
    Retorna os detalhes de um imóvel.
    """
    def get(self, request, id_immobile, format=None):
        immobile = get_object_or_404(Immobile, id_immobile=id_immobile)
        serializer = ImmobileSerializer(immobile, context={'request': request})
        return Response(serializer.data)

class ServeImageBlobAPIView(APIView):
    """
    Retorna o conteúdo binário da foto.
    """
    def get(self, request, photo_id, format=None):
        try:
            photo = ImmobilePhoto.objects.get(id=photo_id)
            return Response(photo.image_blob, content_type=photo.content_type)
        except ImmobilePhoto.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)


def serve_image_blob(request, photo_id):
        photo = get_object_or_404(ImmobilePhoto, id=photo_id)
        print("SERVE IMAGE BLOB:")
        print("  Photo ID:", photo.id)
        print("  Content Type:", photo.content_type)
        print("  First 20 bytes of blob:", photo.image_blob[:20] if photo.image_blob else None)
        return HttpResponse(photo.image_blob, content_type=photo.content_type)

#Mostra os atributos de um imoveil
class ImmobileDetailTemplateView(TemplateView):
    template_name = 'immobile/immobile_detail.html'
    context_object_name = 'immobile'  

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        immobile = get_object_or_404(Immobile, pk=pk)
        context[self.context_object_name] = immobile
        return context
#Adição/Create, são dividas em 2 telas, no templates tem 3 mas uma(registerstep1) nao foi usada pois so pegava os dados do usuario
class ImmobileRegisterPart1View(CreateView):
    model = Immobile
    form_class = ImmobileRegisterPart1Form 
    template_name = 'immobile/register_step2.html'
    success_url = reverse_lazy('register_immobile_part2')

    def form_valid(self, form):
        immobile = form.save()
        # Use reverse_lazy para construir a URL com o immobile_id
        return redirect(reverse_lazy('register_immobile_part2', kwargs={'immobile_id': immobile.id_immobile}))

    def form_invalid(self, form):
        return self.render_to_response(self.get_context_data(form=form))

class ImmobileRegisterPart2View(FormView):
    form_class = ImmobilePhotoForm
    template_name = 'immobile/register_step3.html'

    def get_immobile(self):
        immobile_id = self.kwargs.get('immobile_id')
        immobile = get_object_or_404(Immobile, id_immobile=immobile_id)
        print("REGISTER STEP 2 - Get Immobile:")
        print("  Immobile ID:", immobile.id_immobile)
        return immobile

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['immobile'] = self.get_immobile()
        print("REGISTER STEP 2 - Get Context Data:")
        print("  Immobile in Context:", context['immobile'])
        return context

    def form_valid(self, form):
        immobile = self.get_immobile()
        image_file = self.request.FILES.get('image')
        print("REGISTER STEP 2 - Form Valid:")
        print("  Immobile ID:", immobile.id_immobile)
        print("  Uploaded Files:", self.request.FILES)
        if image_file:
            print("  Processing Image:", image_file.name, image_file.content_type, image_file.size)
            image_blob = image_file.read()
            print("  First 20 bytes of blob:", image_blob[:20])
            immobile_photo = ImmobilePhoto(
                immobile=immobile,
                image_blob=image_blob,
                content_type=image_file.content_type
            )
            immobile_photo.save()
            print("  ImmobilePhoto saved with ID:", immobile_photo.id)
            return redirect(reverse('immobile_detail', kwargs={'pk': immobile.pk}))
        else:
            form.add_error('image', 'Por favor, selecione uma imagem.')
            print("  Form Error: No image selected.")
            return self.form_invalid(form)

    def form_invalid(self, form):
        print("REGISTER STEP 2 - Form Invalid:")
        print("  Errors:", form.errors)
        return self.render_to_response(self.get_context_data(form=form))

    def serve_image_blob(request, photo_id):
        photo = get_object_or_404(ImmobilePhoto, id=photo_id)
        print("SERVE IMAGE BLOB:")
        print("  Photo ID:", photo.id)
        print("  Content Type:", photo.content_type)
        print("  First 20 bytes of blob:", photo.image_blob[:20] if photo.image_blob else None)
        return HttpResponse(photo.image_blob, content_type=photo.content_type)


#Cria rotas para 2 telas de edição, no caso sao as telas de adiçao soq preenchidas
class ImmobileEditViewPart1(UpdateView):
    model = Immobile
    form_class = ImmobileRegisterPart1Form
    template_name = 'immobile/register_step2.html'

    def get_object(self, queryset=None):
        pk = self.kwargs.get('pk')
        return get_object_or_404(Immobile, pk=pk)

    def form_valid(self, form):
        immobile = form.save()
        return redirect(reverse('immobile_edit_part2', kwargs={'pk': immobile.pk}))

class ImmobileEditViewPart2(UpdateView):
    model = Immobile
    form_class = ImmobileRegisterPart2Form
    template_name = 'immobile/register_step3.html'
    photo_form_class = ImmobilePhotoForm

    def get_object(self, queryset=None):
        pk = self.kwargs.get('pk')
        return get_object_or_404(Immobile, pk=pk)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        if 'photo_form' not in kwargs:
            context['photo_form'] = self.photo_form_class()  # Removi instance=self.object
        context['existing_photos'] = self.object.photos_blob.all()  # Para listar as fotos existentes (BLOB)
        return context

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        form_part2 = self.get_form()
        photo_form = self.photo_form_class(request.POST, request.FILES) # Removi instance=self.object
        if form_part2.is_valid() and photo_form.is_valid():
            return self.form_valid(form_part2, photo_form)
        else:
            return self.form_invalid(form_part2, photo_form)

    def form_valid(self, form_part2, photo_form):
        immobile = form_part2.save()
        print("FILES:", self.request.FILES)
        
        for image_file in self.request.FILES.getlist('image'):
            print("Processing file:", image_file.name, image_file.size, image_file.content_type)
            blob_data = image_file.read()
            print("First 20 bytes of blob_data:", blob_data[:20]) 
        try:
            photo = ImmobilePhoto.objects.create(
                immobile=immobile,
                image_blob=blob_data,
                content_type=image_file.content_type
            )
            print("Photo object created:", photo.id, photo.content_type, photo.image_blob[:20] if photo.image_blob else None) # Check if saved
        except Exception as e:
            print("Error during ImmobilePhoto creation:", e)
        return redirect(reverse('immobile_detail', kwargs={'pk': immobile.pk}))

    def form_invalid(self, form_part2, photo_form):
        return self.render_to_response(self.get_context_data(form=form_part2, photo_form=photo_form))

#Deletar cruD
class ImmobileDeleteView(View):
    def post(self, request, pk):
        immobile = get_object_or_404(Immobile, pk=pk)
        immobile.delete()
        return redirect(reverse_lazy('home'))  
    
#class RegisterView(TemplateView):
    #template_name = 'immobile/register_step1.html'

class RegisterStep2View(TemplateView):
    template_name = 'immobile/register_step2.html'

class RegisterStep3View(TemplateView):
    template_name = 'immobile/register_step3.html'

def home(request):
    return HttpResponse("<h1>Bem-vindo à API de Imóveis</h1><p>Acesse <code>/immobile_api/immobile/</code> para ver os endpoints disponíveis.</p>")


