# owner/admin.py
from django.contrib import admin
from .models import Owner
from immobile.models import Immobile  # ajuste o import para o seu app immobile

# 1) Cria o inline para Immobile
class ImmobileInline(admin.TabularInline):
    model = Immobile
    extra = 1               # quantos campos em branco mostrar
    fields = [
        'property_type', 'zip_code', 'city', 'street', 'number',
        'bedrooms', 'bathrooms', 'rent', 'status','area'
    ]
    readonly_fields = ['id_immobile']

# 2) Registra o OwnerAdmin incluindo o inline
@admin.register(Owner)
class OwnerAdmin(admin.ModelAdmin):
    list_display = ['name', 'phone', 'city', 'state']
    inlines = [ImmobileInline]  # aqui ele insere a seção de imóveis
