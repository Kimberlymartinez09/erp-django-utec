"""Vistas de la app productos — W02 (inicio) + W07 (lectura) + W08 (escritura).

Inicio: index (W02).
Lectura: ListView y DetailView con select_related y paginación (W07).
Escritura: Create, Update y Delete con LoginRequiredMixin (W08).
Borrado: LoginRequiredMixin + PermissionRequiredMixin (W08, parte 4).
"""
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.auth.views import redirect_to_login
from django.core.exceptions import PermissionDenied
from django.shortcuts import render
from django.urls import reverse_lazy
from django.views.generic import (
    CreateView, DeleteView, DetailView, ListView, UpdateView
)

from .forms import ProductoForm
from .models import Producto


def index(request):
    """Página de inicio de productos (W02)."""
    return render(request, 'productos/index.html')


class ProductoListView(ListView):
    """Lista paginada de productos activos."""

    model               = Producto
    template_name       = 'productos/lista.html'
    context_object_name = 'productos'
    paginate_by         = 20

    def get_queryset(self):
        """Devuelve productos activos con FKs pre-cargadas (evita N+1)."""
        return (
            Producto.objects
            .select_related('categoria', 'proveedor')
            .filter(activo=True)
            .order_by('nombre')
        )


class ProductoDetailView(DetailView):
    """Detalle de un producto por ID de URL."""

    model               = Producto
    template_name       = 'productos/detalle.html'
    context_object_name = 'producto'
    pk_url_kwarg        = 'producto_id'

    def get_queryset(self):
        """Pre-carga FKs para evitar queries adicionales en el template."""
        return Producto.objects.select_related('categoria', 'proveedor')


class ProductoCreateView(LoginRequiredMixin, CreateView):
    """Formulario para crear un producto. LoginRequiredMixin PRIMERO."""

    model         = Producto
    form_class    = ProductoForm
    template_name = 'productos/crear.html'
    success_url   = reverse_lazy('productos:lista')

    def form_valid(self, form):
        response = super().form_valid(form)
        messages.success(
            self.request,
            f'Producto "{self.object.nombre}" creado exitosamente.'
        )
        return response


class ProductoUpdateView(LoginRequiredMixin, UpdateView):
    """Formulario para editar un producto existente."""

    model         = Producto
    form_class    = ProductoForm
    template_name = 'productos/producto_form.html'
    pk_url_kwarg  = 'producto_id'
    success_url   = reverse_lazy('productos:lista')

    def form_valid(self, form):
        response = super().form_valid(form)
        messages.success(
            self.request,
            f'Producto "{self.object.nombre}" actualizado.'
        )
        return response


class ProductoDeleteView(LoginRequiredMixin, PermissionRequiredMixin, DeleteView):
    """Confirmación y borrado de un producto. Requiere POST con CSRF.

    LoginRequiredMixin SIEMPRE primero: anónimos van al login.
    raise_exception=True: autenticados sin permiso reciben 403.
    """

    model              = Producto
    template_name      = 'productos/producto_confirm_delete.html'
    pk_url_kwarg       = 'producto_id'
    success_url        = reverse_lazy('productos:lista')
    permission_required = 'productos.delete_producto'
    raise_exception    = True

    def handle_no_permission(self):
        """Anónimo → login (302); autenticado sin permiso → 403."""
        if not self.request.user.is_authenticated:
            return redirect_to_login(
                self.request.get_full_path(),
                self.get_login_url(),
                self.get_redirect_field_name(),
            )
        raise PermissionDenied

    def form_valid(self, form):
        nombre   = self.object.nombre
        response = super().form_valid(form)
        messages.success(self.request, f'Producto "{nombre}" eliminado.')
        return response