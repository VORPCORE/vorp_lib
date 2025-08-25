document.addEventListener("DOMContentLoaded", () => {
    let isCanceled = false;
    /**
    * Shows a horizontal progress bar with text overlay and waits for completion
    * @param {string} text - Text to display on the progress bar
    * @param {object} colors - Colors to use for the progress bar (optional)
    * @param {number} duration - Duration in milliseconds
    * @returns {Promise} Resolves when progress bar completes
    */
    function showProgressBars(data, duration) {
        return new Promise(resolve => {
            isCanceled = false

            document.querySelectorAll('.horizontal-progress-container').forEach(el => el.remove());

            const container = document.createElement('div');
            container.className = 'horizontal-progress-container';
            container.style.top = ((data.position?.top ?? 90) + '%');
            container.style.left = ((data.position?.left ?? 50) + '%');

            const g = document.createElement('div');
            g.className = 'progress-grey';
            const w = document.createElement('div');
            w.className = 'progress-white';
            const t = document.createElement('div');
            t.className = 'progress-text';

            t.textContent = data.text;

            const imagePath = data.image ? `assets/${data.image}.png` : `assets/score_timer_extralong.png`;
            g.style.backgroundImage = `url(${imagePath})`;
            w.style.backgroundImage = `url(${imagePath})`;

            if (data.colors?.backgroundColor) {
                g.style.filter = `grayscale(100%) brightness(20%) sepia(100%) hue-rotate(${data.colors.backgroundColor}) saturate(2)`;
            }

            if (data.colors?.fillColor) {
                w.style.filter = `grayscale(100%) brightness(80%) sepia(100%) hue-rotate(${data.colors.fillColor}) saturate(2)`;
            }

            t.style.color = data.colors?.startColor ?? 'white';

            container.append(g, w, t);
            document.body.appendChild(container);

            g.getBoundingClientRect(); w.getBoundingClientRect(); t.getBoundingClientRect();

            g.style.transition = `clip-path ${duration}ms linear`;
            w.style.transition = `clip-path ${duration}ms linear`;
            t.style.transition = `color ${duration}ms linear`;

            requestAnimationFrame(() => {
                g.style.clipPath = 'inset(0 0 0 100%)';
                w.style.clipPath = 'inset(0 0 0 0)';
                t.style.color = data.colors?.endColor ?? 'black';
            });

            function endProgress(result) {
                fetch('https://vorp_lib/endProgressBar', {
                    method: 'POST',
                    body: JSON.stringify(result),
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            }

            const timeout = setTimeout(() => {
                container.classList.add('bump');
                endProgress(true);
                setTimeout(() => {
                    container.remove();
                    resolve(true);
                }, 200);
            }, duration);

            const interval = setInterval(() => {

                if (isCanceled) {
                    endProgress(false);
                    clearInterval(interval);
                    clearTimeout(timeout);
                    container.remove();
                    resolve(false);
                    isCanceled = false;
                }
            }, 100);
        });
    }


    window.addEventListener('message', function (event) {
        const { data, duration } = event.data;

        if (data.type === 'linear') {
            showProgressBars(data, duration);
        }

        //todo: add progress circular
        if (data.type === 'circular') {
            // showProgressCircular(data);
        }

        if (data.type === 'cancel_progress') {
            isCanceled = true;
        }
    });

});


