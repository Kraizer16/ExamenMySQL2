use sakilaCampus;

-- 1. Encuentra el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses.
select a.id_cliente, COUNT(*) as total_alquileres, c.nombre
from alquiler a
join cliente c on a.id_cliente = c.id_cliente
where fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 50 YEAR) 
GROUP by id_cliente 
ORDER by total_alquileres DESC
limit 1;

-- 2. Lista las cinco películas más alquiladas durante el último año.
SELECT p.titulo, COUNT(a.id_alquiler) as total_alquileres
from alquiler a
join inventario i on a.id_inventario = i.id_inventario 
join pelicula p on i.id_pelicula = p.id_pelicula 
where a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 50 YEAR)
GROUP by p.id_pelicula 
ORDER by total_alquileres DESC
limit 5;

-- 3. Obtén el total de ingresos y la cantidad de alquileres realizados por cada categoría de película.
SELECT c.nombre as categoria, COUNT(a.id_alquiler) as total_alquileres, SUM(p.total) as ingresos_totales
from alquiler a
join inventario i on a.id_inventario = i.id_inventario 
join pelicula_categoria pc on i.id_pelicula = pc.id_pelicula 
join categoria c on pc.id_categoria = c.id_categoria
join pago p on a.id_alquiler = p.id_alquiler
GROUP by c.id_categoria;

-- 4. Calcula el número total de clientes que han realizado alquileres por cada idioma disponible en un mes específico.
SELECT i2.nombre as idioma, count(DISTINCT a.id_cliente) as total_clientes
from alquiler a
join inventario i on a.id_inventario = i.id_inventario 
join pelicula p on i.id_pelicula = p.id_pelicula 
join idioma i2 on p.id_idioma = i2.id_idioma 
where MONTH(a.fecha_alquiler) = 3 and YEAR(a.fecha_alquiler) = 2025
GROUP by i2.id_idioma;

-- 5. Encuentra a los clientes que han alquilado todas las películas de una misma categoría.
SELECT a.id_cliente
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
GROUP BY a.id_cliente, pc.id_categoria
HAVING COUNT(DISTINCT i.id_pelicula) = (SELECT COUNT(*) FROM pelicula_categoria WHERE id_categoria = pc.id_categoria);

-- 6.  
SELECT d.ciudad, COUNT(c.id_cliente) AS total_clientes
FROM cliente c
JOIN direccion d ON c.id_direccion = d.id_direccion
WHERE c.activo = 1 AND c.fecha_creacion >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
GROUP BY d.ciudad
ORDER BY total_clientes DESC
LIMIT 3;

-- 7.
SELECT cat.nombre AS categoria, COUNT(a.id_alquiler) AS total_alquileres
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY cat.id_categoria
ORDER BY total_alquileres ASC
LIMIT 5;

-- 8.
SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS promedio_dias
FROM alquiler a
WHERE a.fecha_devolucion IS NOT NULL;

-- 9.
SELECT e.nombre, COUNT(a.id_alquiler) AS total_alquileres
FROM alquiler a
JOIN empleado e ON a.id_empleado = e.id_empleado
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria c ON pc.id_categoria = c.id_categoria
WHERE c.nombre = 'Acción'
GROUP BY e.id_empleado
ORDER BY total_alquileres DESC
LIMIT 5;

-- 10.
SELECT c.id_cliente, c.nombre, COUNT(a.id_alquiler) AS total_alquileres
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
GROUP BY c.id_cliente
ORDER BY total_alquileres DESC;

-- 11.
SELECT l.nombre AS idioma, AVG(p.costo) AS costo_promedio
FROM pelicula p
JOIN idioma l ON p.id_idioma = l.id_idioma
GROUP BY l.id_idioma;

-- 12.
SELECT p.titulo, p.duracion
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
WHERE a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
ORDER BY p.duracion DESC
LIMIT 5;

-- 13.
SELECT c.nombre, COUNT(a.id_alquiler) AS total_alquileres
FROM alquiler a
JOIN cliente c ON a.id_cliente = c.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE cat.nombre = 'Comedia'
GROUP BY c.id_cliente
ORDER BY total_alquileres DESC;

-- 14.
SELECT a.id_cliente, SUM(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS dias_totales
FROM alquiler a
WHERE MONTH(a.fecha_alquiler) = MONTH(NOW()) - 1 AND YEAR(a.fecha_alquiler) = YEAR(NOW())
GROUP BY a.id_cliente;

-- 15.
SELECT i.id_almacen, DATE(a.fecha_alquiler) AS fecha, COUNT(a.id_alquiler) AS total_alquileres
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
GROUP BY i.id_almacen, fecha
ORDER BY fecha ASC;

-- 16. 
SELECT i.id_almacen, SUM(p.total) AS ingresos_totales
FROM pago p
JOIN alquiler a ON p.id_alquiler = a.id_alquiler
JOIN inventario i ON a.id_inventario = i.id_inventario
WHERE p.fecha_pago >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY i.id_almacen;

-- 17.
SELECT c.nombre, p.total
FROM pago p
JOIN alquiler a ON p.id_alquiler = a.id_alquiler
JOIN cliente c ON a.id_cliente = c.id_cliente
WHERE p.fecha_pago >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
ORDER BY p.total DESC
LIMIT 1;

-- 18.
SELECT cat.nombre AS categoria, SUM(p.total) AS ingresos_totales
FROM pago p
JOIN alquiler a ON p.id_alquiler = a.id_alquiler
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE p.fecha_pago >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
GROUP BY cat.id_categoria
ORDER BY ingresos_totales DESC
LIMIT 5;

-- 19.
SELECT l.nombre AS idioma, COUNT(a.id_alquiler) AS total_alquileres
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN idioma l ON p.id_idioma = l.id_idioma
WHERE a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY l.id_idioma;

-- 20.
SELECT c.nombre
FROM cliente c
LEFT JOIN alquiler a ON c.id_cliente = a.id_cliente AND a.fecha_alquiler >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
WHERE a.id_alquiler IS NULL;









































































