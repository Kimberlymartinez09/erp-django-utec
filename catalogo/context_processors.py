# catalogo/context_processors.py
from typing import Any


def carrito_info(request) -> dict[str, Any]:
    carrito = request.session.get('carrito', {})
    total_items = sum(int(item.get('cantidad', 0)) for item in carrito.values())
    return {
        'carrito_total_items': total_items,
        'carrito_total_productos': len(carrito),
    }