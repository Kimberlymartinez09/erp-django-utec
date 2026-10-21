# ventas/views.py
"""Vistas de la app ventas — W02 (inicio) + W07.

Inicio: index (W02).
Lectura: VentaListView y VentaDetailView.
Escritura (crear_venta): W08.
"""
from django.shortcuts import render
from django.views.generic import DetailView, ListView

from .models import Venta


def index(request):
    """Página de inicio de ventas (W02)."""
    return render(request, 'ventas/index.html')


class VentaListView(ListView):
    """Lista paginada de ventas en orden cronológico inverso."""

    model               = Venta
    template_name       = 'ventas/lista.html'
    context_object_name = 'ventas'
    paginate_by         = 20

    def get_queryset(self):
        """Pre-carga cliente para evitar N+1 en la tabla de ventas."""
        return (
            Venta.objects
            .select_related('cliente')
            .order_by('-fecha')
        )


class VentaDetailView(DetailView):
    """Detalle de una venta con todas sus líneas de producto."""

    model               = Venta
    template_name       = 'ventas/detalle.html'
    context_object_name = 'venta'
    pk_url_kwarg        = 'venta_id'

    def get_queryset(self):
        """Pre-carga cliente y prefetch líneas de detalle."""
        return (
            Venta.objects
            .select_related('cliente')
            .prefetch_related('detalles__producto')
        )