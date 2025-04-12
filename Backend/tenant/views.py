from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.viewsets import ModelViewSet
from .models import Tenant, TenantRating
from .serializers import TenantSerializer, TenantRatingSerializer
from django.contrib.auth.models import User

class TenantViewSet(ModelViewSet):
    queryset = Tenant.objects.all()
    serializer_class = TenantSerializer
    
    @action(detail=True, methods=['post'])
    def rate(self, request, pk=None):
        tenant = self.get_object()
        user = request.user
        
        if user.id == tenant.user.id:
            return Response(
                {"detail": "You cannot rate yourself."},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        rating_value = request.data.get('rating', 5)
        comment = request.data.get('comment', '')
        recommended = request.data.get('recommended', False)
        
        # Create or update rating
        rating, created = TenantRating.objects.update_or_create(
            tenant=tenant,
            rated_by=user,
            defaults={
                'rating': rating_value,
                'comment': comment,
                'recommended': recommended
            }
        )
        
        # Update tenant rating aggregate
        all_ratings = tenant.ratings.all()
        if all_ratings:
            tenant.user_rating = sum(r.rating for r in all_ratings) / len(all_ratings)
            tenant.rated_by_landlords = all_ratings.count()
            tenant.recommended_by_landlords = all_ratings.filter(recommended=True).count()
            tenant.save()
        
        serializer = TenantRatingSerializer(rating)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def favorite_property(self, request, pk=None):
        tenant = self.get_object()
        tenant.favorited_properties += 1
        tenant.save()
        return Response({"status": "property favorited"})
    
    @action(detail=True, methods=['post'])
    def rent_property(self, request, pk=None):
        tenant = self.get_object()
        tenant.properties_rented += 1
        tenant.save()
        return Response({"status": "property rented"})