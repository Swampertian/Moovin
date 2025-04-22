from rest_framework import serializers
from .models import Owner
from imoveis.models import Imovel

# Serializer compacto para cada imóvel do locador
class ImovelResumoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Imovel
        fields = ['id', 'titulo', 'status', 'preco_aluguel', 'data_cadastro']

class OwnerSerializer(serializers.ModelSerializer):
    imoveis = serializers.SerializerMethodField()
    total_properties = serializers.ReadOnlyField()
    total_alugados = serializers.SerializerMethodField()

    class Meta:
        model = Owner
        fields = [
            'id',
            'name',
            'phone',
            'city',
            'state',
            'about_me',
            'revenue_generated',
            'rented_properties',
            'rated_by_tenants',
            'recommended_by_tenants',
            'fast_responder',
            'member_since',
            'total_properties',
            'total_alugados',
            'imoveis',
        ]

    def get_imoveis(self, obj):
        ativos = Imovel.objects.filter(locador=obj.user, status='disponivel').order_by('-data_cadastro')
        return ImovelResumoSerializer(ativos, many=True).data

    def get_total_alugados(self, obj):
        return Imovel.objects.filter(locador=obj.user, status='alugado').count()
