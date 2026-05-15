const isEnvBrowser = () => !window.invokeNative;

const nuiHandlers = new Map();

window.addEventListener('message', (event) => {
  const message = event.data;

  if (!message || typeof message.action !== 'string') {
    return;
  }

  const handlers = nuiHandlers.get(message.action);
  if (!handlers) {
    return;
  }

  handlers.forEach((handler) => handler(message.data));
});

export function onNuiEvent(action, handler) {
  if (!nuiHandlers.has(action)) {
    nuiHandlers.set(action, new Set());
  }

  const handlers = nuiHandlers.get(action);
  handlers.add(handler);

  return () => handlers.delete(handler);
}

export async function fetchNui(eventName, data, mockData) {
  if (isEnvBrowser() && mockData !== undefined) {
    return mockData;
  }

  const resourceName = GetParentResourceName();

  const response = await fetch(`https://${resourceName}/${eventName}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(data),
  });

  try {
    return await response.json();
  } catch {
    return null;
  }
}
