from django.views.generic import TemplateView
from django.shortcuts import render, redirect
from django.urls import reverse
from django.utils import timezone
from datetime import datetime, timedelta
from immobile.models import Immobile, Payment, Rental
from django.db.models import Sum
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import login
from users.models import User
from owner.models import Owner
from rest_framework import viewsets
from .models import Owner
from .serializers import OwnerSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import AllowAny
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import action
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework import authentication

class CsrfExemptSessionAuthentication(SessionAuthentication):
    def enforce_csrf(self, request):
        # não faz nada — vai pular a checagem de CSRF
        return
# class OwnerViewSet(ModelViewSet):
#     queryset = Owner.objects.all()
#     serializer_class = OwnerSerializer
#     authentication_classes = (CsrfExemptSessionAuthentication, BasicAuthentication)
#     permission_classes = (AllowAny,)

# API ViewSet for Owner
class OwnerViewSet(viewsets.ModelViewSet):
    queryset = Owner.objects.all()
    serializer_class = OwnerSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        owner = getattr(user, 'owner_profile', None).first()
        if owner:
            return Owner.objects.filter(id=owner.id)
        return Owner.objects.none()

# Statistics Page
class OwnerStatisticsView(LoginRequiredMixin, TemplateView):
    template_name = 'owner/statistics.html'
    login_url = '/api/users/token/'

    def dispatch(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            try:
                user = User.objects.get(id=3)
                login(request, user, backend='django.contrib.auth.backends.ModelBackend')
                messages.info(request, "Logged in as user ID 1 for testing purposes.")
            except User.DoesNotExist:
                messages.error(request, "User with ID 1 does not exist. Please create one.")
                return redirect(self.login_url)
        return super().dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        owner = getattr(user, 'owner_profile', None).first()

        if not owner:
            messages.error(self.request, "Você não está registrado como proprietário.")
            return context

        properties = Immobile.objects.filter(owner=owner)

        # Date filter
        start_date = self.request.GET.get('start_date', (timezone.now() - timedelta(days=30)).strftime('%Y-%m-%d'))
        end_date = self.request.GET.get('end_date', timezone.now().strftime('%Y-%m-%d'))

        # Validate date filter
        if self.request.GET.get('start_date') or self.request.GET.get('end_date'):
            if not (start_date and end_date):
                messages.error(self.request, "Preencha os dois campos de data para filtrar.")
                start_date = (timezone.now() - timedelta(days=30)).strftime('%Y-%m-%d')
                end_date = timezone.now().strftime('%Y-%m-%d')

        start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
        end_date = datetime.strptime(end_date, '%Y-%m-%d').date()

        # Total expected and received revenue
        total_expected = sum(prop.rent for prop in properties)
        payments = Payment.objects.filter(
            immobile__owner=owner,
            date_received__range=[start_date, end_date]
        )
        total_received = payments.aggregate(Sum('amount_received'))['amount_received__sum'] or 0

        # Property payment status
        property_data = []
        has_properties_in_range = False
        for prop in properties:
            prop_payments = payments.filter(immobile=prop)
            amount_received = prop_payments.aggregate(Sum('amount_received'))['amount_received__sum'] or 0
            status = "Pago" if amount_received >= prop.rent else "Não Pago"
            date_received = prop_payments.first().date_received if prop_payments.exists() else None
            if prop_payments.exists():
                has_properties_in_range = True
            property_data.append({
                'immobile': prop,
                'status': status,
                'valor_do_pagamento': amount_received,
                'data_do_pagamento': date_received if date_received else '-'
            })

        context.update({
            'properties': property_data,
            'total_expected': total_expected,
            'total_received': total_received,
            'start_date': start_date,
            'end_date': end_date,
            'no_properties_in_range': not has_properties_in_range and (self.request.GET.get('start_date') or self.request.GET.get('end_date'))
        })
        return context

    def post(self, request, *args, **kwargs):
        user = self.request.user
        owner = getattr(user, 'owner_profile', None).first()
        if not owner:
            messages.error(request, "Você não está registrado como proprietário.")
            return redirect(self.login_url)

        immobile_id = request.POST.get('immobile_id')
        amount_received = request.POST.get('amount_received')
        date_received = request.POST.get('date_received')

        try:
            immobile = Immobile.objects.get(id_immobile=immobile_id, owner=owner)
            Payment.objects.create(
                immobile=immobile,
                amount_received=float(amount_received),
                date_received=date_received
            )
            messages.success(request, "Pagamento registrado com sucesso!")
        except Exception as e:
            messages.error(request, f"Erro ao registrar pagamento: {str(e)}")

        return redirect('owner_statistics')

class OwnerCalendarView(LoginRequiredMixin, TemplateView):
    template_name = 'owner/calendar.html'
    login_url = '/api/users/token/'

    def dispatch(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            try:
                user = User.objects.get(id=3)
                login(request, user, backend='django.contrib.auth.backends.ModelBackend')
                messages.info(request, "Logged in as user ID 1 for testing purposes.")
            except User.DoesNotExist:
                messages.error(request, "User with ID 1 does not exist. Please create one.")
                return redirect(self.login_url)
        return super().dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        owner = getattr(user, 'owner_profile', None).first()

        if not owner:
            messages.error(self.request, "Você não está registrado como proprietário.")
            return context

        # Get month and year from query params or default to current
        month = self.request.GET.get('month', timezone.now().strftime('%Y-%m'))
        try:
            year, month = map(int, month.split('-'))
        except ValueError:
            year, month = timezone.now().year, timezone.now().month

        selected_date = datetime(year, month, 1)

        # Calculate previous and next months
        prev_month_date = selected_date - timedelta(days=1)
        prev_month = prev_month_date.strftime('%Y-%m')
        next_month_date = (selected_date.replace(day=28) + timedelta(days=4)).replace(day=1)
        next_month = next_month_date.strftime('%Y-%m')

        # Calculate previous and next years
        prev_year = str(year - 1)
        next_year = str(year + 1)

        from calendar import monthrange, monthcalendar
        _, num_days = monthrange(year, month)

        # Get today for highlighting
        today = timezone.now().date()
        is_current_month = (today.year == year and today.month == month)

        # Get calendar weeks
        month_calendar = monthcalendar(year, month)

        # Get all properties for this owner
        properties = Immobile.objects.filter(owner=owner)
        
        # Get all payments for this month
        month_payments = Payment.objects.filter(
            immobile__owner=owner,
            date_received__year=year,
            date_received__month=month
        )
        
        # Calculate total payments per property for the entire month
        property_payment_totals = {}
        for prop in properties:
            prop_payments = month_payments.filter(immobile=prop)
            total_paid = prop_payments.aggregate(Sum('amount_received'))['amount_received__sum'] or 0
            property_payment_totals[prop.id_immobile] = {
                'total_paid': total_paid,
                'expected': prop.rent,
                'is_fully_paid': total_paid >= prop.rent
            }
        
        # Get daily payments for calendar display
        payments = Payment.objects.filter(
            immobile__owner=owner,
            date_received__year=year,
            date_received__month=month
        )
        
        # Process calendar data with payment information
        calendar_weeks = []
        for week in month_calendar:
            week_data = []
            for day_num in week:
                if day_num == 0:
                    week_data.append({'day': 0})
                else:
                    day_date = datetime(year, month, day_num).date()
                    day_payments = payments.filter(date_received=day_date)
                    
                    # Calculate payment amount for this day
                    payment_amount = day_payments.aggregate(Sum('amount_received'))['amount_received__sum'] or 0
                    payment_count = day_payments.count()
                    
                    # Check if this day has any payments for properties that are not fully paid for the month
                    has_incomplete_payment = False
                    if payment_count > 0:  # Only check days with payments
                        for payment in day_payments:
                            property_id = payment.immobile.id_immobile
                            if not property_payment_totals[property_id]['is_fully_paid']:
                                has_incomplete_payment = True
                                break
                    
                    status = "Não Pago" if has_incomplete_payment else ""
                    
                    week_data.append({
                        'day': day_num,
                        'today': is_current_month and day_num == today.day,
                        'status': status,
                        'payments': payment_count,
                        'payment_amount': payment_amount
                    })
            calendar_weeks.append(week_data)

        # Generate month and year options for dropdowns
        months = [
            (i, datetime(2000, i, 1).strftime('%B')) for i in range(1, 13)
        ]
        years = list(range(year - 5, year + 6))  # 5 years before and after current year

        context.update({
            'calendar_weeks': calendar_weeks,
            'month': f"{year}-{month:02d}",
            'month_name': selected_date.strftime('%B'),
            'year': year,
            'prev_month': prev_month,
            'next_month': next_month,
            'prev_year': prev_year,
            'next_year': next_year,
            'months': months,
            'years': years,
        })
        return context

# Charts Page
class OwnerChartsView(LoginRequiredMixin, TemplateView):
    template_name = 'owner/charts.html'
    login_url = '/api/users/token/'

    def dispatch(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            try:
                user = User.objects.get(id=3)
                login(request, user, backend='django.contrib.auth.backends.ModelBackend')
                messages.info(request, "Logged in as user ID 1 for testing purposes.")
            except User.DoesNotExist:
                messages.error(request, "User with ID 1 does not exist. Please create one.")
                return redirect(self.login_url)
        return super().dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        owner = getattr(user, 'owner_profile', None).first()

        if not owner:
            messages.error(self.request, "Você não está registrado como proprietário.")
            return context

        properties = Immobile.objects.filter(owner=owner)

        # Obtain revenue data for the last 12 months
        today = timezone.now().date()
        end_date = today
        start_date = (today.replace(day=1) - timedelta(days=365)).replace(day=1)  # Get 12 full months

        # Generate all months in range for complete data
        revenue_data = []
        month_dates = []
        
        # Generate all month dates first
        current_date = start_date
        while current_date <= end_date:
            month_dates.append(current_date)
            # Move to first day of next month
            if current_date.month == 12:
                current_date = current_date.replace(year=current_date.year + 1, month=1)
            else:
                current_date = current_date.replace(month=current_date.month + 1)
        
        # For each month, calculate revenue
        for i, month_start in enumerate(month_dates):
            # Calculate month end
            if i == len(month_dates) - 1:  # Last month (current)
                month_end = end_date
            else:
                month_end = month_dates[i + 1] - timedelta(days=1)
            
            # Get payments for this month
            payments = Payment.objects.filter(
                immobile__owner=owner,
                date_received__range=[month_start, month_end]
            )
            total = payments.aggregate(Sum('amount_received'))['amount_received__sum'] or 0
            
            # Add to revenue data
            revenue_data.append({
                'month': month_start.strftime('%b %Y'),
                'revenue': float(total)  # Ensure it's a float for JS
            })

        # Revenue distribution by property type for the same period
        property_types = properties.values_list('property_type', flat=True).distinct()
        revenue_by_property_type = []
        for prop_type in property_types:
            if not prop_type:  # Skip if property type is None
                continue
                
            prop_payments = Payment.objects.filter(
                immobile__owner=owner,
                immobile__property_type=prop_type,
                date_received__range=[start_date, end_date]
            )
            total_revenue = prop_payments.aggregate(Sum('amount_received'))['amount_received__sum'] or 0
            
            # Only add if there's revenue for this property type
            if total_revenue > 0:
                revenue_by_property_type.append({
                    'property_type': prop_type if prop_type else 'Não Especificado',
                    'revenue': int(total_revenue)  # Convertendo para inteiro para evitar problemas com decimais
                })
        
        # If no property types with revenue, add default
        if not revenue_by_property_type:
            revenue_by_property_type.append({
                'property_type': 'Não Especificado',
                'revenue': 0
            })

        # Adicionar os dados JSON-safe ao contexto
        context.update({
            'revenue_data': revenue_data,
            'revenue_by_property_type': revenue_by_property_type,
            # Adicione estes dados processados para JavaScript
            'property_type_labels': [item['property_type'] for item in revenue_by_property_type],
            'property_type_values': [item['revenue'] for item in revenue_by_property_type],
        })
        
        return context

class OwnerManagementView(TemplateView):
    template_name = 'owner/management.html'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        try:
            # owner = Owner.objects.get(user=self.request.user)  # or request.user.id
            owner = Owner.objects.get(id=1)
            context['owner']=owner
            context['properties'] = Immobile.objects.filter(owner=owner)
        except Owner.DoesNotExist:
            context['properties'] = []
            # Optionally log the error or add error message to context
            context['error'] = 'Owner not found'
        return context

class OwnerManagementImmobileDetailView(TemplateView):
    template_name = 'owner/management_detail.html'
    
    def get_context_data(self, pk, **kwargs):
        context = super().get_context_data(**kwargs)
        try:
            immobile = Immobile.objects.get(id_immobile=pk)
            context['property'] = immobile
            try:
                rental = Rental.objects.get(immobile=immobile)
                context['rental'] = rental
            except Rental.DoesNotExist:
                context['rental'] = None
                # Optionally add message to context
                context['message'] = 'No rental found for this property'
            print(context['property'], context.get('rental'))
        except Immobile.DoesNotExist:
            context['property'] = None
            context['rental'] = None
            # Optionally add error message
            context['error'] = 'Property not found'
        return context