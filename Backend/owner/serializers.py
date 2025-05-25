# from rest_framework import serializers
# from .models import Owner
# from immobile.serializers import ImmobileSerializer  # Certifique-se de importar o certo!

# class OwnerSerializer(serializers.ModelSerializer):
#     properties = ImmobileSerializer(many="True",)

#     class Meta:
#         model = Owner
#         fields = '__all__'

from rest_framework import serializers
from .models import Owner
from immobile.serializers import ImmobileSerializer

class OwnerSerializer(serializers.ModelSerializer):
    properties = ImmobileSerializer(many=True, read_only=True)

    class Meta:
        model = Owner
        fields = [
            'id', 'user', 'name', 'phone', 'city', 'state', 'about_me',
            'revenue_generated', 'rented_properties', 'rated_by_tenants',
            'recommended_by_tenants', 'fast_responder', 'properties'
        ]
        read_only_fields = ['id', 'user']
