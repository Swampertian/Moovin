from django import forms
from .models import Immobile

class ImmobileForm(forms.ModelForm):
    class Meta:
        model = Immobile
        fields = '__all__'
