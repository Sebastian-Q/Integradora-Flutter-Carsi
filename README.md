# SIGAUT - Sistema de Gestión de Abarrotes UTEZ

## 📋 Descripción del Proyecto
SIGAUT es un sistema de gestión integral desarrollado para tiendas de abarrotes, diseñado para optimizar el control de inventario, gestión de empleados y procesamiento de ventas. La aplicación móvil ofrece una interfaz intuitiva que permite a los administradores y empleados gestionar eficientemente las operaciones diarias del negocio.

## 🎯 Objetivos
- Desarrollar un sistema de gestión que facilite la administración del inventario
- Permitir el registro y control de productos, empleados y ventas
- Ofrecer acceso rápido y móvil a la información del negocio
- Optimizar el proceso de ventas mediante escaneo de código de barras

## 🏗️ Arquitectura del Sistema

### Arquitectura General
El sistema utiliza una arquitectura **cliente-servidor** que ofrece:
- Flexibilidad y escalabilidad
- Accesibilidad desde diferentes dispositivos móviles
- Diseño modular con roles diferenciados
- Separación entre lógica de negocio e interfaz gráfica

### Frontend - Flutter (Dart)
- **Arquitectura**: MVVM (Model-View-ViewModel)
- **Framework**: Flutter
- **Lenguaje**: Dart
- **Características**:
  - Interfaz reactiva y responsive
  - Separación clara de responsabilidades
  - Fácil mantenimiento y testing
  - Compatibilidad multi-plataforma

### Backend - Spring Boot
- **Framework**: Spring Boot
- **Lenguaje**: Java
- **Características**:
  - API RESTful
  - Gestión de seguridad y autenticación
  - Conexión con base de datos
  - Business logic y validaciones

### Patrón MVVM

Model ↔ ViewModel ↔ View
↓
Backend (Spring Boot)

- **Model**: Representa los datos y la lógica de negocio
- **View**: Interfaz de usuario (Flutter Widgets)
- **ViewModel**: Intermediario que prepara datos para la View

## 👥 Roles de Usuario

### Administrador
- Gestión completa de productos (CRUD)
- Gestión de empleados (CRUD)
- Consulta de ventas realizadas
- Realización de ventas
- Filtrado de ventas por rango de fechas

### Empleado
- Realización de ventas
- Consulta de información personal
- Consulta de lista de productos
- Edición de perfil personal

## 📱 Módulos Principales

### 1. Autenticación
- Inicio de sesión seguro
- Recuperación de contraseña
- Cierre de sesión

### 2. Gestión de Ventas
- Procesamiento de ventas con código de barras
- Múltiples métodos de pago (efectivo/tarjeta)
- Cálculo automático de totales
- Escaneo con cámara del teléfono

### 3. Gestión de Productos
- Registro, consulta, actualización y eliminación
- Control de stock con indicadores visuales
- Validación de códigos de barras únicos
- Alertas de stock mínimo

### 4. Gestión de Empleados
- Registro y administración de usuarios
- Control de permisos y accesos
- Gestión de perfiles de empleados

### 5. Consultas y Reportes
- Visualización de ventas realizadas
- Filtrado por rangos de fecha
- Información detallada de transacciones

## 🛠️ Stack Tecnológico

### Frontend
- **Flutter** - Framework UI
- **Dart** - Lenguaje de programación
- **Provider/Bloc** - Gestión de estado
- **Camera** - Escaneo de código de barras
- **Http** - Consumo de APIs

### Backend
- **Spring Boot** - Framework backend
- **Java** - Lenguaje de programación
- **Spring Security** - Autenticación y autorización
- **JPA/Hibernate** - ORM para base de datos
- **MySQL/PostgreSQL** - Base de datos

### Arquitectura
- **MVVM** - Patrón de diseño frontend
- **REST API** - Comunicación cliente-servidor
- **JWT** - Tokens de autenticación

## 📊 Características Destacadas

- **Sistema de colores para stock**:
  - 🔴 Rojo: Sin stock
  - 🔵 Azul: Stock igual al mínimo
  - 🟢 Verde: Stock mayor al mínimo

- **Escaneo inteligente**: Uso de cámara para lectura de códigos de barras
- **Validaciones en tiempo real** para datos y operaciones
- **Interfaz responsive** para dispositivos móviles
- **Gestión de perfiles** con foto de usuario

## 🗂️ Estructura del proyecto

```
sigaut/
│
├── frontend/ (Flutter - Dart)
│   ├── lib/
│   │   ├── models/ (Modelos de datos)
│   │   ├── views/ (Interfaz de usuario)
│   │   ├── viewmodels/ (Lógica de presentación)
│   │   ├── services/ (Conexión con API)
│   │   └── utils/ (Utilidades)
│   ├── pubspec.yaml
│
├── backend/ (Spring Boot - Java)
│   ├── src/main/java/com/sigaut/
│   │   ├── controller/ (Controladores REST)
│   │   ├── service/ (Lógica de negocio)
│   │   ├── repository/ (Acceso a datos)
│   │   ├── model/ (Entidades)
│   │   └── security/ (Configuración seguridad)
│   ├── pom.xml
│
└── database/
    └── script.sql
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK
- Java JDK 11+
- Spring Boot
- Base de datos MySQL/PostgreSQL

### Ejecución
1. **Backend**:
```bash
cd backend
./mvnw spring-boot:run
```
2. **Frontend**:
 ```  
cd frontend
flutter pub get
flutter run
```

## 📷 Vista previa del modelo ERD

El diagrama entidad-relación se encuentra en `docs/diagrama-erd.png`.

## ✅ Estado del proyecto

Versión actual: 1.0

Estado: En desarrollo

## 👨‍💻 Desarrolladores
Sebastián Quintero Martínez
Israel Flores Reza
Ana Jael Santos Carbajal
Maximiliano Carrera Oropeza
Diego Eduardo Jaimes Flores

Universidad Tecnológica Emiliano Zapata del Estado de Morelos
División Académica de Tecnologías de la Información y Comunicación
Grupo: 10°C

## 📞 Información de Contacto
Profesor: Maximiliano Carsi Castrejón
Materia: Desarrollo Móvil Integral
Contacto: 20223tn016@utez.edu.mx

## 📄 Licencia

Este proyecto se encuentra bajo la licencia **CMMI 3 Nivel 3: Definido**. 

Este proyecto se encuentra bajo la licencia **MOPROSOFT 5 Nivel 5: Optimizado**. 

