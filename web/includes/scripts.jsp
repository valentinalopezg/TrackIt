<%-- 
    Document   : scripts
    Created on : 20/11/2025, 7:18:54 a. m.
    Author     : Valentina
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Bootstrap JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Toggle sidebar
document.getElementById('sidebarToggle')?.addEventListener('click', function() {
    document.getElementById('sidebar').classList.toggle('active');
});

// Función para mostrar alertas dinámicas
function showAlert(message, type = 'info', duration = 4000) {
    let alertContainer = document.getElementById('alertContainer');
    
    // Si no existe el contenedor, crearlo
    if (!alertContainer) {
        alertContainer = document.createElement('div');
        alertContainer.id = 'alertContainer';
        alertContainer.className = 'alert-container';
        alertContainer.style.cssText = 'position: fixed; top: 80px; right: 20px; z-index: 9999; max-width: 400px;';
        document.body.appendChild(alertContainer);
    }
    
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
    alertDiv.setAttribute('role', 'alert');
    
    // Iconos según el tipo
    const icons = {
        'success': 'fa-check-circle',
        'danger': 'fa-exclamation-circle',
        'warning': 'fa-exclamation-triangle',
        'info': 'fa-info-circle'
    };
    
    alertDiv.innerHTML = '<i class="fas ' + (icons[type] || icons['info']) + '"></i> ' + message + 
        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
    
    alertContainer.appendChild(alertDiv);
    
    // Auto-cerrar después del tiempo especificado
    setTimeout(function() {
        if (alertDiv.parentElement) {
            const bsAlert = bootstrap.Alert.getInstance(alertDiv);
            if (bsAlert) bsAlert.close();
        }
    }, duration);
}

// Auto-cerrar alertas después de 5 segundos
setTimeout(function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        const bsAlert = bootstrap.Alert.getInstance(alert);
        if (bsAlert) bsAlert.close();
    });
}, 5000);

console.log('Track!t Sistema - Scripts cargados correctamente');
</script>
