from rest_framework import serializers
from .models import Tenant

class TenantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tenant
        fields = [
            'id', 'name', 'age', 'job', 'city', 'state',
            'about_me', 'prefers_studio', 'prefers_apartment',
            'prefers_shared_rent', 'accepts_pets', 'user_rating',
            'properties_rented', 'rated_by_landlords', 'recommended_by_landlords',
            'favorited_properties', 'fast_responder', 'member_since'
        ]

