document.addEventListener('DOMContentLoaded', () => {

    const c opyToClipboard = (text) => {
        const el = document.createElement('textarea');
        el.value = text;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
    };

        window.addEventListener('message', (event) => {
        const { data } = event.data;
        if (!data || !data.type) return;

        if (data.type === 'copy')
            copyToClipboard(data.text);
    });
});
