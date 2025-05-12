# review/serializers.py
from rest_framework import serializers
from .models import Review
from django.contrib.contenttypes.models import ContentType

class ReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = ['id', 'author', 'rating', 'comment', 'type', 'object_id', 'created_at']
        read_only_fields = ['author', 'created_at']

    def create(self, validated_data):
        type_str = validated_data.pop('type')
        object_id = validated_data['object_id']
        try:
            content_type = ContentType.objects.get(model=type_str.lower())
        except ContentType.DoesNotExist:
            raise serializers.ValidationError({'type': 'Invalid type specified.'})

        validated_data['content_type'] = content_type
        validated_data['type'] = type_str
        return super().create(validated_data)
