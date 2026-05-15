// credits to object_gizmo that was made in react https://github.com/DemiAutomatic/object_gizmo, this is a raw java script refactor made by outsider.
import * as THREE from './vendor/three.module.js';
import { TransformControls } from './vendor/TransformControls.js';
import { onNuiEvent, fetchNui } from './nui-events.js';
import { createControlsPanel } from './controls.js';

function mountGizmoUi() {
    if (document.getElementById('root')) {
        return;
    }

    const root = document.createElement('div');
    root.id = 'root';

    const controls = document.createElement('aside');
    controls.id = 'gizmo-controls';
    controls.className = 'is-hidden';
    controls.setAttribute('aria-label', 'Gizmo controls');
    controls.innerHTML = `
      <span class="gizmo-hint-label gizmo-controls-title">Controls</span>
      <div id="gizmo-controls-group" class="gizmo-hint-group"></div>
    `;

    const cameraControls = document.createElement('aside');
    cameraControls.id = 'gizmo-camera-controls';
    cameraControls.className = 'is-hidden';
    cameraControls.setAttribute('aria-label', 'Camera controls');
    cameraControls.innerHTML = `
      <span class="gizmo-hint-label gizmo-camera-title">Camera</span>
      <div id="gizmo-camera-group" class="gizmo-hint-group"></div>
    `;

    document.body.append(root, controls, cameraControls);
}

mountGizmoUi();

const root = document.getElementById('root');
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(50, window.innerWidth / window.innerHeight, 0.1, 10000);
camera.position.set(0, 0, 10);
camera.updateProjectionMatrix();

const renderer = new THREE.WebGLRenderer({
    alpha: true,
    antialias: true,
});

renderer.setPixelRatio(window.devicePixelRatio || 1);
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.domElement.style.zIndex = '1';
renderer.domElement.style.display = 'none';
root.style.display = 'none';
root.appendChild(renderer.domElement);

const gizmoObject = new THREE.Mesh();
gizmoObject.rotation.order = 'YZX';
gizmoObject.visible = false;
scene.add(gizmoObject);

const transformControls = new TransformControls(camera, renderer.domElement);
transformControls.size = 0.5;
transformControls.setMode('translate');
transformControls.visible = false;
transformControls.enabled = false;
scene.add(transformControls);

let camMinRadius = 2;
let camMaxRadius = 10;
const CAM_ZOOM_SPEED = 0.12;
const CAM_ROTATE_SPEED = 0.02;
const CAM_LIFT_SPEED = 0.08;

let currentEntity = null;
let editorMode = 'translate';
let gizmoEnabled = false;
let inputReadyAt = 0;
let cameraMode = false;
let cameraOrbit = { dist: 5, yaw: 0, pitch: -0.25 };
const cameraOrbitAnchor = new THREE.Vector3();
let cameraHeight = 0;
const keysHeld = new Set();
const CAMERA_HOLD_KEY_CODES = new Set(['KeyW', 'KeyA', 'KeyS', 'KeyD', 'KeyQ', 'KeyE']);
const CAMERA_FOCUS_KEY = 'KeyF';

const controls = createControlsPanel({
    onAction: handleControlAction,
});

function canAcceptControlInput() {
    return gizmoEnabled && performance.now() >= inputReadyAt;
}

function showGizmo() {
    gizmoEnabled = true;
    keysHeld.clear();
    inputReadyAt = performance.now() + 400;
    root.style.display = 'block';
    renderer.domElement.style.display = 'block';
    gizmoObject.visible = true;
    transformControls.visible = true;
    transformControls.enabled = true;
    controls.setVisible(true);
    controls.setMode(editorMode);
}

function hideGizmo() {
    gizmoEnabled = false;
    keysHeld.clear();
    inputReadyAt = 0;
    currentEntity = null;
    cameraMode = false;
    cameraHeight = 0;
    transformControls.detach();
    transformControls.visible = false;
    transformControls.enabled = false;
    gizmoObject.visible = false;
    renderer.domElement.style.display = 'none';
    root.style.display = 'none';
    controls.setVisible(false);
    controls.setCameraVisible(false);
}

hideGizmo();

function zRotationHandler(t, e) {
    return t > 0 && t < 90 ? e : (t > -180 && t < -90) || t > 0 ? -e : e;
}

function gameToThreePosition(position) {
    return new THREE.Vector3(position.x, position.z, -position.y);
}

function threeToGamePosition(vector) {
    return {
        x: vector.x,
        y: -vector.z,
        z: vector.y,
    };
}

function lockCameraOrbitAnchor() {
    cameraOrbitAnchor.copy(gizmoObject.position);
}

function focusCameraOnEntity() {
    if (!cameraMode) {
        return;
    }

    lockCameraOrbitAnchor();

    const rel = new THREE.Vector3(
        camera.position.x - cameraOrbitAnchor.x,
        camera.position.y - cameraOrbitAnchor.y - cameraHeight,
        camera.position.z - cameraOrbitAnchor.z
    );
    const dist = rel.length();

    if (dist > 0.001) {
        cameraOrbit.dist = THREE.MathUtils.clamp(dist, camMinRadius, camMaxRadius);
        cameraOrbit.yaw = Math.atan2(rel.x, rel.z);
        cameraOrbit.pitch = Math.asin(THREE.MathUtils.clamp(rel.y / dist, -1, 1));
    }

    const lookTarget = cameraOrbitAnchor.clone();
    lookTarget.y += cameraHeight;
    camera.lookAt(lookTarget);
    camera.updateProjectionMatrix();
}

function initCameraOrbitFromGame(position, rotation) {
    camera.position.copy(gameToThreePosition(position));
    camera.rotation.order = 'YZX';

    if (rotation) {
        camera.rotation.set(
            THREE.MathUtils.degToRad(rotation.x),
            THREE.MathUtils.degToRad(zRotationHandler(rotation.x, rotation.z)),
            THREE.MathUtils.degToRad(rotation.y)
        );
    }

    lockCameraOrbitAnchor();

    const offset = camera.position.clone().sub(cameraOrbitAnchor);
    const dist = offset.length();

    cameraOrbit.dist = THREE.MathUtils.clamp(
        dist > 0.001 ? dist : camMaxRadius,
        camMinRadius,
        camMaxRadius
    );

    if (dist > 0.001) {
        cameraOrbit.yaw = Math.atan2(offset.x, offset.z);
        cameraOrbit.pitch = Math.asin(THREE.MathUtils.clamp(offset.y / dist, -1, 1));
    }
}

function applyCameraOrbit() {
    const { dist, yaw, pitch } = cameraOrbit;
    const cosPitch = Math.cos(pitch);

    camera.position.set(
        cameraOrbitAnchor.x + dist * cosPitch * Math.sin(yaw),
        cameraOrbitAnchor.y + dist * Math.sin(pitch) + cameraHeight,
        cameraOrbitAnchor.z + dist * cosPitch * Math.cos(yaw)
    );

    const lookTarget = cameraOrbitAnchor.clone();
    lookTarget.y += cameraHeight;
    camera.lookAt(lookTarget);
    camera.updateProjectionMatrix();
}

function updateCameraFromKeys() {
    if (keysHeld.size === 0) {
        return;
    }

    let dirty = false;

    if (keysHeld.has('KeyW')) {
        cameraOrbit.dist -= CAM_ZOOM_SPEED;
        dirty = true;
    }

    if (keysHeld.has('KeyS')) {
        cameraOrbit.dist += CAM_ZOOM_SPEED;
        dirty = true;
    }

    if (keysHeld.has('KeyA')) {
        cameraOrbit.yaw -= CAM_ROTATE_SPEED;
        dirty = true;
    }

    if (keysHeld.has('KeyD')) {
        cameraOrbit.yaw += CAM_ROTATE_SPEED;
        dirty = true;
    }

    if (keysHeld.has('KeyQ')) {
        cameraHeight += CAM_LIFT_SPEED;
        dirty = true;
    }

    if (keysHeld.has('KeyE')) {
        cameraHeight -= CAM_LIFT_SPEED;
        dirty = true;
    }

    if (!dirty) {
        return;
    }

    cameraOrbit.dist = THREE.MathUtils.clamp(cameraOrbit.dist, camMinRadius, camMaxRadius);
    cameraOrbit.pitch = THREE.MathUtils.clamp(cameraOrbit.pitch, -1.2, 1.2);

    applyCameraOrbit();
}

function syncScriptedCamToGame() {
    fetchNui('syncScriptedCam', {
        position: threeToGamePosition(camera.position),
        rotation: {
            x: THREE.MathUtils.radToDeg(camera.rotation.x),
            y: THREE.MathUtils.radToDeg(-camera.rotation.z),
            z: THREE.MathUtils.radToDeg(camera.rotation.y),
        },
    });
}

function updateCameraKeycapVisuals() {
    controls.setCameraKeysPressed({
        w: keysHeld.has('KeyW'),
        a: keysHeld.has('KeyA'),
        s: keysHeld.has('KeyS'),
        d: keysHeld.has('KeyD'),
        q: keysHeld.has('KeyQ'),
        e: keysHeld.has('KeyE'),
    });
}

function updateCamera({ position, rotation }) {
    if (!gizmoEnabled || !position || cameraMode) {
        return;
    }

    camera.position.copy(gameToThreePosition(position));
    camera.rotation.order = 'YZX';

    if (rotation) {
        camera.rotation.set(
            THREE.MathUtils.degToRad(rotation.x),
            THREE.MathUtils.degToRad(zRotationHandler(rotation.x, rotation.z)),
            THREE.MathUtils.degToRad(rotation.y)
        );
    }

    camera.updateProjectionMatrix();
}

function applyGizmoTransform(entity) {
    gizmoObject.position.set(
        entity.position.x,
        entity.position.z + 0.5,
        -entity.position.y
    );

    gizmoObject.rotation.order = 'YZX';
    gizmoObject.rotation.set(
        THREE.MathUtils.degToRad(entity.rotation.x),
        THREE.MathUtils.degToRad(entity.rotation.z),
        THREE.MathUtils.degToRad(entity.rotation.y)
    );
}

function updateGizmoEntity(entity) {
    const handle = entity?.handle;

    if (handle == null) {
        hideGizmo();
        return;
    }

    currentEntity = handle;
    applyGizmoTransform(entity);

    if (gizmoEnabled) {
        return;
    }

    transformControls.attach(gizmoObject);
    transformControls.setMode(editorMode);
    showGizmo();
}

function handleObjectDataUpdate() {
    if (!gizmoEnabled || !currentEntity) {
        return;
    }

    fetchNui('moveEntity', {
        handle: currentEntity,
        position: {
            x: gizmoObject.position.x,
            y: -gizmoObject.position.z,
            z: gizmoObject.position.y - 0.5,
        },
        rotation: {
            x: THREE.MathUtils.radToDeg(gizmoObject.rotation.x),
            y: THREE.MathUtils.radToDeg(-gizmoObject.rotation.z),
            z: THREE.MathUtils.radToDeg(gizmoObject.rotation.y),
        },
    });
}

function toggleEditorMode() {
    if (!gizmoEnabled) {
        return;
    }

    const nextMode = editorMode === 'translate' ? 'rotate' : 'translate';
    editorMode = nextMode;
    transformControls.setMode(nextMode);
    controls.setMode(nextMode);
}

function handleControlAction(action) {
    if (!canAcceptControlInput()) {
        return;
    }

    switch (action) {
        case 'toggleMode':
            toggleEditorMode();
            break;
        case 'ground':
            fetchNui('placeOnGround', { handle: currentEntity });
            break;
        case 'apply':
            fetchNui('finishEdit');
            break;
        case 'cancel':
            fetchNui('stopEditing', { handle: currentEntity });
            break;
        default:
            break;
    }
}

window.addEventListener('keydown', (event) => {
    if (!gizmoEnabled) {
        return;
    }

    if (cameraMode && event.code === CAMERA_FOCUS_KEY) {
        if (!event.repeat) {
            focusCameraOnEntity();
            syncScriptedCamToGame();
            controls.setCameraFocusPressed(true);
        }
        event.preventDefault();
        return;
    }

    if (cameraMode && CAMERA_HOLD_KEY_CODES.has(event.code)) {
        if (!event.repeat) {
            keysHeld.add(event.code);
        }
        event.preventDefault();
        return;
    }

    const action = controls.getActionForCode(event.code);
    if (!action) {
        return;
    }

    if (event.repeat) {
        return;
    }

    keysHeld.add(event.code);
    controls.handleKeyDown(event);
    event.preventDefault();
});

window.addEventListener('keyup', (event) => {
    if (!gizmoEnabled) {
        return;
    }

    if (cameraMode && event.code === CAMERA_FOCUS_KEY) {
        controls.setCameraFocusPressed(false);
        event.preventDefault();
        return;
    }

    if (cameraMode && CAMERA_HOLD_KEY_CODES.has(event.code)) {
        keysHeld.delete(event.code);
        event.preventDefault();
        return;
    }

    if (!keysHeld.has(event.code)) {
        return;
    }

    keysHeld.delete(event.code);

    if (!canAcceptControlInput()) {
        controls.handleKeyUp(event, { triggerAction: false });
        return;
    }

    controls.handleKeyUp(event);
    event.preventDefault();
});

window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});

transformControls.addEventListener('objectChange', handleObjectDataUpdate);

function applyGizmoConfig(data) {

    if (data.lang) {
        controls.applyLang(data.lang);
    }

    if (data.dist) {
        const min = Number(data.dist.min);
        const max = Number(data.dist.max);
        camMinRadius = min;
        camMaxRadius = max;
        cameraOrbit.dist = THREE.MathUtils.clamp(cameraOrbit.dist, camMinRadius, camMaxRadius);

    }
}

onNuiEvent('addData', applyGizmoConfig);
onNuiEvent('setCameraPosition', updateCamera);
onNuiEvent('setGizmoEntity', updateGizmoEntity);
onNuiEvent('setCameraMode', (data) => {
    cameraMode = !!data?.enabled;
    controls.setCameraVisible(cameraMode);

    if (!cameraMode) {
        ['KeyW', 'KeyA', 'KeyS', 'KeyD', 'KeyQ', 'KeyE', CAMERA_FOCUS_KEY].forEach((code) =>
            keysHeld.delete(code)
        );
        controls.setCameraFocusPressed(false);
        cameraHeight = 0;
        updateCameraKeycapVisuals();
        return;
    }

    cameraHeight = 0;

    if (data.position) {
        initCameraOrbitFromGame(data.position, data.rotation);
        syncScriptedCamToGame();
    }
});

function animate() {
    requestAnimationFrame(animate);

    if (!gizmoEnabled) {
        return;
    }

    if (cameraMode) {
        updateCameraFromKeys();
        updateCameraKeycapVisuals();
        syncScriptedCamToGame();
    }

    renderer.render(scene, camera);
}

animate();
