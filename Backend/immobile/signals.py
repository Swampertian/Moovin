from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Rental
from notification.models import Notification

@receiver(post_save, sender=Rental)
def create_rental_notification(sender, instance, created, **kwargs):
    if created:
        # Notificar o proprietário do imóvel
        owner = instance.immobile.owner.user
        Notification.objects.create(
            user=owner,
            title="Nova Solicitação de Aluguel",
            message=f"O inquilino {instance.tenant.name} solicitou o aluguel do imóvel {instance.immobile}.",
            type="RENTAL_REQUEST",
            related_object_id=instance.id,
            related_object_type="Rental"
        )