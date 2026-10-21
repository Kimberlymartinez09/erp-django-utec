# ventas/urls.py
"""URLs de la app ventas — W02 (inicio) + W07 (Lista + Detalle)."""
from django.urls import path
from . import views

app_name = 'ventas'

urlpatterns = [
    # Inicio (W02) — ahora apunta a la lista
    path('inicio/',
         views.VentaListView.as_view(),
         name='inicio'),

    # Lectura (W07)
    path('',
         views.VentaListView.as_view(),
         name='lista'),
    path('<int:venta_id>/',
         views.VentaDetailView.as_view(),
         name='detalle'),

    # Escritura (W08) — comentadas hasta implementarlas
    # path('nueva/',                   views.crear_venta,               name='crear'),
    # path('<int:venta_id>/eliminar/', views.VentaDeleteView.as_view(), name='eliminar'),
]