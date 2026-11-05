document.addEventListener('DOMContentLoaded', () => {
    let pending = '';

    const clipboardEl = document.getElementById('copy-clipboard');
    const previewEl = document.getElementById('copy-preview');
    const copyBtn = document.getElementById('copy-copyBtn');
    const cancelBtn = document.getElementById('copy-cancelBtn');

    const copyToClipboard = (text) => {
        const el = document.createElement('textarea');
        el.value = text;
        el.setAttribute('readonly', '');
        el.style.position = 'fixed';
        el.style.left = '-9999px';
        document.body.appendChild(el);
        el.focus();
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
    };

    const closeClipboard = (ok) => {
        clipboardEl.classList.add('hidden');
        pending = '';
        fetch(`https://${GetParentResourceName()}/copyResult`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ ok: !!ok }),
        });
    };

    window.addEventListener('message', (event) => {
        const { data } = event.data;
        if (!data || data.type !== 'copy') return;

        pending = String(data.text);
        previewEl.textContent = pending;
        clipboardEl.classList.remove('hidden');
    });

    copyBtn.addEventListener('click', () => {
        if (!pending) return;
        copyToClipboard(pending);
        closeClipboard(true);
    });

    cancelBtn.addEventListener('click', () => closeClipboard(false));

    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && !clipboardEl.classList.contains('hidden')) {
            closeClipboard(false);
        }
    });
});
