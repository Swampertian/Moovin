from django.contrib import admin
from .models import Owner

@admin.register(Owner)
class OwnerAdmin(admin.ModelAdmin):
    list_display = ['name', 'phone', 'city', 'state', 'revenue_generated']
    search_fields = ['name', 'city', 'state']
