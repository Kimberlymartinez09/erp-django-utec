# Diagrama Entidad-RelaciÃ³n â€” ERP Django
## Espiral 2 Â· Aprobado por: MC. RomÃ¡n Fernando LÃ³pez GonzÃ¡lez
## Fecha de aprobaciÃ³n: 15/10/2026
## Belman Martinez Kimberly Fernanda

```mermaid
erDiagram
    CATEGORIA {
        bigint id PK
        varchar nombre UK
        text descripcion
    }

    PROVEEDOR {
        bigint id PK
        varchar nombre
        varchar contacto
        varchar correo UK
        varchar telefono
        bool activo
        datetime creado
    }

    CLIENTE {
        bigint id PK
        varchar nombre
        varchar correo UK
        varchar telefono
        bool activo
        datetime creado
    }

    PRODUCTO {
        bigint id PK
        varchar nombre
        decimal precio
        int stock
        bigint categoria_id FK
        bigint proveedor_id FK
        bool activo
        datetime creado
    }

    VENTA {
        bigint id PK
        bigint cliente_id FK
        datetime fecha
    }

    DETALLE_VENTA {
        bigint id PK
        bigint venta_id FK
        bigint producto_id FK
        int cantidad
        decimal precio_unitario
    }

    PEDIDO {
        bigint id PK
        varchar numero_pedido UK
        bigint cliente_id FK
        varchar estado
        datetime fecha_pedido
        date fecha_entrega
        decimal total_pagado
    }

    CONFIGURACION_ERP {
        bigint id PK
        varchar nombre_empresa
        varchar rfc
        varchar moneda
        decimal iva_porcentaje
        image logo
    }

    CATEGORIA   ||--o{ PRODUCTO      : "clasifica"
    PROVEEDOR   |o--o{ PRODUCTO      : "suministra"
    CLIENTE     ||--o{ VENTA         : "realiza"
    CLIENTE     ||--o{ PEDIDO        : "genera"
    VENTA       ||--|{ DETALLE_VENTA : "contiene"
    PRODUCTO    ||--o{ DETALLE_VENTA : "incluido en"
```

## Cardinalidades

| RelaciÃ³n | Tipo | DescripciÃ³n |
|---|---|---|
| Categoria â†’ Producto | 1:N obligatorio | Un producto siempre tiene categorÃ­a |
| Proveedor â†’ Producto | 1:N opcional | Un producto puede no tener proveedor |
| Cliente â†’ Venta | 1:N | Una venta siempre tiene cliente |
| Cliente â†’ Pedido | 1:N | Un pedido siempre tiene cliente |
| Venta â†’ DetalleVenta | 1:N obligatorio | Una venta tiene al menos 1 lÃ­nea |
| Producto â†’ DetalleVenta | 1:N | Un producto puede aparecer en N ventas |

## Notas de diseÃ±o

- `Venta.total` es una propiedad calculada, no un campo de BD (decisiÃ³n D-04)
- `DetalleVenta.precio_unitario` se almacena por integridad histÃ³rica (D-06)
- `ConfiguracionERP` es un singleton (siempre pk=1) (D-07)
- `Pedido` se implementa en la Espiral 5 (W13-W15)

## Firma de aprobaciÃ³n

| Rol | Nombre | Fecha | Observaciones |
|---|---|---|---|
| Desarrollador | Belman Martinez Kimberly Fernanda | | |
| Asesor (PO) | MC. RomÃ¡n Fernando LÃ³pez GonzÃ¡lez | | |
