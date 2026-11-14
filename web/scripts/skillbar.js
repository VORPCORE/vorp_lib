document.addEventListener("DOMContentLoaded", () => {

    const READY_TIME = 1000;  // time before the needle starts
    const NEXT_TIME = 500;    // pause between two hits
    const RESULT_TIME = 400;  // time the result stays on screen
    const MIN_START = 20;     // zone never starts in the first 20% so the player has time to react
    const END_BUFFER = 4;
    const BAR_START = 7;      // the image is not solid at both ends, in %
    const BAR_END = 92;

    let skill = null;
    let frame = null;
    let timer = null;

    function endSkillbar(result) {
        fetch('https://vorp_lib/endSkillbar', {
            method: 'POST',
            body: JSON.stringify(result),
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }

    function toBar(pos) {
        return BAR_START + pos * (BAR_END - BAR_START) / 100;
    }

    function stopNeedle() {
        if (frame) cancelAnimationFrame(frame);
        if (timer) clearTimeout(timer);
        frame = null;
        timer = null;
    }

    function placeZone() {
        const max = Math.max(MIN_START, 100 - skill.width - END_BUFFER);
        skill.start = MIN_START + Math.random() * (max - MIN_START);
        skill.zone.style.clipPath = `inset(0 ${100 - toBar(skill.start + skill.width)}% 0 ${toBar(skill.start)}%)`;
    }

    function updateText() {
        if (!skill.text) return;
        skill.label.textContent = skill.amount > 1 ? `${skill.text} ${skill.hits}/${skill.amount}` : skill.text;
    }

    function moveNeedle() {
        const progress = Math.min((performance.now() - skill.time) / skill.duration, 1);
        skill.pos = progress * 100;
        skill.needle.style.left = toBar(skill.pos) + '%';

        if (progress < 1) {
            frame = requestAnimationFrame(moveNeedle);
        } else {
            finishSkillbar(false);
        }
    }

    function startNeedle(delay) {
        skill.pos = 0;
        skill.needle.style.left = toBar(0) + '%';
        timer = setTimeout(() => {
            skill.time = performance.now();
            moveNeedle();
        }, delay);
    }

    function finishSkillbar(result) {
        if (!skill) return;
        stopNeedle();

        const container = skill.container;
        skill = null;
        endSkillbar(result);

        container.classList.add(result ? 'bump' : 'miss');
        setTimeout(() => container.remove(), RESULT_TIME);
    }

    // key was pressed, pressing before the needle moves counts as a miss
    function checkSkillbar() {
        if (!skill) return;

        const hit = skill.pos >= skill.start && skill.pos <= skill.start + skill.width;
        if (!hit) return finishSkillbar(false);

        skill.hits++;
        updateText();
        if (skill.hits >= skill.amount) return finishSkillbar(true);

        stopNeedle();
        placeZone();
        startNeedle(NEXT_TIME);
    }

    /**
    * Shows a skill bar, the key has to be pressed while the needle is inside the zone
    * @param {object} data - text, amount, duration, width, colors, position, image
    * @returns {void}
    */
    function showSkillbar(data) {
        stopNeedle();
        document.querySelectorAll('.skillbar-container').forEach(el => el.remove());

        const container = document.createElement('div');
        container.className = 'skillbar-container';
        container.style.top = ((data.position?.top ?? 90) + '%');
        container.style.left = ((data.position?.left ?? 50) + '%');

        const t = document.createElement('div');
        t.className = 'skillbar-text';
        const b = document.createElement('div');
        b.className = 'skillbar-bar';
        const g = document.createElement('div');
        g.className = 'skillbar-grey';
        const w = document.createElement('div');
        w.className = 'skillbar-white';
        const n = document.createElement('div');
        n.className = 'skillbar-needle';

        const imagePath = data.image ? `assets/${data.image}.png` : `assets/score_timer_extralong.png`;
        g.style.backgroundImage = `url(${imagePath})`;
        w.style.backgroundImage = `url(${imagePath})`;

        if (data.colors?.backgroundColor) {
            g.style.filter = `grayscale(100%) brightness(20%) sepia(100%) hue-rotate(${data.colors.backgroundColor}) saturate(2)`;
        }

        if (data.colors?.zoneColor) {
            w.style.filter = `grayscale(100%) brightness(80%) sepia(100%) hue-rotate(${data.colors.zoneColor}) saturate(2)`;
        }

        if (data.colors?.needleColor) {
            n.style.backgroundColor = data.colors.needleColor;
        }

        t.style.color = data.colors?.textColor ?? 'white';

        b.append(g, w, n);
        container.append(t, b);
        document.body.appendChild(container);

        skill = {
            container: container,
            label: t,
            zone: w,
            needle: n,
            text: data.text,
            amount: Math.max(1, Number(data.amount) || 1),
            duration: Math.max(250, Number(data.duration) || 2300),
            width: Math.min(40, Math.max(2, Number(data.width) || 6)),
            hits: 0,
            start: 0,
            pos: 0,
            time: 0,
        };

        updateText();
        placeZone();
        startNeedle(READY_TIME);
    }


    window.addEventListener('message', function (event) {
        const { data } = event.data;
        if (!data || !data.type) return;

        if (data.type === 'skillbar') {
            showSkillbar(data);
        }

        if (data.type === 'skillbar_check') {
            checkSkillbar();
        }

        if (data.type === 'cancel_skillbar') {
            finishSkillbar(false);
        }
    });

});
