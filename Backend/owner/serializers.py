
from rest_framework import serializers
from .models import *
from immobile.serializers import ImmobileSerializer
from django.urls import reverse

class OwnerPhotoSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = OwnerPhoto
        fields = ['id', 'image_url','image_blob', 'content_type', 'uploaded_at']

    def get_image_url(self, obj):
        request = self.context.get('request')
        if request:
            return request.build_absolute_uri(reverse('serve_image_blob_api', kwargs={'photo_id': obj.id}))
        return None
    
class OwnerSerializer(serializers.ModelSerializer):
    properties = ImmobileSerializer(many=True, read_only=True)
    photosBlob = OwnerPhotoSerializer(many=True,read_only=True,source='photos_blob')
    class Meta:
        model = Owner
        fields = [
            'id', 'user', 'name', 'phone', 'city', 'state', 'about_me',
            'revenue_generated', 'rented_properties', 'rated_by_tenants',
            'recommended_by_tenants', 'fast_responder', 'properties','photosBlob',
        ]
        read_only_fields = ['id', 'user']
