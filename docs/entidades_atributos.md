# Entidades y Atributos — ERP Django
## Espiral 2 · Modelo Entidad-Relación

Total: 8 entidades.

## 1. Categoria

| Atributo | Tipo | Restricciones |
|---|---|---|
| id | bigint | PK, autoincremental |
| nombre | varchar(100) | Obligatorio, único |
| descripcion | text | Opcional |

## 2. Proveedor

| Atributo | Tipo | Restricciones |
|---|---|---|
| id | bigint | PK, autoincremental |
| nombre | varchar(150) | Obligatorio |
| contacto | varchar(100) | Opcional |
| correo | varchar(254) | Obligatorio, único |
| telefono | varchar(20) | Opcional |
| activo | bool | Por defecto True |
| creado | datetime | Se asigna al crear |

## 3. Cliente

| Atributo | Tipo | Restricciones |
|---|---|---|
| id | bigint | PK, autoincremental |
| nombre | varchar(150) | Obligatorio |
| correo | varchar(254) | Obligatorio, único |
| telefono | varchar(20) | Opcional |
| activo | bool | Por defecto True |
| creado | datetime | Se asigna al crear |

## 4. Producto

| Atributo | Tipo | Restricciones |
|---|---|---|
| id | bigint | PK, autoincremental |
| nombre | varchar(200) | Obligatorio |
| precio | decimal(10,2) | Obligatorio, mínimo 0 |
| stock | int | Por defecto 0, mínimo 0 |
| categoria_id | bigint | FK → Categoria, obligatorio, on_delete=PROTECT (D-01) |
| proveedor_id | bigint | FK → Proveedor, opcional, on_delete=SET_NULL (D-02) |
| activo | bool | Por defecto True |
| creado | datetime | Se asigna al crear |

## 5. Venta

| Atributo | Tipo | Restricciones |
|---|---|---|
| id | bigint | PK, autoincremental |
| cliente_id | bigint | FK → Cliente, obligatorio, on_delete=PROTECT (D-03) |
| fecha | datetime | Se asigna al crear |
| total | (propiedad calculada) | NO es campo de BD (D-04) |

## 6. DetalleVenta

| Atributo | Tipo | Restricciones |
|---|---|---|
| id | bigint | PK, autoincremental |
| venta_id | bigint | FK → Venta, obligatorio |
| producto_id | bigint | FK → Producto, obligatorio, on_delete=PROTECT (D-05) |
| cantidad | int | Obligatorio, entero positivo (>= 1) |
| precio_unitario | decimal(10,2) | Obligatorio, precio al momento de la venta (D-06) |

## 7. Pedido

| Atributo | Tipo | Restricciones |
|---|---|---|
| id | bigint | PK, autoincremental |
| numero_pedido | varchar(20) | Único, formato PED-YYYY-NNNN |
| cliente_id | bigint | FK → Cliente, obligatorio |
| estado | varchar(20) | pendiente, pagado, enviado o cancelado |
| fecha_pedido | datetime | Se asigna al crear |
| fecha_entrega | date | Opcional |
| total_pagado | decimal(10,2) | Opcional |

Nota: Pedido se implementa en la Espiral 5 (W13-W15).

## 8. ConfiguracionERP

| Atributo | Tipo | Restricciones |
|---|---|---|
| id | bigint | PK, siempre pk=1 (singleton, D-07) |
| nombre_empresa | varchar(200) | Obligatorio |
| rfc | varchar(13) | Opcional |
| moneda | varchar(3) | Por defecto MXN |
| iva_porcentaje | decimal(5,2) | Por defecto 16.00 |
| logo | image | Opcional, ruta al archivo |