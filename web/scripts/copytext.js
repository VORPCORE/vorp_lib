document.addEventListener('DOMContentLoaded', () => {

    const copyToClipboard = async (text) => {
		const el = document.createElement('textarea');
		el.value = text;
		document.body.appendChild(el);
		el.select();
		document.execCommand('copy');
		document.body.removeChild(el);
    };

    window.addEventListener('message', (event) => {
        const { data } = event.data;

        if (!data || data.type !== 'copyText') return;
        if (typeof data.text !== 'string') return;

        copyToClipboard(data.text);
    });

});
