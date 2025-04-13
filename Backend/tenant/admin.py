from django.contrib import admin
from .models import Tenant

@admin.register(Tenant)
class TenantAdmin(admin.ModelAdmin):
    list_display = ('name', 'age', 'city', 'state', 'user_rating', 'properties_rented')
    search_fields = ('name', 'city', 'state')
    list_filter = ('prefers_studio', 'prefers_apartment', 'prefers_shared_rent', 'accepts_pets')

