// Simple JS helper for events pages
document.addEventListener('DOMContentLoaded', function(){
    // confirm before destructive actions (future use)
    document.querySelectorAll('.btn-delete').forEach(function(b){
        b.addEventListener('click', function(e){
            if(!confirm('Voulez-vous vraiment supprimer cet événement ?')) e.preventDefault();
        });
    });

    // enhance forms: trim whitespace on submit
    document.querySelectorAll('form').forEach(function(form){
        form.addEventListener('submit', function(){
            form.querySelectorAll('input[type=text], textarea').forEach(function(i){ i.value = i.value.trim(); });
        });
    });
    // fade out messages
    var msg = document.querySelector('.message');
    if(msg){ setTimeout(function(){ msg.style.transition = 'opacity 0.8s'; msg.style.opacity = '0'; setTimeout(function(){ msg.style.display='none'; },900); }, 3500); }

    // client-side validation for create form
    var createForm = document.querySelector('form[action$="/events"]');
    if(createForm){
        createForm.addEventListener('submit', function(e){
            var titre = createForm.querySelector('input[name="titre"]');
            if(!titre || !titre.value.trim()){
                e.preventDefault();
                alert('Le titre est requis.');
                titre && titre.focus();
                return false;
            }
        });
    }
});
