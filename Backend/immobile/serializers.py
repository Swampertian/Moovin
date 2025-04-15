from rest_framework import serializers
from .models import Immobile
from rest_framework import serializers
from .models import Immobile, Owner, Photo  # Supondo que você tenha esses modelos

class OwnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Owner
        fields = [
            'full_name',
            'email',
            'phone',
            'cpf_cnpj',
            'postal_code',
            'state',
            'city',
            'street',
            'number',
            'no_number'
        ]

class PhotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Photo
        fields = ['image']

class ImmobileSerializer(serializers.ModelSerializer):
    owner = OwnerSerializer()
    photos = PhotoSerializer(many=True, required=False)
    
    # Campos do imóvel
    property_type = serializers.CharField(source='get_property_type_display')
    air_conditioning = serializers.BooleanField()
    garage = serializers.BooleanField()
    pool = serializers.BooleanField()
    furnished = serializers.BooleanField()
    pet_friendly = serializers.BooleanField()
    nearby_market = serializers.BooleanField()
    nearby_bus = serializers.BooleanField()
    internet = serializers.BooleanField()

    class Meta:
        model = Immobile
        fields = [
            'id',
            'owner',
            'property_type',
            'zip_code',
            'state',
            'city',
            'street',
            'number',
            'no_number',
            'bedrooms',
            'bathrooms',
            'area',
            'rent',
            'air_conditioning',
            'garage',
            'pool',
            'furnished',
            'pet_friendly',
            'nearby_market',
            'nearby_bus',
            'internet',
            'description',
            'additional_rules',
            'photos',
            'created_at'
        ]
        depth = 1

    def create(self, validated_data):
        # Separa os dados do proprietário
        owner_data = validated_data.pop('owner')
        
        # Cria ou atualiza o proprietário
        owner, _ = Owner.objects.update_or_create(
            cpf_cnpj=owner_data['cpf_cnpj'],
            defaults=owner_data
        )
        
        # Cria o imóvel
        immobile = Immobile.objects.create(owner=owner, **validated_data)
        
        return immobile

    def update(self, instance, validated_data):
        owner_data = validated_data.pop('owner', None)
        
        if owner_data:
            owner_serializer = OwnerSerializer(instance.owner, data=owner_data, partial=True)
            owner_serializer.is_valid(raise_exception=True)
            owner_serializer.save()
        
        return super().update(instance, validated_data)

class ImmobileSerializer(serializers.ModelSerializer):
    owner = OwnerSerializer()
    
    class Meta:
        model = Immobile
        fields = '__all__'
        extra_kwargs = {'photos': {'required': False}}

    def create(self, validated_data):
        owner_data = validated_data.pop('owner')
        # Cria o proprietário (ajuste conforme seu modelo)
        owner = Owner.objects.create(**owner_data)
        
        # Cria o imóvel
        immobile = Immobile.objects.create(owner=owner, **validated_data)
        return immobile
