from django.shortcuts import redirect, get_object_or_404
from django.views.generic import TemplateView
from django.views.generic.edit import CreateView, UpdateView, FormView
from django.urls import reverse_lazy
from .forms import ImmobileRegisterPart1Form, ImmobileRegisterPart2Form, ImmobileForm, ImmobilePhotoForm
from .models import Immobile, ImmobilePhoto
from django.http import HttpResponse

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
    success_url = reverse_lazy('immobile_detail')  # Defina sua URL de sucesso
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
        photo_form = self.photo_form_class(request.FILES)

        print(f"request.FILES: {request.FILES}")
        print(f"form_part2.is_valid(): {form_part2.is_valid()}")
        print(f"photo_form.is_valid(): {photo_form.is_valid()}")

        if form_part2.is_valid() and photo_form.is_valid():
            return self.form_valid(form_part2, photo_form)
        else:
            return self.form_invalid(form_part2, photo_form)

    def form_valid(self, form_part2, photo_form):
        form_part2.save()
        for image in self.request.FILES.getlist('images'):
            print(f"Salvando imagem: {image.name}")
            ImmobilePhoto.objects.create(immobile=self.object, image=image)
        return redirect(self.get_success_url(), immobile_id=self.object.id_immobile)

    def form_invalid(self, form_part2, photo_form):
        return self.render_to_response(self.get_context_data(form=form_part2, photo_form=photo_form))

#class RegisterView(TemplateView):
    #template_name = 'immobile/register_step1.html'

class RegisterStep2View(TemplateView):
    template_name = 'immobile/register_step2.html'

class RegisterStep3View(TemplateView):
    template_name = 'immobile/register_step3.html'

def home(request):
    return HttpResponse("<h1>Bem-vindo à API de Imóveis</h1><p>Acesse <code>/immobile_api/immobile/</code> para ver os endpoints disponíveis.</p>")


