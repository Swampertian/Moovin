from rest_framework import serializers
from .models import *
from tenant.models import *
from owner.models import *
from django.contrib.auth import get_user_model

User = get_user_model()
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id','password','email','user_type','name']
        extra_kwargs = {'password':{'write_only':True}}
    
    def create(self,validated_data):
        user_type = validated_data.pop('user_type', None)

        user = User.objects.create_user(**validated_data)
        if user_type == 'Inquilino':
            Tenant.objects.create(user=user)
        elif user_type == 'Proprietario':
            Owner.objects.create(user=user)

        return user