from django.shortcuts import redirect, get_object_or_404
from django.views.generic import TemplateView
from django.views.generic.edit import CreateView, UpdateView, FormView
from django.urls import reverse,reverse_lazy
from .forms import ImmobileRegisterPart1Form, ImmobileRegisterPart2Form, ImmobileForm, ImmobilePhotoForm
from .models import Immobile, ImmobilePhoto
from django.http import HttpResponse
from django.views.generic import DetailView
from django.views import View
class ImmobileDetailTemplateView(TemplateView):
    template_name = 'immobile/immobile_detail.html'
    context_object_name = 'immobile'  # O nome da variável no template

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        immobile = get_object_or_404(Immobile, pk=pk)
        context[self.context_object_name] = immobile
        return context

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

class ImmobileRegisterPart2View(UpdateView, FormView):
    model = Immobile
    form_class = ImmobileRegisterPart2Form 
    template_name = 'immobile/register_step3.html'
    
    photo_form_class = ImmobilePhotoForm

    def get_object(self, queryset=None):
        return get_object_or_404(Immobile, id_immobile=self.kwargs['immobile_id'])

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        if 'photo_form' not in kwargs:
            context['photo_form'] = self.photo_form_class()
        return context

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        form_part2 = self.get_form()
        photo_form = self.photo_form_class(request.POST, request.FILES)

        print(f"request.FILES: {request.FILES}")
        print(f"photo_form.data: {photo_form.data}")
        print(f"photo_form.files: {photo_form.files}")
        print(f"photo_form.errors: {photo_form.errors}")
        print(f"form_part2.is_valid(): {form_part2.is_valid()}")
        print(f"photo_form.is_valid(): {photo_form.is_valid()}")

        if form_part2.is_valid() and photo_form.is_valid():
            return self.form_valid(form_part2, photo_form)
        else:
            return self.form_invalid(form_part2, photo_form)

    def form_valid(self, form_part2, photo_form):
        immobile = form_part2.save()  # Salva as informações do imóvel
        if 'image' in self.request.FILES:
            image_file = self.request.FILES.get('image')
            print(f"Salvando imagem: {image_file.name}")
            ImmobilePhoto.objects.create(immobile=immobile, image=image_file)
        return redirect(reverse('immobile_detail', kwargs={'pk': immobile.pk}))

    def form_invalid(self, form_part2, photo_form):
        return self.render_to_response(self.get_context_data(form=form_part2, photo_form=photo_form))

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

class ImmobileEditViewPart2(UpdateView, FormView):
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
            context['photo_form'] = self.photo_form_class(instance=self.object)
        return context

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        form_part2 = self.get_form()
        photo_form = self.photo_form_class(request.POST, request.FILES, instance=self.object)
        if form_part2.is_valid() and photo_form.is_valid():
            return self.form_valid(form_part2, photo_form)
        else:
            return self.form_invalid(form_part2, photo_form)

    def form_valid(self, form_part2, photo_form):
        immobile = form_part2.save()
        for image in self.request.FILES.getlist('image'):
            ImmobilePhoto.objects.create(immobile=immobile, image=image)
        return redirect(reverse('immobile_detail', kwargs={'pk': immobile.pk}))

    def form_invalid(self, form_part2, photo_form):
        return self.render_to_response(self.get_context_data(form=form_part2, photo_form=photo_form))

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


