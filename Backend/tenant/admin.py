from django.contrib import admin
from .models import Tenant, TenantRating

@admin.register(Tenant)
class TenantAdmin(admin.ModelAdmin):
    list_display = ('name', 'age', 'city', 'state', 'user_rating', 'properties_rented')
    search_fields = ('name', 'city', 'state')
    list_filter = ('prefers_studio', 'prefers_apartment', 'prefers_shared_rent', 'accepts_pets')

@admin.register(TenantRating)
class TenantRatingAdmin(admin.ModelAdmin):
    list_display = ('tenant', 'rated_by', 'rating', 'recommended', 'created_at')
    list_filter = ('rating', 'recommended')
    search_fields = ('tenant__name', 'rated_by__username')