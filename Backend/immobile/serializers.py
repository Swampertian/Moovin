from rest_framework import serializers
from .models import Immobile

class ImmobileSerializer(serializers.ModelSerializer):
    title = serializers.SerializerMethodField()
    imageUrl = serializers.SerializerMethodField()

    class Meta:
        model = Immobile
        fields = '__all__'

    def get_title(self, obj):
        return f"{obj.property_type} em {obj.city} - {obj.street}, {obj.number or 'S/N'}"

    def get_imageUrl(self, obj):
        first_photo = obj.photos.first()
        if first_photo and first_photo.image:
            request = self.context.get('request')
            return request.build_absolute_uri(first_photo.image.url) if request else first_photo.image.url
        return None
