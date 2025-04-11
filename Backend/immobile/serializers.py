from rest_framework import serializers
from .models import Immobile

class ImmobileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Immobile
        fields = '__all__'
