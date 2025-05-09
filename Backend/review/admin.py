from django.contrib import admin
from .models import Review

@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ('author', 'type', 'rating', 'created_at')
    list_filter = ('type', 'created_at')
    search_fields = ('comment', 'author__username')
