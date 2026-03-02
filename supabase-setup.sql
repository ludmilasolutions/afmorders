-- Tablas y datos para migrar de Firebase a Supabase
-- Ejecutar este SQL en el panel de Supabase > SQL Editor

-- ============================================
-- CREAR TABLAS
-- ============================================

-- Tabla de configuración (settings)
CREATE TABLE IF NOT EXISTS settings (
    id TEXT PRIMARY KEY DEFAULT 'config',
    nombre_local TEXT DEFAULT 'EL TACHI Rotisería',
    horarios_por_dia JSONB DEFAULT '{"lunes": "11:00 - 23:00", "martes": "11:00 - 23:00", "miercoles": "11:00 - 23:00", "jueves": "11:00 - 23:00", "viernes": "11:00 - 00:00", "sábado": "11:00 - 00:00", "domingo": "11:00 - 23:00"}',
    abierto BOOLEAN DEFAULT true,
    mensaje_cerrado TEXT DEFAULT 'Lo sentimos, estamos cerrados en este momento.',
    precio_envio INTEGER DEFAULT 300,
    tiempo_base_estimado INTEGER DEFAULT 30,
    retiro_habilitado BOOLEAN DEFAULT true,
    colores_marca JSONB DEFAULT '{"azul": "#1e40af", "amarillo": "#f59e0b"}',
    telefono_whatsapp TEXT DEFAULT '5491122334455',
    api_key_gemini TEXT DEFAULT '',
    mantener_historial_dias INTEGER DEFAULT 30,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de categorías
CREATE TABLE IF NOT EXISTS categories (
    id TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    orden INTEGER DEFAULT 0,
    icono TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de productos
CREATE TABLE IF NOT EXISTS products (
    id TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    categoria TEXT,
    disponible BOOLEAN DEFAULT true,
    aderezos_disponibles TEXT[],
    imagen_url TEXT,
    orden INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de pedidos
CREATE TABLE IF NOT EXISTS orders (
    id TEXT PRIMARY KEY,
    id_pedido TEXT,
    fecha TIMESTAMPTZ DEFAULT NOW(),
    nombre_cliente TEXT,
    telefono TEXT,
    tipo_pedido TEXT DEFAULT 'retiro',
    direccion TEXT,
    pedido_detallado TEXT,
    items JSONB,
    comentarios TEXT,
    subtotal DECIMAL(10,2) DEFAULT 0,
    precio_envio INTEGER DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    estado TEXT DEFAULT 'Recibido',
    tiempo_estimado_actual INTEGER DEFAULT 30,
    user_id TEXT,
    user_email TEXT,
    user_name TEXT,
    user_photo_url TEXT,
    is_registered_user BOOLEAN DEFAULT false,
    fecha_actualizacion TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de administradores
CREATE TABLE IF NOT EXISTS admins (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    nombre TEXT,
    is_admin BOOLEAN DEFAULT true,
    activo BOOLEAN DEFAULT true,
    rol TEXT DEFAULT 'admin',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    created_by TEXT
);

-- Tabla de contadores
CREATE TABLE IF NOT EXISTS counters (
    id TEXT PRIMARY KEY DEFAULT 'orders',
    last_number INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de notificaciones
CREATE TABLE IF NOT EXISTS notifications (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    tipo TEXT,
    mensaje TEXT,
    pedido_id TEXT,
    leido BOOLEAN DEFAULT false,
    fecha TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de prueba
CREATE TABLE IF NOT EXISTS test (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    message TEXT,
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INSERTAR DATOS
-- ============================================

-- Insertar configuración por defecto
INSERT INTO settings (id, nombre_local) VALUES ('config', 'EL TACHI Rotisería')
ON CONFLICT (id) DO NOTHING;

-- Insertar contador inicial
INSERT INTO counters (id, last_number) VALUES ('orders', 0)
ON CONFLICT (id) DO NOTHING;

-- Insertar usuario admin
INSERT INTO admins (id, email, nombre, is_admin, activo, rol) 
VALUES ('bae2d67c-0fec-43ec-8b04-361404e0b945', 'admin@gmail.com', 'Admin', true, true, 'admin')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- INSERTAR CATEGORÍAS
-- ============================================
INSERT INTO categories (id, nombre, orden, icono) VALUES
('g1KKmGEWPN08eMTXlotG', 'Hamburguesas', 1, '🍔'),
('3rzzXodjmigAAbm9JZUK', 'Pizzas', 2, '🍕'),
('5SR7cNdUyornmukKiDxp', 'Empanadas', 3, '🥟'),
('8RbEvu6qdzVnSlULlwye', 'Gaseosas - Descartables', 4, '🥤'),
('CTzHNy5fuEli27jVDqd3', 'Familiares (con papas)', 5, '🍔'),
('I1IyfzVrJJmjpdDa9IXC', 'Cervezas - Latas', 6, '🍺'),
('JP2aTFxROM2tAeYOTXOj', 'Vinos caja', 7, '🍷'),
('vs09QccM6ccgwLAx1luN', 'Gaseosas - Retornables', 8, '🥤'),
('KwjA1eXl5cTg8rkp77Fo', 'Cervezas - Botellas', 9, '🍺'),
('TVVOqLfmBq4EtrGjohMe', 'Al Plato', 10, '🍽️'),
('XjTxoQvz2Q9PmImUNxuh', 'Energizantes y otros', 11, '⚡'),
('ZtHiKfv1UaF8fdvC4uLu', 'Pizzanesa para 3 Personas', 12, '🍕'),
('2D2TSadkH1qRJGKhDsce', 'Acompañamientos', 13, '🍟'),
('kGcU2bEJhBxDxpbwSu5o', 'Torpedos (con papas)', 14, '🥪'),
('piAWHHJ7sgylmhmm43TQ', 'Carlitos', 15, '🥪'),
('uwjq5PHomO97rx2hQYq6', 'Pizzanesa para 2 Personas', 16, '🍕'),
('hI30xuxgVydPG6Gn1YSh', 'Otras gaseosas', 17, '🥤'),
('J2QdDONrik4vOuLHAm7o', 'Jugos', 18, '🧃')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- INSERTAR PRODUCTOS
-- ============================================
INSERT INTO products (id, nombre, descripcion, precio, categoria, disponible) VALUES
('prod_001', 'Pizza 1/2 Salame', 'Muzzarella y salame', 4500, '3rzzXodjmigAAbm9JZUK', true),
('prod_002', 'Torpedo Especial Hamburguesa (2)', '', 10900, 'kGcU2bEJhBxDxpbwSu5o', true),
('prod_003', 'Carlito Especial', 'Jamón, queso, ketchup, huevo rallado, morrón', 7500, 'piAWHHJ7sgylmhmm43TQ', true),
('prod_004', 'Sprite x 1,5L', '', 3500, '8RbEvu6qdzVnSlULlwye', true),
('prod_005', 'Baggio Fresh', '', 1300, 'vs09QccM6ccgwLAx1luN', true),
('prod_006', 'Fanta x 2L', '', 3000, 'hI30xuxgVydPG6Gn1YSh', true),
('prod_007', 'Empanada de Pollo', '', 1100, '5SR7cNdUyornmukKiDxp', true),
('prod_008', 'Torpedo Especial Milanesa', '', 12500, 'kGcU2bEJhBxDxpbwSu5o', true),
('prod_009', 'Agua x 1,5L', '', 1000, 'vs09QccM6ccgwLAx1luN', true),
('prod_010', 'Familiar Común Suprema', '', 6000, 'CTzHNy5fuEli27jVDqd3', true),
('prod_011', 'Saborizada 500cc', '', 650, 'vs09QccM6ccgwLAx1luN', true),
('prod_012', 'Pizzanesa Carne Roquefort (3)', '', 25000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_013', 'Termidor Blanco', '', 1600, 'J2QdDONrik4vOuLHAm7o', true),
('prod_014', 'Pizzanesa Carne Especial (2 Personas)', '', 16500, 'uwjq5PHomO97rx2hQYq6', true),
('prod_015', 'Pizza Dante', 'Salsa de tomate, queso muzzarella y toppings especiales', 9000, '3rzzXodjmigAAbm9JZUK', true),
('prod_016', 'Bandeja Mediana', '', 4000, '2D2TSadkH1qRJGKhDsce', true),
('prod_017', 'Torpedo Especial Hamburguesa (3)', '', 12000, 'kGcU2bEJhBxDxpbwSu5o', true),
('prod_018', 'Sprite lata', '', 1400, '8RbEvu6qdzVnSlULlwye', true),
('prod_019', 'Familiar Común Milanesa', '', 6500, 'CTzHNy5fuEli27jVDqd3', true),
('prod_020', 'Lata Brahma', '', 1600, 'I1IyfzVrJJmjpdDa9IXC', true),
('prod_021', 'Pizzanesa Pollo Napolitana (3)', '', 23000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_022', 'Pizza Salame', 'Muzzarella y salame', 8500, '3rzzXodjmigAAbm9JZUK', true),
('prod_023', 'Pizzanesa Carne Salame (2 Personas)', '', 16500, 'uwjq5PHomO97rx2hQYq6', true),
('prod_024', 'Doble Cola x 3L', '', 2100, 'JP2aTFxROM2tAeYOTXOj', true),
('prod_025', 'Pizzanesa Carne Bomba (3)', '', 25000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_026', 'Pizzanesa Pollo Especial (2 Personas)', '', 15500, 'uwjq5PHomO97rx2hQYq6', true),
('prod_027', 'Casoni', '', 1100, 'J2QdDONrik4vOuLHAm7o', true),
('prod_028', 'Gatorade x 500cc', '', 1400, 'vs09QccM6ccgwLAx1luN', true),
('prod_029', 'Fanta lata', '', 1400, '8RbEvu6qdzVnSlULlwye', true),
('prod_030', 'Pizzanesa Pollo Bomba (2 Personas)', '', 16500, 'uwjq5PHomO97rx2hQYq6', true),
('prod_031', 'Pizzanesa Pollo Salame (2 Personas)', '', 15500, 'uwjq5PHomO97rx2hQYq6', true),
('prod_032', 'Lata 1890', '', 1500, 'I1IyfzVrJJmjpdDa9IXC', true),
('prod_033', 'Sprite x 2L', '', 3000, 'hI30xuxgVydPG6Gn1YSh', true),
('prod_034', 'Pizzanesa Pollo Bomba (3)', '', 24000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_035', 'Milanesa con Papas', '', 5000, 'TVVOqLfmBq4EtrGjohMe', true),
('prod_036', 'Termidor Tinto', '', 1900, 'J2QdDONrik4vOuLHAm7o', true),
('prod_037', 'Pizzanesa Carne Muzzarella (3)', '', 22000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_038', 'Empanada de Carne', '', 1100, '5SR7cNdUyornmukKiDxp', true),
('prod_039', 'Pizza Muzza con Jamón', 'Salsa de tomate, queso muzzarella y jamón', 7500, '3rzzXodjmigAAbm9JZUK', true),
('prod_040', 'Pizzanesa Carne Roquefort (2 Personas)', '', 17000, 'uwjq5PHomO97rx2hQYq6', true),
('prod_041', 'Quilmes 1L', '', 2900, 'KwjA1eXl5cTg8rkp77Fo', true),
('prod_042', '361 descartable', '', 2000, 'KwjA1eXl5cTg8rkp77Fo', true),
('prod_043', 'Pizzanesa Pollo Napolitana (2 Personas)', '', 15500, 'uwjq5PHomO97rx2hQYq6', true),
('prod_044', 'Pizzanesa Pollo Roquefort (2 Personas)', '', 16500, 'uwjq5PHomO97rx2hQYq6', true),
('prod_045', 'Baggio x 1L', '', 1700, 'vs09QccM6ccgwLAx1luN', true),
('prod_046', 'Pizzanesa Carne Especial (3)', '', 24000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_047', 'Coca x 2,5L', '', 4500, '8RbEvu6qdzVnSlULlwye', true),
('prod_048', 'Fanta x 1,5L', '', 3500, '8RbEvu6qdzVnSlULlwye', true),
('prod_049', 'Pizzanesa Carne Muzzarella (2 Personas)', '', 15000, 'uwjq5PHomO97rx2hQYq6', true),
('prod_050', 'Coca lata', '', 1400, '8RbEvu6qdzVnSlULlwye', true),
('prod_051', 'Pizzanesa Carne Napolitana (2 Personas)', '', 16500, 'uwjq5PHomO97rx2hQYq6', true),
('prod_052', 'Brahma 1L', '', 2900, 'KwjA1eXl5cTg8rkp77Fo', true),
('prod_053', 'Speed grande', '', 2500, 'XjTxoQvz2Q9PmImUNxuh', true),
('prod_054', 'Lata Isenbeck', '', 1400, 'I1IyfzVrJJmjpdDa9IXC', true),
('prod_055', 'Familiar Especial Suprema', '', 6500, 'CTzHNy5fuEli27jVDqd3', true),
('prod_056', 'Coca vidrio chica', '', 1000, '8RbEvu6qdzVnSlULlwye', true),
('prod_057', 'Pizza Viena', 'Muzzarella, salchicha y huevo revuelto', 8500, '3rzzXodjmigAAbm9JZUK', true),
('prod_058', 'Pizza 1/2 Va como Piña', 'Muzzarella, huevo frito y papas fritas', 5000, '3rzzXodjmigAAbm9JZUK', true),
('prod_059', 'Docena de Empanadas', '', 13000, '5SR7cNdUyornmukKiDxp', true),
('prod_060', 'Pizza Napolitana', 'Muzzarella, tomate, ajo', 8000, '3rzzXodjmigAAbm9JZUK', true),
('prod_061', 'Cunnington', '', 1500, 'JP2aTFxROM2tAeYOTXOj', true),
('prod_062', 'Pizzanesa Pollo Salame (3)', '', 23000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_063', 'Pizzanesa Carne Bomba (2 Personas)', '', 17000, 'uwjq5PHomO97rx2hQYq6', true),
('prod_064', 'Torpedo Vegetariano', '', 7500, 'kGcU2bEJhBxDxpbwSu5o', true),
('prod_065', 'Pizzanesa Pollo Roquefort (3)', '', 24000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_066', 'Carlito Común', 'Jamón, queso y ketchup', 6500, 'piAWHHJ7sgylmhmm43TQ', true),
('prod_067', 'Adicional Papas Fritas', '', 1500, 'piAWHHJ7sgylmhmm43TQ', true),
('prod_068', 'Lata 361', '', 1300, 'I1IyfzVrJJmjpdDa9IXC', true),
('prod_069', 'Pizza Especial', 'Jamón, muzzarella, huevo, morrón', 8000, '3rzzXodjmigAAbm9JZUK', true),
('prod_070', 'Pizza 1/2 Dante', 'Salsa de tomate, queso muzzarella y toppings especiales', 5000, '3rzzXodjmigAAbm9JZUK', true),
('prod_071', '1/2 Docena de Empanadas', '', 6500, '5SR7cNdUyornmukKiDxp', true),
('prod_072', 'Pizza Doble Muzza', 'Salsa de tomate, doble muzzarella y aceitunas', 7500, '3rzzXodjmigAAbm9JZUK', true),
('prod_073', 'Pizzanesa Pollo Especial (3)', '', 23000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_074', 'Agua x 2L', '', 1100, 'vs09QccM6ccgwLAx1luN', true),
('prod_075', 'Lata Schneider 710cc', '', 3000, 'I1IyfzVrJJmjpdDa9IXC', true),
('prod_076', 'Bandeja Grande', '', 5500, '2D2TSadkH1qRJGKhDsce', true),
('prod_077', 'Empanada de J y Q', '', 1100, '5SR7cNdUyornmukKiDxp', true),
('prod_078', 'Pizza Muzzarella', 'Salsa de tomate, queso muzzarella y aceitunas', 7000, '3rzzXodjmigAAbm9JZUK', true),
('prod_079', 'Soda', '', 1300, 'JP2aTFxROM2tAeYOTXOj', true),
('prod_080', 'Toro Tinto', '', 2300, 'J2QdDONrik4vOuLHAm7o', true),
('prod_081', 'Sprite x 500cc', '', 1500, '8RbEvu6qdzVnSlULlwye', true),
('prod_082', 'Coca x 500cc', '', 1500, '8RbEvu6qdzVnSlULlwye', true),
('prod_083', 'Agua 500cc', '', 650, 'vs09QccM6ccgwLAx1luN', true),
('prod_084', 'Lata Santa Fe', '', 1700, 'I1IyfzVrJJmjpdDa9IXC', true),
('prod_085', 'Pizza 1/2 Napolitana', 'Muzzarella, tomate, ajo', 4500, '3rzzXodjmigAAbm9JZUK', true),
('prod_086', 'Pizza 1/2 Viena', 'Muzzarella, salchicha y huevo revuelto', 4500, '3rzzXodjmigAAbm9JZUK', true),
('prod_087', 'Familiar Especial Milanesa', '', 7500, 'CTzHNy5fuEli27jVDqd3', true),
('prod_088', 'Suprema con Papas', '', 5000, 'TVVOqLfmBq4EtrGjohMe', true),
('prod_089', 'Coca x 1,5L', '', 3500, '8RbEvu6qdzVnSlULlwye', true),
('prod_090', 'Pizzanesa Pollo Muzzarella (2 Personas)', '', 14000, 'uwjq5PHomO97rx2hQYq6', true),
('prod_091', 'Speed chico', '', 1800, 'XjTxoQvz2Q9PmImUNxuh', true),
('prod_092', 'Pizza Va como Piña', 'Muzzarella, huevo frito y papas fritas', 9000, '3rzzXodjmigAAbm9JZUK', true),
('prod_093', 'Pizza Roquefort', 'Muzzarella y queso roquefort', 9000, '3rzzXodjmigAAbm9JZUK', true),
('prod_094', 'Secco x 3L', '', 1700, 'JP2aTFxROM2tAeYOTXOj', true),
('prod_095', 'Hamburguesa Especial', 'Pan, carne, jamón, queso, huevo, lechuga, tomate y aderezo', 7500, 'g1KKmGEWPN08eMTXlotG', true),
('prod_096', 'Iguana 1L', '', 2400, 'KwjA1eXl5cTg8rkp77Fo', true),
('prod_097', 'Baggio chico', '', 500, 'vs09QccM6ccgwLAx1luN', true),
('prod_098', 'Empanada de Verdura', '', 1100, '5SR7cNdUyornmukKiDxp', true),
('prod_099', 'Pizza 1/2 Muzzarella', 'Salsa de tomate, queso muzzarella y aceitunas', 3500, '3rzzXodjmigAAbm9JZUK', true),
('prod_100', 'Pizza 1/2 Doble Muzza', 'Salsa de tomate, doble muzzarella y aceitunas', 4000, '3rzzXodjmigAAbm9JZUK', true),
('prod_101', 'Pizza 1/2 Muzza con Jamón', 'Salsa de tomate, queso muzzarella y jamón', 4000, '3rzzXodjmigAAbm9JZUK', true),
('prod_102', 'Papas Fritas', 'Porción grande con sal y perejil', 800, '2D2TSadkH1qRJGKhDsce', true),
('prod_103', 'Pizzanesa Carne Napolitana (3)', '', 24000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_104', 'Pizza 1/2 Roquefort', 'Muzzarella y queso roquefort', 5000, '3rzzXodjmigAAbm9JZUK', true),
('prod_105', 'Hamburguesa Común', 'Pan, carne, lechuga, tomate y aderezo', 6500, 'g1KKmGEWPN08eMTXlotG', true),
('prod_106', 'Lata Quilmes', '', 1600, 'I1IyfzVrJJmjpdDa9IXC', true),
('prod_107', 'Pizzanesa Pollo Muzzarella (3)', '', 21000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_108', 'Torpedo Primavera', '', 7500, 'kGcU2bEJhBxDxpbwSu5o', true),
('prod_109', 'Aderezo adicional', '', 1000, '2D2TSadkH1qRJGKhDsce', true),
('prod_110', 'Cepita', '', 3200, 'vs09QccM6ccgwLAx1luN', true),
('prod_111', 'Torpedo Especial Suprema', '', 11000, 'kGcU2bEJhBxDxpbwSu5o', true),
('prod_112', 'Tortilla de Papas', '', 7000, 'TVVOqLfmBq4EtrGjohMe', true),
('prod_113', 'Fanta x 500cc', '', 1500, '8RbEvu6qdzVnSlULlwye', true),
('prod_114', 'Pritty x 3L', '', 2800, 'JP2aTFxROM2tAeYOTXOj', true),
('prod_115', 'Lata Schneider', '', 1700, 'I1IyfzVrJJmjpdDa9IXC', true),
('prod_116', 'Coca x 2L', '', 3000, 'hI30xuxgVydPG6Gn1YSh', true),
('prod_117', 'Pizzanesa Carne Salame (3)', '', 24000, 'ZtHiKfv1UaF8fdvC4uLu', true),
('prod_118', 'Pizza 1/2 Especial', 'Jamón, muzzarella, huevo, morrón', 4500, '3rzzXodjmigAAbm9JZUK', true)
ON CONFLICT (id) DO NOTHING;

SELECT '✅ Base de datos configurada correctamente' as resultado;
