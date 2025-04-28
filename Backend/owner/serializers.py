from rest_framework import serializers
from .models import Owner
from immobile.serializers import ImmobileSerializer  # Certifique-se de importar o certo!

class OwnerSerializer(serializers.ModelSerializer):
    properties = ImmobileSerializer(many="True",)

    class Meta:
        model = Owner
        fields = '__all__'
