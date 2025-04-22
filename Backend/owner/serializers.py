from rest_framework import serializers
from .models import Owner
from immobile.models import Immobile

class ImmobileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Immobile
        fields = '__all__'

class OwnerSerializer(serializers.ModelSerializer):
    properties = ImmobileSerializer(many=True, read_only=True)
    total_properties = serializers.IntegerField(read_only=True)
    active_properties = serializers.IntegerField(read_only=True)

    class Meta:
        model = Owner
        fields = [
            'id', 'name', 'phone', 'city', 'state', 'about_me',
            'revenue_generated', 'rented_properties', 'rated_by_tenants',
            'recommended_by_tenants', 'fast_responder',
            'total_properties', 'active_properties', 'properties'
        ]
