from django.shortcuts import render, redirect
from django.views.generic import View
from django.contrib.auth import authenticate,login,logout
from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAdminUser
from .models import *
from .serializers import UserSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound
from rest_framework.views import APIView
from django.contrib import messages
from django.urls import reverse_lazy
from django.core.exceptions import PermissionDenied

class UserRegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
# View para testar o uso do JWT,
# deverá ser excluída juntamente com sua respectiva rota 
class ProtectedView(APIView): 
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({'message': f'Olá {request.user.username}, você está autenticado com JWT!'})

def UserLogout(request):

    logout(request)
    return redirect('get-token')

class UserUpdateView(generics.UpdateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

class UserListView(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser]

class UserRetriverView(generics.RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]
    def get_object(self):
        """
        Sobrescreve o método get_object para buscar o usuário através do
        JWT (request.user), que já contém o pk do usuário autenticado.
        """
        user = self.request.user  # O user é populado automaticamente com o JWT

        if not user:
            raise NotFound("Usuário não encontrado.")

        return user
    

class UserDeleteView(generics.DestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminUser]



class LoginWebView(View):
    template_name = 'login_web.html'

    def get(self, request):
        return render(request, self.template_name)

    def post(self, request):
        email = request.POST.get('email')
        password = request.POST.get('password')

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            messages.error(request, "Usuário com esse email não foi encontrado.")
            return render(request, self.template_name)

        user = authenticate(request, username=user.email, password=password)

        if user is not None:
            login(request, user)
            # messages.success(request, "Login realizado com sucesso.")
            # Verificar o parâmetro 'next' para redirecionamento
            next_url = request.POST.get('next', request.GET.get('next', ''))
            # Garantir que a URL é segura para evitar redirecionamentos maliciosos
            if next_url:
                return redirect(next_url)
           
            if user.has_perm('subscription.has_active_subscription'):
                messages.success(request, "Bem vindo de volta!")
                return redirect('owner-management')
            else:
                messages.error(request, "Você não tem permissão para acessar este recurso.")
                return render(request, self.template_name)
        else:

            messages.error(request, "Senha incorreta.")
            return render(request, self.template_name)
        
class LogoutWebView(View):
    template_name = 'login_web.html'

    def get(self, request):
        return render(request, self.template_name)

    def post(self, request):
        if request.user.is_authenticated:
            logout(request)
            messages.success(request, "Logout realizado com sucesso.")
        return redirect(reverse_lazy('login-web'))