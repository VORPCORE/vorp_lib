const KEY_DEFS = [
    {
        id: 'toggleMode',
        keys: ['KeyT'],
        label: 'T',
        caption: 'Transform',
        captionRotate: 'Rotate',
    },
    {
        id: 'ground',
        keys: ['AltLeft', 'AltRight'],
        label: 'Alt',
        caption: 'Place on ground',
    },
    {
        id: 'apply',
        keys: ['Enter'],
        label: 'Enter',
        caption: 'Apply',
    },
    {
        id: 'cancel',
        keys: ['Escape', 'Backspace'],
        label: 'Esc',
        caption: 'Cancel',
    },
];

const CAMERA_KEY_DEFS = [
    { id: 'w', label: 'W', caption: 'Zoom in' },
    { id: 's', label: 'S', caption: 'Zoom out' },
    { id: 'a', label: 'A', caption: 'Rotate left' },
    { id: 'd', label: 'D', caption: 'Rotate right' },
    { id: 'q', label: 'Q', caption: 'Raise' },
    { id: 'e', label: 'E', caption: 'Lower' },
    { id: 'f', label: 'F', caption: 'Point at entity' },
];

const LANG_KEYS = {
    toggleMode: 'transform',
    toggleModeRotate: 'rotate',
    ground: 'placeOnGround',
    apply: 'apply',
    cancel: 'cancel',
};

const CAMERA_LANG_KEYS = {
    w: 'zoomIn',
    s: 'zoomOut',
    a: 'rotateLeft',
    d: 'rotateRight',
    q: 'raise',
    e: 'lower',
    f: 'focusEntity',
};

export function createControlsPanel({ onAction }) {
    const panel = document.getElementById('gizmo-controls');
    const group = document.getElementById('gizmo-controls-group');
    const controlsTitle = document.querySelector('.gizmo-controls-title');
    const cameraTitle = document.querySelector('.gizmo-camera-title');
    const keycapByCode = new Map();
    const captionByAction = new Map();
    const cameraCaptionById = new Map();
    let currentMode = 'translate';

    KEY_DEFS.forEach((def) => {
        const row = document.createElement('div');
        row.className = 'gizmo-hint-row';

        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'kbd gizmo-kbd';
        button.dataset.action = def.id;
        button.setAttribute('aria-label', def.caption);
        button.textContent = def.label;

        const caption = document.createElement('span');
        caption.className = 'gizmo-hint-label';
        caption.textContent = def.caption;

        button.addEventListener('pointerdown', () => button.classList.add('is-pressed'));
        button.addEventListener('pointerup', () => button.classList.remove('is-pressed'));
        button.addEventListener('pointerleave', () => button.classList.remove('is-pressed'));
        button.addEventListener('pointercancel', () => button.classList.remove('is-pressed'));
        button.addEventListener('click', () => onAction(def.id));

        row.append(caption, button);
        group.appendChild(row);

        captionByAction.set(def.id, caption);
        def.keys.forEach((code) => keycapByCode.set(code, button));
    });

    function setVisible(visible) {
        panel.classList.toggle('is-hidden', !visible);
    }

    function setMode(mode) {
        currentMode = mode;
        const caption = captionByAction.get('toggleMode');
        const def = KEY_DEFS.find((entry) => entry.id === 'toggleMode');

        if (caption && def) {
            caption.textContent = mode === 'rotate' ? def.captionRotate : def.caption;
        }
    }

    function handleKeyDown(event) {
        const button = keycapByCode.get(event.code);
        if (button) {
            button.classList.add('is-pressed');
        }
    }

    function handleKeyUp(event, options = {}) {
        const def = KEY_DEFS.find((entry) => entry.keys.includes(event.code));
        if (!def) {
            return false;
        }

        keycapByCode.get(event.code)?.classList.remove('is-pressed');

        if (options.triggerAction !== false) {
            onAction(def.id);
        }

        return true;
    }

    const cameraPanel = document.getElementById('gizmo-camera-controls');
    const cameraGroup = document.getElementById('gizmo-camera-group');
    const cameraKeyEls = {};

    CAMERA_KEY_DEFS.forEach((def) => {
        const row = document.createElement('div');
        row.className = 'gizmo-hint-row gizmo-hint-row--camera';

        const keycap = document.createElement('span');
        keycap.className = 'kbd gizmo-kbd gizmo-kbd--cam';
        keycap.dataset.camKey = def.id;
        keycap.setAttribute('aria-hidden', 'true');
        keycap.textContent = def.label;

        const caption = document.createElement('span');
        caption.className = 'gizmo-hint-label';
        caption.textContent = def.caption;

        row.append(keycap, caption);
        cameraGroup?.appendChild(row);
        cameraKeyEls[def.id] = keycap;
        cameraCaptionById.set(def.id, caption);
    });

    function applyLang(lang) {
        if (!lang || typeof lang !== 'object') {
            return;
        }

        if (lang.controlsTitle && controlsTitle) {
            controlsTitle.textContent = lang.controlsTitle;
        }

        if (lang.cameraTitle && cameraTitle) {
            cameraTitle.textContent = lang.cameraTitle;
        }

        KEY_DEFS.forEach((def) => {
            const caption = captionByAction.get(def.id);
            if (!caption) {
                return;
            }

            if (def.id === 'toggleMode') {
                const rotateKey = LANG_KEYS.toggleModeRotate;
                const transformKey = LANG_KEYS.toggleMode;
                if (lang[rotateKey]) {
                    def.captionRotate = lang[rotateKey];
                }
                if (lang[transformKey]) {
                    def.caption = lang[transformKey];
                }
                caption.textContent =
                    currentMode === 'rotate' ? def.captionRotate : def.caption;
                return;
            }

            const langKey = LANG_KEYS[def.id];
            if (langKey && lang[langKey]) {
                def.caption = lang[langKey];
                caption.textContent = def.caption;
            }
        });

        CAMERA_KEY_DEFS.forEach((def) => {
            const caption = cameraCaptionById.get(def.id);
            const langKey = CAMERA_LANG_KEYS[def.id];
            if (caption && langKey && lang[langKey]) {
                def.caption = lang[langKey];
                caption.textContent = def.caption;
            }
        });
    }

    function setCameraVisible(visible) {
        cameraPanel?.classList.toggle('is-hidden', !visible);
    }

    function setCameraKeysPressed(keys) {
        Object.entries(cameraKeyEls).forEach(([key, el]) => {
            if (key === 'f' || !el) {
                return;
            }
            el.classList.toggle('is-pressed', !!keys[key]);
        });
    }

    function setCameraFocusPressed(pressed) {
        cameraKeyEls.f?.classList.toggle('is-pressed', !!pressed);
    }

    return {
        setVisible,
        setMode,
        applyLang,
        setCameraVisible,
        setCameraKeysPressed,
        setCameraFocusPressed,
        handleKeyDown,
        handleKeyUp,
        getActionForCode(code) {
            return KEY_DEFS.find((entry) => entry.keys.includes(code))?.id ?? null;
        },
    };
}
